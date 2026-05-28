# Changelog

## Unreleased

- Switched release publishing from softprops/action-gh-release to native `gh release` calls to avoid Node deprecation warnings and make reruns cleaner.
- Added social preview assets under `assets/` — upload manually at repo Settings > General > Social preview.

## 1.1.6 (2026-05-28)

- Added maintainer docs under `docs/`: architecture overview, operations runbook, release process.
- CI now checks that required docs files exist.
- Tightened branch protection and label policy.

## 1.1.5 (2026-05-28)

- Release workflow now publishes installer scripts and `SHA256SUMS` to GitHub Releases.
- Added repository hygiene workflow to catch generated artifacts and accidental secrets.
- Added `SUPPORT.md` and `CODE_OF_CONDUCT.md`.
- CI checks for required repo standards files.
- Updated checkout action to v6.

## 1.1.4 (2026-05-28)

- Added `.editorconfig`, `CODEOWNERS`, Dependabot config, issue templates, and PR template.
- Updated checkout action to v5.
- Expanded CONTRIBUTING and SECURITY docs.
- README rewrite.
- Tightened `.gitignore` to exclude generated omnipod runtime files.

## 1.1.3 (2026-05-28)

- Added `PYTHONPATH` / `PYTHONHOME` isolation guards to prevent host Python environment leaking into the build.
- Switched interactive prompts to read from `/dev/tty` so `curl | bash` works correctly without stdin issues.
- Root installs now use `/usr/local/lib/omnipod` with a symlink at `/usr/local/bin/omnipod`.
- PATH registration for `bash`, `zsh`, and `fish` login shells.
- Windows PATH registration and `omnipod.cmd` wrapper.
- Docker build failures now surface the actual error instead of exiting silently.

## 1.1.2 (2026-05-27)

- Fixed `--uninstall` / `-Uninstall` running Docker checks before confirming uninstall intent.
- API port now binds to `127.0.0.1` by default.
- Removed hardcoded `container_name` from Compose to avoid conflicts with multiple installs.
- Browser layer in Dockerfile stays opt-out by default.
- Uninstaller now accepts `--dir`, `--remove-data`, `--remove-files` flags.
- CI guard for uninstall path.
- `--skip-build` / `-SkipBuild` now skips port collision check since nothing starts.

## 1.1.1 (2026-05-27)

- Installer auto-detects and installs Docker if missing (get.docker.com on Linux, brew on macOS, winget on Windows).
- Starts the Docker daemon automatically if installed but not running.
- CI: added smoke test and browser opt-in check.

## 1.1.0 (2026-05-27)

- Multi-stage Dockerfile (builder + slim runtime).
- Browser support (Playwright/Chromium) moved behind `--browser` flag.
- `HERMES_VERSION` flag for pinning a specific Hermes branch or tag.
- `install.sh` and `install.ps1` now fully in sync.
- Added `uninstall.sh` and `uninstall.ps1`.
- CI covers shell, PowerShell, Compose, and generated helper scripts.

## 1.0.0 (2026-05-27)

- Initial release.
- Docker-based installer for Linux, macOS, WSL, and Windows.
- Interactive provider/model/key wizard.
- Port collision detection.
- Helper script generation.
