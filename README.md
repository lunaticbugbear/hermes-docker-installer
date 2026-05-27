# Hermes Agent Docker Installer

[![CI](https://github.com/lunaticbugbear/hermes-docker-installer/actions/workflows/ci.yml/badge.svg)](https://github.com/lunaticbugbear/hermes-docker-installer/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Public-quality cross-platform installer for running Hermes Agent in Docker.

This project makes Hermes Agent easy to install for non-technical users while keeping the runtime isolated, reproducible, updateable, and easy to uninstall.

## What it installs

- Hermes Agent inside a Docker container
- Docker Compose stack
- Persistent Hermes home volume
- Mounted workspace folder
- API Server gateway on `http://localhost:8642` by default
- Optional browser tooling via Playwright + Chromium
- Helper commands for CLI, logs, update, reset, and uninstall

## Repository layout

```text
install.sh                 Linux/macOS/WSL installer
install.ps1                Windows PowerShell installer
uninstall.sh               Linux/macOS/WSL uninstall helper
uninstall.ps1              Windows uninstall helper
README.md                  User docs
CONTRIBUTING.md            Contributor checks
SECURITY.md                Security policy
CHANGELOG.md               Release notes
.github/workflows/ci.yml   CI validation
```

## Requirements

### Linux

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Log out and back in, then rerun the installer.

### macOS

Install Docker Desktop:

https://docs.docker.com/desktop/install/mac-install/

Start Docker Desktop before running the installer.

Optional Homebrew install:

```bash
brew install --cask docker
```

### Windows

Recommended: use `install.ps1` from PowerShell.

Install Docker Desktop with WSL2 backend enabled:

https://docs.docker.com/desktop/install/windows-install/

Make sure Docker Desktop is running before installing.

## Quick install

### Linux / macOS / WSL

```bash
curl -fsSL https://raw.githubusercontent.com/lunaticbugbear/hermes-docker-installer/main/install.sh | bash
```

Or from a local clone:

```bash
chmod +x install.sh
./install.sh
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/lunaticbugbear/hermes-docker-installer/main/install.ps1 | iex
```

Or from a local clone:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

## Non-interactive install

Linux/macOS/WSL:

```bash
HERMES_NONINTERACTIVE=1 \
OPENROUTER_API_KEY="your-key" \
bash install.sh \
  --provider openrouter \
  --model deepseek/deepseek-v4-flash:free \
  --port 8642
```

Windows:

```powershell
.\install.ps1 `
  -Provider openrouter `
  -Model deepseek/deepseek-v4-flash:free `
  -OpenRouterApiKey "your-key" `
  -Port 8642
```

## Providers

Supported provider choices:

- `openrouter`
- `anthropic`
- `openai`
- `google`
- `deepseek`
- `custom` OpenAI-compatible endpoint

Examples:

```bash
./install.sh --provider anthropic --model claude-sonnet-4
./install.sh --provider openai --model gpt-4.1
./install.sh --provider google --model gemini-2.0-flash
./install.sh --provider deepseek --model deepseek-chat
```

For custom endpoint:

```bash
CUSTOM_BASE_URL="https://your-openai-compatible-api/v1" \
CUSTOM_API_KEY="your-key" \
./install.sh --provider custom --model your-model
```

## After install

Default install folder:

- Linux/macOS/WSL: `~/.hermes-docker`
- Windows: `%USERPROFILE%\.hermes-docker`

Open Hermes CLI:

```bash
cd ~/.hermes-docker
./bin/hermes-docker cli
```

Windows:

```powershell
cd $env:USERPROFILE\.hermes-docker
.\hermes-docker.ps1 cli
```

View logs:

```bash
./bin/hermes-docker logs
```

Start / stop / restart:

```bash
./bin/hermes-docker start
./bin/hermes-docker stop
./bin/hermes-docker restart
```

Update:

```bash
./bin/hermes-docker update
```

Print API URL and key:

```bash
./bin/hermes-docker url
./bin/hermes-docker key
```

## Files and data

Generated runtime files:

```text
~/.hermes-docker/
  .env
  Dockerfile
  bootstrap.sh
  healthcheck.sh
  docker-compose.yml
  README.md
  bin/hermes-docker
  workspace/
```

Persistent Hermes data is stored in Docker volume:

```text
hermes_home
```

The workspace folder is bind-mounted:

```text
host:      ~/.hermes-docker/workspace
container: /workspace
```

## API server

The installer enables Hermes API Server through the gateway config.

Default URL:

```text
http://localhost:8642
```

Default API key is generated automatically and stored in `.env`.

Use it with clients that support OpenAI-compatible endpoints / Hermes API server.

## Uninstall

Keep data volume:

```bash
./uninstall.sh
```

Remove data volume too:

```bash
REMOVE_DATA=1 ./uninstall.sh
```

Remove generated files too:

```bash
REMOVE_FILES=1 ./uninstall.sh
```

Windows:

```powershell
.\uninstall.ps1
.\uninstall.ps1 -RemoveData
.\uninstall.ps1 -RemoveFiles
```

## Troubleshooting

### Docker not found

Install Docker Desktop or Docker Engine first.

### Docker installed but not reachable

Linux:

```bash
sudo systemctl start docker
sudo usermod -aG docker $USER
```

Then log out and back in.

macOS/Windows:

Start Docker Desktop and wait until it says Docker is running.

### Port already in use

Use a different port:

```bash
./install.sh --port 8643
```

Or edit `.env`:

```env
API_SERVER_PORT=8643
```

Then restart:

```bash
./bin/hermes-docker restart
```

### Model calls fail

Check `.env` and verify the correct provider key is set:

```bash
cat ~/.hermes-docker/.env
```

Then restart:

```bash
./bin/hermes-docker restart
```

### Browser install takes too long

Playwright + Chromium increases image size and build time. Skip it:

```bash
./install.sh --no-browser
```

### Windows WSL2 issues

In Docker Desktop:

1. Settings → General → enable WSL2 based engine
2. Settings → Resources → WSL Integration → enable your distro
3. Restart Docker Desktop

## Security notes

- API keys are written to `.env` in the install directory and mirrored into the container Hermes home.
- Do not commit `.env` to Git.
- API server binds to localhost via Docker port mapping by default, while the container listens on `0.0.0.0` internally.
- Keep `API_SERVER_KEY` secret if exposing the port beyond localhost.

## Distribution checklist

Before publishing:

1. Replace every `lunaticbugbear/hermes-docker-installer` placeholder if you forked the repo.
2. Push to GitHub and confirm the CI workflow is green.
3. Test `install.sh` on Linux and macOS.
4. Test `install.ps1` on Windows 11 with Docker Desktop.
5. Test WSL2 install path.
6. Test non-interactive install path.
7. Test `--no-browser` and default browser-enabled builds.
8. Confirm `/health` endpoint behavior for the Hermes version used.
9. Tag the first release, e.g. `v0.1.0`.
10. Update the README quick-install URLs if the default branch is not `main`.
