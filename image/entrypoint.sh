#!/usr/bin/env bash
# Launch mcp-auth-proxy in front of Kinocut's stdio MCP (`kino`).
set -euo pipefail

: "${EXTERNAL_URL:?EXTERNAL_URL is required (https://your-node.ts.net)}"
: "${GOOGLE_CLIENT_ID:?GOOGLE_CLIENT_ID is required}"
: "${GOOGLE_CLIENT_SECRET:?GOOGLE_CLIENT_SECRET is required}"
: "${GOOGLE_ALLOWED_USERS:?GOOGLE_ALLOWED_USERS is required}"

LISTEN="${LISTEN:-:8090}"
DATA_PATH="${DATA_PATH:-/data}"
mkdir -p "$DATA_PATH"

# Prefer `kino` (Kinocut); fall back to legacy `mcp-video` shim if present.
if command -v kino >/dev/null 2>&1; then
  MCP_CMD=(kino)
elif command -v mcp-video >/dev/null 2>&1; then
  MCP_CMD=(mcp-video)
else
  echo "ERROR: neither kino nor mcp-video found on PATH" >&2
  exit 1
fi

# Best-effort HyperFrames presence (Kinocut soft-requires it for HF tools).
if ! command -v hyperframes >/dev/null 2>&1; then
  echo "WARN: hyperframes CLI not on PATH — Kinocut HyperFrames tools may fail" >&2
fi

exec mcp-auth-proxy \
  --external-url "$EXTERNAL_URL" \
  --listen "$LISTEN" \
  --no-auto-tls \
  --data-path "$DATA_PATH" \
  --google-client-id "$GOOGLE_CLIENT_ID" \
  --google-client-secret "$GOOGLE_CLIENT_SECRET" \
  --google-allowed-users "$GOOGLE_ALLOWED_USERS" \
  -- "${MCP_CMD[@]}"
