# Changelog

## 1.1.1 (2025-05-27)
- Added auto-install/auto-start Docker support for Windows and Linux/macOS.
- Installer detects OS and uses appropriate method (get.docker.com, brew, winget).
- Added logic for starting Docker daemon if it's found but idle.
- CI: Added smoke test and browser opt-in verification.

## 1.1.0 (2025-05-27)
- Multi-stage Dockerfile (builder + runtime).
- Browser (Playwright/Chromium) moved to `--browser` opt-in flag.
- Added pinning of Hermes Agent version via `HERMES_VERSION` env/flag.
- Full parity between `install.sh` and `install.ps1`.
- Added robust cleanup scripts (`uninstall.sh`, `uninstall.ps1`).
- API server config improvements and key passing logic.
- CI validation for shell, powershell, compose files, and generated helper scripts.

## 1.0.0 (2025-05-27)
- Initial release.
- Docker-based installer for Linux/macOS/WSL/PowerShell.
- Basic provider/model wizard.
- API server port collision detection.
- Helper script generation for CLI, logs, and updates.
