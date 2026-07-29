# README explainer composition

Silent 24s product explainer for the root README — dogfooded on the self-host stack.

```bash
# From a machine with HyperFrames CLI (or inside the hf-mcp container):
npx hyperframes check
npx hyperframes render --quality high --output renders/video.mp4
```

In this monorepo’s live stack:

```bash
docker exec -e HYPERFRAMES_BROWSER_PATH=/usr/bin/chromium \
  -w /workspace/readme-explainer hf-mcp \
  hyperframes render --quality high --output /workspace/readme-explainer/renders/video.mp4
```

Shipped media: `docs/media/readme-explainer.webp` (README hero) and `docs/media/readme-explainer.mp4`.
