# Security Policy

## Supported versions

| Version | Supported |
| --- | --- |
| `main` (rolling) | ✅ |
| Tagged releases (`v*`) | ✅ until superseded by the next tag |
| Unmodified forks | Security is the fork operator’s responsibility |

## What this project is

A **self-host packaging** of third-party components (Tailscale Funnel, Caddy,
mcp-auth-proxy, Kinocut, HyperFrames). Security depends on:

1. Your secrets (Tailscale key, Google OAuth client secret)
2. Keeping images/pins updated (Dependabot PRs)
3. Never shipping with an empty `GOOGLE_ALLOWED_USERS` allowlist
4. Only enabling Funnel when you intend public exposure

## Reporting a vulnerability

**Please do not open a public issue for security problems.**

1. Use GitHub **Private vulnerability reporting** on this repository  
   (Security → Report a vulnerability), **or**
2. Email the maintainer via the address on their GitHub profile with subject  
   `[SECURITY] hyperframes-selfhost`

Include: description, impact, reproduction steps, and whether a fix is known.

We aim to acknowledge within **72 hours** and ship a fix or mitigation as soon
as practical for confirmed issues.

## Dependency and supply-chain checks

CI runs (on PRs and main):

- **Gitleaks** — no accidental secrets
- **Trivy** — filesystem / Dockerfile misconfig and vulnerability scan
- **Hadolint** — Dockerfile best practices
- **ShellCheck** — shell script hygiene
- **Compose config** validation

Operators should also run `docker compose pull` / rebuild on Dependabot updates.

## Hardening checklist for operators

- [ ] `GOOGLE_ALLOWED_USERS` is non-empty and limited to real operators
- [ ] Google OAuth redirect URI is exact (no wildcards you don’t control)
- [ ] Funnel is intentional; disable with `tailscale funnel --https=443 off` when unused
- [ ] `.env` is mode `0600` and never committed
- [ ] Auth keys are rotated if leaked
