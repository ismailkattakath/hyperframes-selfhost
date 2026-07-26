# Single image: mcp-auth-proxy (OAuth 2.1) + Kinocut (kino) + HyperFrames CLI.
# aarch64/amd64 multi-arch friendly (Debian bookworm base).

FROM node:22-bookworm-slim AS hyperframes-cli
# Pin the 0.x HyperFrames CLI — floating @latest is not reproducible.
ARG HYPERFRAMES_VERSION=0.7.73
RUN npm install -g "hyperframes@${HYPERFRAMES_VERSION}" \
  && command -v hyperframes \
  && (hyperframes --help >/dev/null 2>&1 || true)

FROM python:3.12-slim-bookworm

ARG MCP_AUTH_PROXY_VERSION=v2.10.2
ARG TARGETARCH

# ffmpeg + Chromium runtime libs (HyperFrames headless render) + tooling
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    fonts-liberation \
    fonts-noto-color-emoji \
    git \
    gnupg \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    wget \
    xdg-utils \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*

# Copy only Node + HyperFrames from the builder — do NOT overlay entire
# /usr/local onto Python's prefix (that can clobber the interpreter).
COPY --from=hyperframes-cli /usr/local/bin/node /usr/local/bin/node
COPY --from=hyperframes-cli /usr/local/bin/npm /usr/local/bin/npm
COPY --from=hyperframes-cli /usr/local/bin/npx /usr/local/bin/npx
COPY --from=hyperframes-cli /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN if [ -e /usr/local/lib/node_modules/hyperframes ]; then \
      ln -sfn /usr/local/lib/node_modules/hyperframes/bin/hyperframes /usr/local/bin/hyperframes \
      || ln -sfn ../lib/node_modules/.bin/hyperframes /usr/local/bin/hyperframes \
      || true; \
    fi

# Kinocut (MCP video surface + HyperFrames tools)
RUN pip install --no-cache-dir "kinocut[image]==1.11.1"
# mcp-auth-proxy static binary (release assets are plain binaries, not archives)
RUN set -eux; \
  arch="${TARGETARCH:-amd64}"; \
  case "$arch" in \
    amd64|x86_64) asset_arch=amd64 ;; \
    arm64|aarch64) asset_arch=arm64 ;; \
    *) echo "unsupported arch: $arch" >&2; exit 1 ;; \
  esac; \
  url="https://github.com/sigbit/mcp-auth-proxy/releases/download/${MCP_AUTH_PROXY_VERSION}/mcp-auth-proxy-linux-${asset_arch}"; \
  curl -fsSL "$url" -o /usr/local/bin/mcp-auth-proxy; \
  chmod 0755 /usr/local/bin/mcp-auth-proxy; \
  mcp-auth-proxy --help >/dev/null


RUN useradd --create-home --shell /usr/sbin/nologin --uid 10001 app \
  && mkdir -p /data /workspace \
  && chown -R app:app /data /workspace /home/app

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

USER app
WORKDIR /workspace
ENV HOME=/home/app \
    DATA_PATH=/data \
    MCP_VIDEO_ANALYTICS=0 \
    MCP_VIDEO_HYPERFRAMES_COMMAND=hyperframes \
    PATH="/usr/local/bin:${PATH}"

EXPOSE 8090
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
