# HyperFrames Self-Host

Self-host **Kinocut + HyperFrames** on a Linux VM with:

| Layer | Tool | Why |
| --- | --- | --- |
| Public edge | **Tailscale Funnel** (VM only) | Host (Mac) stays isolated — no inbound, no Funnel on Darwin |
| Reverse proxy | **Caddy** | Simple HTTP reverse proxy + SSE-friendly flush |
| MCP OAuth | **[sigbit/mcp-auth-proxy](https://github.com/sigbit/mcp-auth-proxy)** | Battle-tested MCP OAuth 2.1 gateway (DCR/PKCE), Google IdP |
| App | **[Kinocut](https://github.com/KyaniteLabs/kinocut)** | Guardrailed video MCP with **18 HyperFrames tools** + FFmpeg |
| Renderer | **[HyperFrames](https://github.com/heygen-com/hyperframes)** CLI | Official open-source HTML → MP4 renderer (local, no HeyGen credits) |

> **Important:** HeyGen’s hosted MCP (`mcp.heygen.com`) is a **cloud product** and is **not** open-source.
> This stack self-hosts the open-source HyperFrames renderer behind Kinocut’s MCP surface.

```
Claude / Grok / Cursor
        │ HTTPS
        ▼
Tailscale Funnel  (inside the Linux VM only)
        │
        ▼
Caddy  (:8080)  ──reverse_proxy──▶  mcp-auth-proxy  ──stdio──▶  kino (Kinocut)
                                                              └─ HyperFrames CLI
```

## One-command install (on the Linux VM)

```bash
curl -fsSL https://raw.githubusercontent.com/kattakath/hyperframes-selfhost/main/install.sh | bash
```

Or from a clone:

```bash
git clone https://github.com/kattakath/hyperframes-selfhost.git
cd hyperframes-selfhost
./install.sh
```

`install.sh` will (two-phase):

1. Check Docker + compose
2. Copy `.env.example` → `.env` if missing; prompt for secrets
3. Start **Tailscale only** → wait for MagicDNS
4. Write `EXTERNAL_URL=https://<host>.ts.net`
5. Build/start Caddy + mcp-auth-proxy + Kinocut
6. Enable Funnel → `:8080` (or print the tailnet Funnel enable URL)
7. Print MCP URL + Google redirect URI

Full checklist: [docs/hyperframes-selfhost.md](../../docs/hyperframes-selfhost.md) in the nix-config monorepo.

## Prerequisites

### Runtime

- Docker Engine 24+ and Compose v2 (**Linux**, or Docker Desktop’s Linux engine on Mac)
- Outbound internet
- Tailscale account; **Funnel enabled** on the tailnet (one-time admin click)

### Google OAuth (Web application)

1. [Google Cloud Console](https://console.cloud.google.com/) → Google Auth Platform
2. Audience **External** (Internal needs Workspace)
3. Create **OAuth client ID** → type **Web application** (not Desktop)
4. After install prints the hostname, set **Authorized redirect URI**:
   ```
   https://<your-magicdns>.ts.net/.auth/google/callback
   ```
5. Prefer **Production** for long-lived MCP tokens (scopes are only openid/email/profile).  
   **Testing** is fine for smoke tests; add the same emails as Test users.
6. `GOOGLE_ALLOWED_USERS` must be **non-empty** comma-separated emails (proxy fail-open if empty).

Allowlisting:

- Proxy: `GOOGLE_ALLOWED_USERS` (authoritative for who may use the MCP)
- Google Testing test-user list: only if you stay in Testing mode

## Configuration

Copy and edit env:

```bash
cp .env.example .env
```

| Variable | Required | Description |
| --- | --- | --- |
| `TS_AUTHKEY` | yes | Tailscale auth key (reusable recommended for first join) |
| `TS_HOSTNAME` | no | MagicDNS name for the VM node (default `hyperframes`) |
| `GOOGLE_CLIENT_ID` | yes | Google OAuth web client ID |
| `GOOGLE_CLIENT_SECRET` | yes | Google OAuth client secret |
| `GOOGLE_ALLOWED_USERS` | yes | Comma-separated allowlist, e.g. `you@example.com` |
| `EXTERNAL_URL` | auto | Set by install to `https://<TS_HOSTNAME>.<tailnet>.ts.net` if empty |
| `WORKSPACE_DIR` | no | Host path mounted for media I/O (default `./workspace`) |

Secrets never go in git — only `.env` (gitignored).

## Connect an MCP client

After Funnel is up, add a **custom connector**:

| Client | Server URL |
| --- | --- |
| Claude.ai / Claude Desktop | `https://<hostname>.ts.net/mcp` |
| Grok | `https://<hostname>.ts.net/mcp` |
| Cursor / other | same |

On first connect the client runs OAuth → browser Google login → only allowlisted emails succeed.

## Day-2 ops

```bash
docker compose logs -f mcp          # auth proxy + kinocut
docker compose logs -f tailscale    # Funnel / MagicDNS
docker compose ps
docker compose restart mcp
./scripts/doctor.sh                 # local health + auth discovery probe
```

Rotate Google secret: update `.env` → `docker compose up -d mcp`.

Disable public access: `docker compose stop tailscale` (or remove Funnel in the Tailscale admin console). The stack stays reachable on the **tailnet only** if you switch Serve without Funnel.

## Terraform / OpenTofu (optional, demoted)

**Prefer `./install.sh`.** The `terraform/` directory is a secondary helper only.
Do not place terranix `config.tf.json` next to `main.tf` (duplicate resources).
Secrets in local tfstate are a risk — use install.sh for v1 operations.

## Nix operators (source of truth)

This tree is produced from the personal flake [kattakath/nix-config](https://github.com/kattakath/nix-config):

```bash
# On the Darwin host (nix-config checkout)
nix run .#hf-export -- ./dist/hyperframes-selfhost
# Then publish dist/ or rsync to the VM and run ./install.sh
```

Terranix module: `infra/hyperframes/stack.nix`  
Runbook: `docs/hyperframes-selfhost.md` in nix-config.

## Security model

- **Darwin host**: no Funnel, no public ports, no HyperFrames service.
- **Linux VM**: sole Funnel origin; Caddy only binds loopback shared with Tailscale.
- **Auth**: MCP OAuth 2.1 via mcp-auth-proxy; Google OAuth + explicit `GOOGLE_ALLOWED_USERS` allowlist (never empty).
- **Media**: workspace volume is local to the VM; no cloud render credits.

## License

Apache-2.0 for this packaging. Upstream licenses: Kinocut (Apache-2.0), HyperFrames (Apache-2.0), mcp-auth-proxy (see upstream).
