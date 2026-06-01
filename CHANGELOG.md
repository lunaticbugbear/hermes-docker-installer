# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Added `docs/QUICKSTART.md`, `docs/FAQ.md`, and `docs/GLOSSARY.md` for newcomer onboarding.
- Added `GOVERNANCE.md` documenting roles, decision classes, and release authority.
- Added `CITATION.cff` for citable project metadata.
- Added a question issue template for usage questions.
- Added an OpenSSF Scorecard workflow for supply-chain posture reporting.
- Added `.env.template` documenting every installer environment variable.
- Added CI jobs for workflow linting (actionlint), markdown link checking, and changelog enforcement on sensitive changes.
- Extended Dependabot to cover Docker base images alongside GitHub Actions.

### Changed
- Pinned all GitHub Actions to commit SHAs with version comments for supply-chain integrity.
- Reordered the README quick start so verify-before-install is the primary path and `curl | bash` is the fast path.

### Removed
- Removed synthetic SVG "visual proof" art and its generators in favor of an honest demo-pending note and the CI smoke test.

## [1.4.0] - 2026-06-01

### Added
- Added `MAINTAINERS.md` to make ownership, review scope, platform support, and release authority explicit.
- Added `ROADMAP.md` with public priorities, maintainer backlog, and suggested starter issues.
- Added `.gitattributes` to keep shell, docs, workflow, and PowerShell line endings predictable across platforms.
- Added `docs/RELEASE_VERIFICATION.md` with a release verification checklist.
- Added release provenance attestation and an SPDX SBOM to the release workflow.

### Changed
- Reframed `README.md` around reproducible local runtime value, trust signals, visual proof, and evidence links.
- Added a verify-before-install path to the README quick start.
- Expanded issue templates and PR template to collect better reproduction detail, scope, and risk notes.
- Strengthened `SECURITY.md` with disclosure timeline, supported-versions matrix, layered integrity guidance, and scope boundaries.
- Strengthened `SUPPORT.md` with clearer issue routing, triage contract, and support expectations.
- Extended docs sanity checks in CI to require new maintainer docs, README links, and release-trust wording guards.
- Expanded `docs/ARCHITECTURE.md`, `docs/OPERATIONS.md`, and `docs/RELEASE_PROCESS.md` to surface architecture, incident playbooks, and release verification more clearly.

## [1.3.0] - 2026-05-29

### Security
- Replaced `change-me` API_SERVER_KEY fallback with hard failure — container will not start without a key
- Made `GATEWAY_ALLOW_ALL_USERS` configurable via env var (defaults to true for backward compat)
- Replaced `source .env` in `hades url`/`hades key` commands with grep to prevent code execution

### Changed
- Pinned `HERMES_VERSION` to `v2026.5.29` instead of tracking `main` — prevents surprise breakage from upstream changes
- Added `PYTHON_VERSION` build arg to Dockerfile for reproducible image builds (default: `3.12-slim-bookworm`)
- Improved macOS Docker Desktop install: added download timeout (300s) and empty-file validation
- Replaced misleading `/dev/tcp` healthcheck fallback with explicit error message
- Fixed variable scoping: replaced `declare` with `printf -v` for API key assignment in interactive mode
- Aligned VERSION constant to match changelog
- PS1 `Safe-Write` now backs up existing files before overwrite (matches bash behavior)
- Added daily upstream Hermes release checker workflow (auto-PR when new tags appear)

## [1.2.0] - 2026-05-28

- Renamed project from Omnipod to **HADES** (Hermes Agent Docker Environment Script). Install directory is now `~/.hades/`, control command is now `hades`.
- Modernized release pipeline to use native GitHub CLI (`gh release`) instead of deprecated Node actions.
- Introduced repository social preview assets.
- Refactored all documentation to be concise and direct.
- Restructured README to prioritize installation and usage, moving deep-dives to `docs/`.

## [1.1.0] - 2026-05-28

- Added isolation guards (`PYTHONPATH` / `PYTHONHOME`) to prevent host environment bleed during builds.
- Added path registration for login shells (bash, zsh, fish).
- Built Windows integration with `hades.cmd` wrapper and PowerShell profile path registration.
- Switched interactive prompts to raw TTY `/dev/tty` so piping (`curl | bash`) works reliably.
- Hardened default API bind to `127.0.0.1` instead of `0.0.0.0`.
- Added uninstaller flags (`--dir`, `--remove-data`, `--remove-files`).
- Implemented `HERMES_VERSION` support for pinning specific upstream commits.

## [1.0.0] - 2026-05-27

- Initial release.
- Added cross-platform Docker scaffolding (Linux, macOS, Windows, WSL).
- Implemented multi-stage Dockerfile separating build and runtime.
- Built interactive setup flow for providers, models, and port allocation.
- Created `hades` command wrapper for container lifecycle management.
- Implemented automatic host dependency checks (Docker Daemon availability).
