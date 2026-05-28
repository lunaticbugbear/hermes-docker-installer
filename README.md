# Omnipod

<p align="center">
  <pre>
  ___  __  __ _  _ ____ ___  ___  ___  
 / _ \|  \/  |  \| |  _ \ _ \|   \|   \ 
| (_) | |\/| | |   | |_) |_) | | | | | |
 \___/|_|  |_|_|\__|  __/___/|___/|___/ 
                   |_|                  
  </pre>
  <strong>Run Hermes Agent in Docker. No mess on your machine.</strong><br>
  Works on Linux, macOS, WSL, and Windows.
</p>

<p align="center">
  <a href="https://github.com/lunaticbugbear/hermes-docker-installer/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/lunaticbugbear/hermes-docker-installer/actions/workflows/ci.yml/badge.svg"></a>
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"></a>
  <img alt="Docker" src="https://img.shields.io/badge/runtime-Docker-2496ED">
  <img alt="Platforms" src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20WSL-blueviolet">
</p>

---

Omnipod installs [Hermes Agent](https://hermes-agent.nousresearch.com) inside a Docker container with persistent state, a local API gateway, and a single control command. Your host stays clean. Sessions, memories, and config survive rebuilds.

---

## How it works

```text
               +-------------------------------------------------+
               |                   HOST SYSTEM                   |
               |                                                 |
               |  ~/.omnipod/                                    |
               |  ├── .env  (keys, port, config)                 |
               |  ├── docker-compose.yml                         |
               |  │                                              |
               |  ├── workspace/  <======= Bind Mount ========>  |
               |  |                                           |  |
               +--|-------------------------------------------|--+
                  |                                           |
                  |                  Virtual                  |
                  |                  Network                  |
                  |                                           |
+-----------------|-------------------------------------------|--+
|                 v                                           v  |
|     [ Container: omnipod ]                          /workspace |
|                                                                |
|     hermes gateway run                                         |
|     API: 127.0.0.1:8642                                        |
|                                                                |
|     /root/.hermes  <========== Named Volume ===========>       |
|                                                     |          |
+-----------------------------------------------------|----------+
                                                      v
                                            [ Volume: hermes_home ]
                                            - config.yaml & .env
                                            - sessions/
                                            - memory/ & skills/
```

The container runs Hermes. The volume keeps your data. The workspace folder is shared between host and container so Hermes can read your project files directly.

---

## Quick start

### Linux / macOS / WSL

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lunaticbugbear/hermes-docker-installer/main/install.sh)
```

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy Bypass -c "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/lunaticbugbear/hermes-docker-installer/main/install.ps1' -OutFile install.ps1; .\install.ps1"
```

The installer asks for your provider, API key, model, and port. That's it.

---

## Non-interactive install

For servers, CI, or scripts where you can't answer prompts:

### Unix

```bash
HERMES_NONINTERACTIVE=1 \
OPENROUTER_API_KEY=<your_key> \
bash install.sh \
  --provider openrouter \
  --model deepseek/deepseek-v4-flash:free \
  --port 8642
```

### Windows PowerShell

```powershell
.\install.ps1 `
  -Provider openrouter `
  -Model deepseek/deepseek-v4-flash:free `
  -OpenRouterApiKey "<your_key>" `
  -Port 8642
```

---

## Commands

Once installed, `omnipod` works from anywhere:

| Command | What it does |
|---|---|
| `omnipod start` | Start the container in the background |
| `omnipod stop` | Stop it |
| `omnipod restart` | Restart (picks up `.env` changes) |
| `omnipod status` | Show container state and ports |
| `omnipod cli` | Open an interactive chat session inside the container |
| `omnipod logs` | Tail the Hermes Agent logs |
| `omnipod shell` | Drop into a bash shell inside the container |
| `omnipod update` | Pull latest changes, rebuild, restart |
| `omnipod url` | Print the API server URL |
| `omnipod key` | Print the bearer auth token |
| `omnipod down` | Stop container and remove networks |
| `omnipod reset` | Wipe containers, networks, and persistent volumes |

---

## Install options

### `install.sh` flags

| Flag | Default | Notes |
|---|---:|---|
| `--dir PATH` | `~/.omnipod` | Where to install |
| `--provider NAME` | `openrouter` | `openrouter`, `anthropic`, `openai`, `google`, `deepseek`, `custom` |
| `--model MODEL` | `deepseek/deepseek-v4-flash:free` | Model string |
| `--port PORT` | `8642` | API bind port |
| `--name NAME` | `omnipod` | Compose project name |
| `--browser` | off | Include Playwright + Chromium (~450 MB extra) |
| `--no-start` | off | Build image and files, don't start |
| `--skip-build` | off | Generate config files only |
| `--force` | off | Overwrite generated files (backs up `.env` → `.env.bak`) |
| `--uninstall` | off | Run the uninstaller |

### `install.ps1` parameters

| Parameter | Default | Notes |
|---|---:|---|
| `-InstallDir PATH` | `$env:USERPROFILE\.omnipod` | Switches to `%ProgramFiles%\omnipod` when run as Admin |
| `-Provider NAME` | `openrouter` | Provider name |
| `-Model MODEL` | `deepseek/deepseek-v4-flash:free` | Model string |
| `-Port PORT` | `8642` | API bind port |
| `-ProjectName NAME` | `omnipod` | Compose project name |
| `-Browser` | off | Include Playwright stack |
| `-NoStart` | off | Don't start after build |
| `-SkipBuild` | off | Config files only |
| `-Force` | off | Overwrite files |
| `-Uninstall` | off | Run uninstall |

---

## Provider credentials

Pass the API key for whichever provider you pick:

| Provider | Variable |
|---|---|
| OpenRouter | `OPENROUTER_API_KEY` |
| Anthropic | `ANTHROPIC_API_KEY` |
| OpenAI | `OPENAI_API_KEY` |
| Google | `GOOGLE_API_KEY` or `GEMINI_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |
| Custom | `CUSTOM_API_KEY` + `CUSTOM_BASE_URL` |

Other env vars:

| Variable | Default | Notes |
|---|---:|---|
| `API_SERVER_KEY` | random hex | Set this to use a fixed bearer token |
| `HERMES_VERSION` | `main` | Pin a specific branch, tag, or commit |
| `HERMES_NONINTERACTIVE` | `0` | Set to `1` to skip all prompts |

---

## What gets installed

```text
~/.omnipod/
├── .env
├── Dockerfile
├── docker-compose.yml
├── bootstrap.sh
├── healthcheck.sh
├── bin/
│   ├── omnipod
│   ├── omnipod.ps1
│   └── omnipod.cmd
└── workspace/
```

Root installs go to `/usr/local/lib/omnipod/` with the binary linked at `/usr/local/bin/omnipod`.

---

## Browser tooling

Off by default. Adds Playwright + Chromium, around 450 MB extra.

```bash
# Unix
bash install.sh --browser

# PowerShell
.\install.ps1 -Browser
```

---

## Pinning a version

```bash
HERMES_VERSION=v0.5.0 bash install.sh
```

To go back to main:

```bash
HERMES_VERSION=main bash install.sh --force
```

---

## Changing config after install

Edit `~/.omnipod/.env` directly, then:

```bash
omnipod restart
```

If you changed build-time options (browser support, Hermes version):

```bash
omnipod update
```

---

## Uninstalling

```bash
# Unix
bash uninstall.sh
bash uninstall.sh --remove-data     # also removes named volumes
bash uninstall.sh --remove-files    # also deletes the install directory
bash uninstall.sh --remove-files --remove-data

# PowerShell
.\uninstall.ps1
.\uninstall.ps1 -RemoveData
.\uninstall.ps1 -RemoveFiles
.\uninstall.ps1 -RemoveFiles -RemoveData
```

By default, uninstall shuts down the stack but leaves volumes and files alone.

---

## Troubleshooting

**Docker not found or not running**

- Linux: `sudo systemctl start docker`, then add your user to the docker group if needed: `sudo usermod -aG docker $USER`
- macOS: open Docker.app
- Windows: open Docker Desktop

**Port 8642 already in use**

The installer suggests a free port in interactive mode. Non-interactive:

```bash
bash install.sh --port 18642
```

**Config changes not taking effect**

Most changes only need `omnipod restart`. If you changed `--browser` or `HERMES_VERSION`, run `omnipod update` to rebuild the image.

**Browser tools missing**

Re-run with browser support:

```bash
bash install.sh --browser --force
```

---

## CI checks

Every push runs:

- bash syntax + ShellCheck
- PowerShell parser validation
- Compose config check
- generated helper script syntax
- uninstall behavior verification
- docs sanity (required files present)
- Docker build + API health probe on `main`
- repository hygiene scan

---

## Docs

- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SECURITY.md](SECURITY.md)
- [SUPPORT.md](SUPPORT.md)
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/OPERATIONS.md](docs/OPERATIONS.md)
- [docs/RELEASE_PROCESS.md](docs/RELEASE_PROCESS.md)

Releases publish installer scripts + `SHA256SUMS` to GitHub Releases on every `v*` tag.

```bash
sha256sum -c SHA256SUMS
```

---

## License

MIT. See [LICENSE](LICENSE).
