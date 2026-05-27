# Hermes Agent Docker Installer

[![CI](https://github.com/lunaticbugbear/hermes-docker-installer/actions/workflows/ci.yml/badge.svg)](https://github.com/lunaticbugbear/hermes-docker-installer/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Public-quality cross-platform installer for running Hermes Agent inside Docker.
One command to install, configure, update, and manage Hermes without polluting the host Python environment.

## What this repo gives you

- Cross-platform installer for Linux, macOS, WSL, Git Bash, and native Windows PowerShell
- Docker-isolated Hermes runtime with persistent state
- Auto-generated local API server config and bearer key
- Optional browser tooling layer with Playwright + Chromium
- Helper commands for start, stop, logs, shell, CLI, update, reset, URL, and key retrieval
- Explicit uninstall scripts for Linux/macOS/WSL and Windows PowerShell
- CI that checks shell syntax, PowerShell parsing, generated compose config, docs sanity, and a Docker smoke test

## Install

### Linux / macOS / WSL / Git Bash

Quick run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lunaticbugbear/hermes-docker-installer/main/install.sh)
```

Or download first:

```bash
curl -O https://raw.githubusercontent.com/lunaticbugbear/hermes-docker-installer/main/install.sh
chmod +x install.sh
./install.sh
```

### Windows PowerShell

```powershell
powershell -ExecutionPolicy Bypass -c "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/lunaticbugbear/hermes-docker-installer/main/install.ps1' -OutFile install.ps1; .\install.ps1"
```

## Requirements

The installer is designed to bootstrap Docker when possible.

- Linux: tries to install/start Docker Engine
- macOS: tries to install/start Docker Desktop
- Windows PowerShell: tries to install/start Docker Desktop
- WSL: treats the environment as Linux and attempts Docker Engine bootstrap inside WSL

Important:
- OS-level Docker installation may still require sudo/admin approval
- Some machines may require a shell restart or re-login after Docker installation
- If automatic Docker bootstrap fails, the installer prints the exact manual recovery path

## Default behavior

- Browser layer is opt-in, not default
- Hermes version is pinnable via `HERMES_VERSION`
- API server default port is `8642`
- Provider/model can be passed via flags or selected interactively

## CLI options

### install.sh

| Option | Description |
|---|---|
| `--dir PATH` | Install directory, default `~/.hermes-docker` |
| `--provider PROVIDER` | `openrouter|anthropic|openai|google|deepseek|custom` |
| `--model MODEL` | Model name |
| `--port PORT` | API server port |
| `--name NAME` | Compose project name |
| `--no-start` | Generate/build but do not start |
| `--browser` | Include Playwright + Chromium |
| `--skip-build` | Generate files only |
| `--force` | Overwrite generated files |
| `--uninstall` | Stop stack and optionally remove data volume |
| `--help` | Show help |

### install.ps1

| Option | Description |
|---|---|
| `-InstallDir <path>` | Install directory |
| `-Provider <name>` | Provider selection |
| `-Model <name>` | Model name |
| `-Port <number>` | API server port |
| `-ProjectName <name>` | Compose project name |
| `-NoStart` | Generate/build but do not start |
| `-Browser` | Include Playwright + Chromium |
| `-SkipBuild` | Generate files only |
| `-Force` | Overwrite generated files |
| `-Uninstall` | Stop stack and optionally remove data volume |

## Environment variables

| Variable | Purpose |
|---|---|
| `OPENROUTER_API_KEY` | OpenRouter API key |
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `OPENAI_API_KEY` | OpenAI API key |
| `GOOGLE_API_KEY` | Google/Gemini API key |
| `DEEPSEEK_API_KEY` | DeepSeek API key |
| `CUSTOM_API_KEY` | Custom provider API key |
| `CUSTOM_BASE_URL` | Base URL for custom provider |
| `API_SERVER_KEY` | Optional fixed API bearer key |
| `HERMES_NONINTERACTIVE` | `1` to skip prompts in shell installer |
| `HERMES_VERSION` | Hermes Agent git ref/tag/branch to install |

Non-interactive example:

```bash
HERMES_NONINTERACTIVE=1 \
OPENROUTER_API_KEY=sk-example \
HERMES_VERSION=main \
bash install.sh --provider openrouter --model deepseek/deepseek-v4-flash:free
```

## Installed layout

Generated install directory:

```text
~/.hermes-docker/
  .env
  Dockerfile
  docker-compose.yml
  bootstrap.sh
  healthcheck.sh
  bin/hermes-docker
  workspace/
```

Container/runtime layout:

- `/workspace` -> bind mount from host `workspace/`
- `/root/.hermes` -> persistent Docker volume

## Management commands

After installation:

```bash
cd ~/.hermes-docker
./bin/hermes-docker start
./bin/hermes-docker cli
./bin/hermes-docker logs
./bin/hermes-docker status
./bin/hermes-docker shell
./bin/hermes-docker update
./bin/hermes-docker url
./bin/hermes-docker key
```

Windows PowerShell helper:

```powershell
cd $env:USERPROFILE\.hermes-docker
.\hermes-docker.ps1 start
.\hermes-docker.ps1 logs
.\hermes-docker.ps1 cli
```

## Browser tooling

By default the installer skips Playwright/Chromium to keep first install lighter.
Enable it only when you need browser automation:

```bash
./install.sh --browser
```

```powershell
.\install.ps1 -Browser
```

## Updating provider or model

Edit `.env`, then restart:

```bash
cd ~/.hermes-docker
nano .env
./bin/hermes-docker restart
```

## Pin Hermes version

```bash
HERMES_VERSION=v0.5.0 bash install.sh
```

## Uninstall

### Linux / macOS / WSL

```bash
bash uninstall.sh
bash uninstall.sh --remove-data
bash uninstall.sh --remove-files
bash uninstall.sh --remove-files --remove-data
```

### Windows PowerShell

```powershell
.\uninstall.ps1
.\uninstall.ps1 -RemoveData
.\uninstall.ps1 -RemoveFiles
.\uninstall.ps1 -RemoveFiles -RemoveData
```

## CI coverage

The repository CI currently verifies:

- `bash -n` on shell scripts
- `shellcheck` on shell scripts
- PowerShell parse validity
- Generated Docker Compose config from installer output
- Default browser layer remains opt-in
- Generated version pin exists in `.env`
- Main-branch Docker build + health smoke test
- Docs sanity checks for stale flags and missing files

## Repository quality notes

This repository is intended to be public-quality:

- multi-stage Docker build
- explicit uninstall paths
- helper CLI included in generated install
- browser dependencies opt-in
- version pin support
- healthcheck-based startup verification
- CI coverage for both script families

## Files in repo

- `install.sh` — shell installer
- `install.ps1` — Windows PowerShell installer
- `uninstall.sh` — shell uninstaller
- `uninstall.ps1` — PowerShell uninstaller
- `.github/workflows/ci.yml` — repository CI
- `CHANGELOG.md` — release history

## License

MIT. See `LICENSE`.

## Security and contributing

- See `SECURITY.md`
- See `CONTRIBUTING.md`
