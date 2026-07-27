# Architecture diagrams (Excalidraw-friendly)

GitHub cannot render binary `.excalidraw` files inline, so this project ships:

| Artifact | Use |
| --- | --- |
| [architecture.svg](./architecture.svg) | Primary README diagram — request path |
| [trust-boundary.svg](./trust-boundary.svg) | Security story — public / OAuth / private zones |
| README Mermaid block | Live-editable in PRs |

## Sketch offline (Excalidraw)

1. Open [excalidraw.com](https://excalidraw.com) (or the VS Code Excalidraw extension).
2. Prefer three horizontal zones: **Public edge → OAuth gate → Private render**.
3. Export **SVG** (not PNG) and replace the files above so the README stays crisp on light/dark GitHub.
4. Keep labels short and exact (`Tailscale Funnel`, `mcp-auth-proxy`, `GOOGLE_ALLOWED_USERS`).

## Why not only Excalidraw JSON?

Binary/JSON board files bit-rot and fail CI accessibility checks. **SVG + Mermaid** are the source of truth; Excalidraw is the authoring tool.

## Suggested palette (matches shipped SVGs)

- Background: `#0f172a` / `#111827`
- Funnel (public): sky `#38bdf8`
- Auth gate: violet `#a78bfa`
- Private render: emerald `#34d399`
- Neutral text: `#f8fafc` / `#94a3b8`
