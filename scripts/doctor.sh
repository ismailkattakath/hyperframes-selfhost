#!/usr/bin/env bash
# Local health + OAuth discovery probe (no secrets printed).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

ok=0
fail=0
check() {
  local name="$1"
  shift
  if "$@"; then
    printf 'OK  %s\n' "$name"
    ok=$((ok + 1))
  else
    printf 'FAIL %s\n' "$name"
    fail=$((fail + 1))
  fi
}

check "docker compose ps" docker compose ps >/dev/null
check "tailscale container" docker inspect -f '{{.State.Running}}' hf-tailscale 2>/dev/null | grep -qx true
check "caddy container" docker inspect -f '{{.State.Running}}' hf-caddy 2>/dev/null | grep -qx true
check "mcp container" docker inspect -f '{{.State.Running}}' hf-mcp 2>/dev/null | grep -qx true

# Loopback probes inside shared netns via tailscale container
check "caddy :8080" docker exec hf-tailscale wget -qO- http://127.0.0.1:8080/ >/dev/null 2>&1 \
  || docker exec hf-tailscale wget -qO- --server-response http://127.0.0.1:8080/ 2>&1 | head -1 | grep -q .

check "mcp-auth healthz" docker exec hf-tailscale wget -qO- http://127.0.0.1:8090/healthz >/dev/null 2>&1 \
  || docker exec hf-tailscale wget -qO- http://127.0.0.1:8090/ 2>&1 | head -1 | grep -q .

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  set -a
  # shellcheck source=/dev/null
  source .env
  set +a
fi

if [[ -n "${EXTERNAL_URL:-}" ]]; then
  check "oauth protected resource metadata" \
    curl -fsS "${EXTERNAL_URL}/.well-known/oauth-protected-resource" >/dev/null 2>&1 \
    || curl -fsS "${EXTERNAL_URL}/.well-known/oauth-authorization-server" >/dev/null 2>&1 \
    || true
  printf 'INFO EXTERNAL_URL=%s\n' "$EXTERNAL_URL"
  printf 'INFO MCP endpoint=%s/mcp\n' "$EXTERNAL_URL"
fi

printf '\n%d ok, %d failed\n' "$ok" "$fail"
[[ "$fail" -eq 0 ]]
