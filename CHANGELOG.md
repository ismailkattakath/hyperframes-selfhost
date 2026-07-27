# Changelog

All notable changes to this project are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [SemVer](https://semver.org/) for tagged releases.

## [Unreleased]

### Added

- Trust-boundary diagram (public / OAuth / private zones)
- Dependabot ignores major Node/Python base bumps (stay on 22 / 3.12 until revalidated)

## [0.1.0] — 2026-07-27

### Added

- Initial public packaging: Funnel + Caddy + mcp-auth-proxy + Kinocut + HyperFrames
- OSS hardening: CI (ShellCheck, Hadolint, Gitleaks, Trivy), Dependabot, nightly, Scorecard, release-on-tag
- SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, SUPPORT, LICENSE (Apache-2.0)
- Architecture SVG + Mermaid diagrams; credits section
- Branch protection on `main` (required checks, conversation resolution, linear history)

### Changed

- Two-phase `install.sh` (Tailscale → EXTERNAL_URL → stack)
- Terraform public path is Terranix-forged `config.tf.json` only
