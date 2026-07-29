# Grant one-pager — HyperFrames Self-Host

**Project:** HyperFrames Self-Host  
**License:** Apache-2.0  
**Repo:** https://github.com/ismailkattakath/hyperframes-selfhost  
**Maintainer:** Ismail Kattakath (https://github.com/ismailkattakath)

## Summary (≤120 words)

HyperFrames Self-Host is an open packaging of the Kinocut video MCP and HyperFrames HTML→MP4 renderer behind a public HTTPS edge (Tailscale Funnel), reverse proxy (Caddy), and OAuth 2.1 gateway (mcp-auth-proxy + Google allowlist). Cloud agents get a normal MCP URL; renders stay on the operator’s machine. It is **not** HeyGen’s hosted MCP. The stack is Docker Compose installable without Nix, with CI, Scorecard, Dependabot, and a dogfooded README explainer rendered on the same stack.

## Problem

1. Agent platforms need **reachable** MCP endpoints.  
2. Hosted video MCP exports media and meters cloud credits.  
3. DIY self-host often means **open ports**, no OAuth, or brittle tunnels.

## Solution

| Layer | Component |
| --- | --- |
| Public edge | Tailscale Funnel |
| Reverse proxy | Caddy |
| AuthZ | mcp-auth-proxy · Google OAuth · email allowlist |
| MCP surface | Kinocut |
| Renderer | HyperFrames CLI → workspace MP4 |

## Why fund / support

- **Digital sovereignty:** media never required to leave the host.  
- **Reusable pattern:** same edge+OAuth envelope for other sensitive MCPs.  
- **Security posture:** empty allowlist forbidden; scanners in CI; no secret-in-image.  
- **Commons:** composes existing OSI projects; documentation for operators.

## Work packages (sample €25k / 6 months)

| WP | Outcome |
| --- | --- |
| WP1 Hardened multi-arch images | arm64/amd64 GHCR; Chromium path fixed; signed digests |
| WP2 Threat model + audit notes | Public ADRs; Funnel/OAuth trust boundaries |
| WP3 Installer UX | `install.sh` + doctor; Windows/Linux smoke matrix |
| WP4 Ecosystem docs | Upstream READMEs links; example client configs |
| WP5 Sustainability | Sponsors, CODEOWNERS, release automation |

## Success metrics

- Independent public deploy reports  
- Scorecard / Dependabot green  
- Upstream documentation links  
- Stars/forks as weak proxy for adoption  

## Contact

GitHub issues on the repository · profile: ismailkattakath  
