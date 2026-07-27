#!/usr/bin/env bash
# Seed a dummy .env for static CI (compose config parse). Never use for real deploy.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
cp -f .env.example .env
# | delimiter so URLs with / do not break sed
sed -i.bak \
  -e 's|^TS_AUTHKEY=.*|TS_AUTHKEY=tskey-auth-ci-dummy|' \
  -e 's|^GOOGLE_CLIENT_ID=.*|GOOGLE_CLIENT_ID=ci.apps.googleusercontent.com|' \
  -e 's|^GOOGLE_CLIENT_SECRET=.*|GOOGLE_CLIENT_SECRET=ci-secret|' \
  -e 's|^GOOGLE_ALLOWED_USERS=.*|GOOGLE_ALLOWED_USERS=ci@example.com|' \
  -e 's|^EXTERNAL_URL=.*|EXTERNAL_URL=https://ci.example.ts.net|' \
  .env
rm -f .env.bak
echo "Seeded dummy .env for CI static checks"
