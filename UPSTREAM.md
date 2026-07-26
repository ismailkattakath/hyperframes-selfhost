# Upstream model

## Two repos

| Repo | Role |
| --- | --- |
| [kattakath/nix-config](https://github.com/kattakath/nix-config) | **Mother** — source of truth for compose/stack + **Terranix → Terraform JSON** |
| [ismailkattakath/hyperframes-selfhost](https://github.com/ismailkattakath/hyperframes-selfhost) | **Public product** — docs, CI, issues, releases; consumers need only Docker |

## What community users need

- This repo (clone or release tarball)
- Docker + compose
- Their own Tailscale auth key + Google OAuth Web client (manual once)
- **No Nix**

Primary command: `./install.sh`  
Optional: OpenTofu on `terraform/config.tf.json` (see `terraform/README.md`)

## What ships on every export from nix-config

- `install.sh`, `docker-compose.yml`, `Caddyfile`, `image/*`, `scripts/*`
- `.env.example` (never `.env`)
- `terraform/config.tf.json` **forged by Terranix** (replaces any prior TF in that path)
- Docs / README

## Maintainer habit (ismailkattakath)

| Change type | Where to edit |
| --- | --- |
| Compose, Dockerfile, install.sh, Caddy | `packages/hyperframes-selfhost/` in nix-config, then export PR here |
| Terraform resources / variables | `infra/hyperframes/stack.nix` in nix-config only → export overwrites `terraform/config.tf.json` |
| GitHub Actions, issue templates, community docs polish | **This** repo is fine |
| Secrets | Never commit; local `.env` only |

Direct TF edits in this repo are not forbidden for forks or one-off experiments; for the canonical upstream line, treat TF as **Nix-generated babies**.

## Independent forks

Fork freely. Edit anything including TF. You are not required to run nix-config. Rebase/cherry-pick from upstream as you like; expect `terraform/config.tf.json` to change on upstream releases when the mother forge runs again.
