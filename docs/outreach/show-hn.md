# Show HN package

## Title (≤80)

Show HN: Self-host a video MCP behind Tailscale Funnel and Google OAuth

## First comment (post immediately after)

HyperFrames Self-Host is a Docker Compose stack that exposes Kinocut + HyperFrames as an MCP server for Claude/Grok/Cursor, without opening home-router ports or using HeyGen cloud credits.

Path:

  Client → Tailscale Funnel → Caddy → mcp-auth-proxy (Google OAuth + email allowlist) → Kinocut → HyperFrames → local MP4

Not affiliated with HeyGen’s hosted MCP (mcp.heygen.com). This packages the OSS renderer.

Why I built it: I wanted cloud agents to call video tools while keeping renders on my machine and a real identity gate (empty allowlist is refused at boot).

Dogfood: the README explainer video was rendered on this stack.

Repo: https://github.com/ismailkattakath/hyperframes-selfhost  
Install: clone, .env (TS_AUTHKEY + Google OAuth), ./install.sh  

Happy to discuss threat model (Funnel vs Cloudflare Tunnel vs open ports) or ARM64 Chromium quirks.
