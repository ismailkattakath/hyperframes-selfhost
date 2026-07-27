# Changelog

All notable changes to this project are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [SemVer](https://semver.org/) for tagged releases.

## [Unreleased]

### Added

- OSS hardening: CI (ShellCheck, Hadolint, Gitleaks, Trivy), Dependabot, nightly, Scorecard, release-on-tag
- SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, SUPPORT, LICENSE (Apache-2.0)
- Architecture SVG + Mermaid diagrams; credits section
- Branch-protection-friendly required `ci` workflow

### Changed

- Two-phase `install.sh` (Tailscale → EXTERNAL_URL → stack)
- Terraform public path is Terranix-forged `config.tf.json` only

## [0.1.0] — 2026-07-26

### Added

- Initial public packaging: Funnel + Caddy + mcp-auth-proxy + Kinocut + HyperFrames
