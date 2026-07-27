# Contributing

Thanks for helping make self-hosted HyperFrames MCP safer and easier.

## Code of conduct

By participating, you agree to uphold our [Code of Conduct](./CODE_OF_CONDUCT.md).

## Ways to contribute

| Kind | How |
| --- | --- |
| Bug reports | [Issue templates](./.github/ISSUE_TEMPLATE/) |
| Docs / clarity | PR against `main` |
| Install / compose fixes | PR with CI green |
| Security | See [SECURITY.md](./SECURITY.md) — **not** public issues |

## Development setup

You only need **Docker** (and Compose v2). **Nix is not required.**

```bash
git clone https://github.com/ismailkattakath/hyperframes-selfhost.git
cd hyperframes-selfhost
cp .env.example .env
# fill secrets for a full local run, or use dummy values for static CI checks
./scripts/ci-seed-env.sh   # seeds dummy .env for lint-only validation
docker compose config -q
```

Static checks (same idea as CI):

```bash
./scripts/ci-static.sh
```

## Pull requests

1. Branch from `main`: `git checkout -b fix/short-description`
2. Keep PRs focused (one concern)
3. Ensure CI is green
4. Fill out the PR template
5. Prefer small commits with complete sentences in messages

### Branch rules

- Default branch is **`main`**
- PRs require CI status checks (see branch protection)
- Direct pushes to `main` are restricted for maintainers of the public product

## Terraform note

`terraform/config.tf.json` is **generated** from the mother repo’s Terranix
stack for upstream maintainers. Independent forks may edit it freely. See
[UPSTREAM.md](./UPSTREAM.md) and [terraform/README.md](./terraform/README.md).

## Coding style

- Shell: `set -euo pipefail`; ShellCheck-clean where practical
- Dockerfile: Hadolint-clean; pin versions
- No secrets in git; only `.env.example`

## Testing philosophy

This is **infrastructure packaging**, not an application library. We do **not**
aim for Codecov-style unit coverage theater. CI emphasizes:

- Config validity (compose, Terraform JSON)
- Script safety (ShellCheck)
- Container supply chain (Hadolint, Trivy)
- Secret leak prevention (Gitleaks)
- Nightly regression of the same gates

Live Funnel + Google OAuth browser flows remain **operator smoke tests**
(documented in the test plan) because they need real accounts.
