# Terraform / OpenTofu (generated)

**Preferred path for humans:** `../install.sh` (Docker Compose).

## What ships here

| File | Source |
| --- | --- |
| `config.tf.json` | **Generated** by Terranix from `kattakath/nix-config` (`infra/hyperframes/stack.nix`) via `nix run .#hf-export` |

There is intentionally **no** hand-edited `main.tf` in the public export. A second HCL file would collide with this JSON module.

## Upstream maintainers (ismailkattakath)

Terraform changes are made in the **Nix mother** repo, not by hand here:

1. Edit `infra/hyperframes/stack.nix` in [kattakath/nix-config](https://github.com/kattakath/nix-config)
2. `nix run .#hf-export -- /tmp/hf`
3. Open a PR into this repo replacing `terraform/config.tf.json` (and the rest of the tree)

Editing `config.tf.json` directly in this repo works for experiments, but the next export from nix-config will **overwrite** it. Prefer nix-config for lasting TF changes.

## Independent forks

You do **not** need Nix. Treat `config.tf.json` as normal OpenTofu:

```bash
# Still usually easier:
../install.sh

# Or:
export TF_VAR_ts_authkey=…
export TF_VAR_google_client_id=…
export TF_VAR_google_client_secret=…
export TF_VAR_external_url=https://your-node.ts.net
export TF_VAR_stack_dir="$(cd .. && pwd)"
export TF_VAR_google_allowed_users=you@example.com
tofu init
tofu apply
```

Forks may edit TF freely; they are not bound by the mother-repo export cycle.

## Secrets warning

Apply writes a local `.env` and may store sensitive values in **tfstate**. Prefer `install.sh` for interactive personal use; use remote encrypted state if you keep TF for automation.
