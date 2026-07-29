---
workflow: product-launch-video
flow: automation
storyboard: no
message: "Self-host Kinocut + HyperFrames MCP behind OAuth and Tailscale Funnel — local renders, private host."
destination: github-readme
aspect: 1920x1080
language: en
length: 24s
angle: product-architecture
audience: developers evaluating self-hosted video MCP
style_preset: dark-terminal
---

## Intent

Silent README hero explainer for ismailkattakath/hyperframes-selfhost, matching the
OG HyperFrames motion-hero pattern (inline animated media, no VO). Market the
product: public MCP URL for agents without opening the laptop, Google OAuth +
email allowlist, local HyperFrames renders, no HeyGen cloud credits.

Tone: confident infrastructure OSS — dark slate, sky/violet/emerald stack colors
from docs/diagrams/architecture.svg. Typography-first motion graphics.

## Assets

- Brand palette from architecture.svg (slate canvas, sky funnel, violet auth, emerald app)
- No site capture (no-capture mode); diagram aesthetics only

## Customizations

- Fully silent (`music: none`, no SCRIPT.md) for GitHub README autoplay
- 16:9 landscape for README width ~800–900
- Dogfood: render via the live self-host stack container `hf-mcp`

## Notes

- Not affiliated with HeyGen hosted MCP at mcp.heygen.com
- Deliverables: MP4 + animated WebP for README embed
