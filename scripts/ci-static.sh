#!/usr/bin/env bash
# Local mirror of static CI gates (no secrets, no live Funnel).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail=0
run() {
  echo "==> $*"
  if ! "$@"; then
    echo "FAIL: $*"
    fail=1
  fi
}

./scripts/ci-seed-env.sh

run test -f .env.example
run test ! -f terraform/main.tf
run test -f terraform/config.tf.json
run python3 -c 'import json; json.load(open("terraform/config.tf.json"))'
run docker compose config -q

if command -v shellcheck >/dev/null 2>&1; then
  run shellcheck -x install.sh scripts/*.sh image/entrypoint.sh
else
  echo "WARN: shellcheck not installed (CI installs it)"
fi

if command -v hadolint >/dev/null 2>&1; then
  run hadolint image/Dockerfile || true
else
  echo "WARN: hadolint not installed (CI installs it)"
fi

if [[ "$fail" -ne 0 ]]; then
  echo "Static checks failed"
  exit 1
fi
echo "Static checks passed"
