# Setup guide

Operator checklist for a first successful deploy. For monorepo context see
`docs/hyperframes-selfhost.md` in [kattakath/nix-config](https://github.com/kattakath/nix-config).

## 1. Secrets (manual once)

### Tailscale

1. Enable Funnel on your tailnet (admin may show a one-time enable URL).
2. Generate an **auth key**: Reusable **ON**, Ephemeral **OFF**.
3. Put it in `.env` as `TS_AUTHKEY=tskey-auth-…`.

### Google OAuth

1. Consent screen **External**.
2. Create **Web application** client (not Desktop).
3. After install prints MagicDNS, set redirect URI:
   `https://<host>.ts.net/.auth/google/callback`
4. Prefer **Production** for long-lived tokens; Testing needs Test users.
5. `GOOGLE_ALLOWED_USERS` = comma-separated emails (**never empty**).

## 2. Install

```bash
cp .env.example .env
# edit secrets
./install.sh
```

Two-phase: Tailscale join → set `EXTERNAL_URL` → build Caddy + MCP → Funnel.

## 3. Verify

```bash
./scripts/doctor.sh
# Expect 401 without a token:
curl -i -X POST "https://<host>.ts.net/mcp" -H 'content-type: application/json' -d '{}'
```

If DNS fails on your laptop for `*.ts.net`, query a public resolver:

```bash
dig +short <host>.ts.net @8.8.8.8
```

## 4. Connect

MCP server URL: `https://<host>.ts.net/mcp`  
Complete Google login as an allowlisted user.
