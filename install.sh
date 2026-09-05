#!/usr/bin/env bash
# One-command installer for HyperFrames self-host on Linux (or Docker Desktop
# aarch64/amd64 Linux VM). Safe to re-run. Never prints secret values.
#
# Proven cold path (2026-07-26): two-phase start — Tailscale first for MagicDNS,
# then set EXTERNAL_URL, then build/start Caddy + mcp-auth-proxy + Kinocut.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
info() { printf '→ %s\n' "$*"; }
warn() { printf '⚠ %s\n' "$*" >&2; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"; }

set_env_var() {
  local var="$1" val="$2"
  local tmp
  tmp="$(mktemp)"
  if grep -qE "^${var}=" .env 2>/dev/null; then
    awk -v k="$var" -v v="$val" 'BEGIN{FS=OFS="="} $1==k{$0=k"="v} {print}' .env >"$tmp"
  else
    cat .env >"$tmp" 2>/dev/null || true
    printf '%s=%s\n' "$var" "$val" >>"$tmp"
  fi
  mv "$tmp" .env
  export "${var}=${val}"
}

bold "HyperFrames self-host installer"
info "Root: $ROOT"

# ---- Preflight ---------------------------------------------------------------
# Docker Desktop on macOS is fine: the engine is still Linux (arm64/amd64).
if [[ "$(uname -s)" == "Darwin" ]]; then
  warn "Host is macOS — expecting Docker Desktop Linux engine (not native Darwin containers)"
fi

need_cmd docker
# python3 parses `tailscale status --json` to get the MagicDNS name. Without it
# that parse silently yields nothing, the poll below burns its full 180s
# deadline, and the script then dies telling you to check TS_AUTHKEY — blaming
# the wrong thing entirely. Fail here with the real reason instead.
need_cmd python3
docker compose version >/dev/null 2>&1 || die "Docker Compose v2 required (docker compose)"
docker info >/dev/null 2>&1 || die "Docker daemon not running (start Docker Desktop / dockerd)"

if [[ ! -f .env ]]; then
  info "Creating .env from .env.example"
  cp .env.example .env
  chmod 600 .env || true
fi

# shellcheck disable=SC1091
set -a
# shellcheck source=/dev/null
source .env
set +a

prompt_if_empty() {
  local var="$1" label="$2" secret="${3:-0}"
  local cur="${!var:-}"
  if [[ -n "$cur" && "$cur" != *REPLACE_ME* ]]; then
    return 0
  fi
  if [[ ! -t 0 ]]; then
    die "$var is empty; set it in .env for non-interactive install"
  fi
  if [[ "$secret" == "1" ]]; then
    read -r -s -p "$label: " cur
    echo
  else
    read -r -p "$label: " cur
  fi
  [[ -n "$cur" ]] || die "$var still empty"
  set_env_var "$var" "$cur"
}

prompt_if_empty TS_AUTHKEY "Tailscale auth key (tskey-auth-…)" 1
prompt_if_empty GOOGLE_CLIENT_ID "Google OAuth client ID"
prompt_if_empty GOOGLE_CLIENT_SECRET "Google OAuth client secret" 1
prompt_if_empty GOOGLE_ALLOWED_USERS "Allowlisted emails (comma-separated)"

TS_HOSTNAME="${TS_HOSTNAME:-hyperframes}"
set_env_var TS_HOSTNAME "$TS_HOSTNAME"

# compose requires EXTERNAL_URL at parse time — bootstrap then replace after DNS.
if [[ -z "${EXTERNAL_URL:-}" || "$EXTERNAL_URL" == "https://bootstrap.invalid" ]]; then
  info "EXTERNAL_URL empty — using temporary bootstrap; will rewrite after MagicDNS"
  set_env_var EXTERNAL_URL "https://bootstrap.invalid"
fi

mkdir -p "${WORKSPACE_DIR:-./workspace}" config
chmod +x image/entrypoint.sh scripts/doctor.sh 2>/dev/null || true

# ---- Phase 1: Tailscale only (join + MagicDNS) ------------------------------
bold "Phase 1: Tailscale join"
docker compose pull tailscale || true
docker compose up -d tailscale

info "Waiting for Tailscale MagicDNS…"
deadline=$((SECONDS + 180))
dns_name=""
while ((SECONDS < deadline)); do
  if dns_name="$(
    docker exec hf-tailscale tailscale status --json 2>/dev/null \
      | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("Self",{}).get("DNSName","").rstrip("."))' 2>/dev/null
  )"; then
    if [[ -n "$dns_name" ]]; then
      break
    fi
  fi
  st="$(docker inspect -f '{{.State.Status}}' hf-tailscale 2>/dev/null || echo missing)"
  if [[ "$st" == "restarting" ]]; then
    warn "hf-tailscale restarting — last logs:"
    docker compose logs --tail 20 tailscale || true
  fi
  sleep 4
done

if [[ -z "$dns_name" ]]; then
  docker compose logs --tail 80 tailscale || true
  die "Could not resolve MagicDNS. Check TS_AUTHKEY and: docker compose logs tailscale"
fi

url="https://${dns_name}"
info "MagicDNS: $dns_name"
set_env_var EXTERNAL_URL "$url"

# ---- Phase 2: Caddy + mcp-auth-proxy + Kinocut ------------------------------
bold "Phase 2: build + start Caddy and MCP"
# Re-source so compose sees the new EXTERNAL_URL
set -a
# shellcheck source=/dev/null
source .env
set +a

docker compose pull caddy || true
docker compose up -d --build

# ---- Funnel (public HTTPS) ---------------------------------------------------
info "Ensuring Tailscale Funnel → 127.0.0.1:8080…"
if ! docker exec hf-tailscale tailscale funnel status 2>/dev/null | grep -q 'Funnel on'; then
  if ! docker exec hf-tailscale tailscale funnel --bg http://127.0.0.1:8080 2>/dev/null; then
    warn "Funnel not enabled on this tailnet yet."
    warn "Open the URL printed by: docker exec hf-tailscale tailscale funnel --bg http://127.0.0.1:8080"
    warn "Typically: https://login.tailscale.com/f/funnel?node=…"
  fi
fi

# ---- Wait for mcp health -----------------------------------------------------
info "Waiting for mcp-auth-proxy healthz…"
ok=0
for _ in $(seq 1 40); do
  if docker exec hf-tailscale wget -qO- http://127.0.0.1:8090/healthz 2>/dev/null | grep -q ok; then
    ok=1
    break
  fi
  sleep 3
done
if [[ "$ok" -ne 1 ]]; then
  warn "healthz not ready — check: docker logs hf-mcp"
  docker logs hf-mcp 2>&1 | tail -40 || true
fi

# ---- Summary -----------------------------------------------------------------
bold "Install complete"
cat <<EOF

Public base URL:
  ${EXTERNAL_URL}

MCP connector URL (Claude / Grok / Cursor):
  ${EXTERNAL_URL}/mcp

Google OAuth redirect URI (Web client → Authorized redirect URIs):
  ${EXTERNAL_URL}/.auth/google/callback

Allowlisted emails (mcp-auth-proxy --google-allowed-users, CSV-split):
  ${GOOGLE_ALLOWED_USERS}

Also add the same emails as Google OAuth consent **Test users** while in Testing,
or publish the app to Production (basic openid/email/profile scopes).

Ops:
  docker compose ps
  docker compose logs -f
  ./scripts/doctor.sh
  # Public probe (use a public DNS resolver if host MagicDNS fails):
  #   dig +short ${dns_name} @8.8.8.8
  #   curl -i -X POST ${EXTERNAL_URL}/mcp -H 'content-type: application/json' -d '{}'

EOF
