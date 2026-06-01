# Glossary

Plain-language definitions for terms used in HADES docs.

| Term | Meaning |
|---|---|
| **HADES** | This project. A cross-platform Docker installer and runtime wrapper for Hermes Agent. |
| **Hermes Agent** | The open-source coding agent that HADES installs and wraps. Upstream: NousResearch/hermes-agent. |
| **Installer** | The `install.sh` and `install.ps1` scripts that set HADES up on your machine. |
| **Runtime** | The Docker container HADES manages. It runs Hermes Agent and exposes a local API. |
| **Wrapper** | The `hades` command added to your shell. It controls the runtime: `start`, `stop`, `cli`, `logs`, etc. |
| **Provider** | The remote model API you point Hermes at. Installer values: `openrouter`, `anthropic`, `openai`, `google` (Google Gemini), `deepseek`, or `custom`. |
| **Model** | The specific LLM you use through that provider, for example `deepseek/deepseek-v4-flash:free`. |
| **API key** | The secret token your provider gives you. HADES stores it in the install dir `.env` (`~/.hades/.env` for user installs; `/usr/local/lib/hades/.env` or `%ProgramFiles%\hades\.env` for elevated installs). |
| **Bearer token (`API_SERVER_KEY`)** | A random token HADES generates so the local API server can authenticate clients. Different from your provider key. |
| **Workspace** | The `workspace/` directory inside the install dir (default `~/.hades/workspace/`) that Hermes can read and write. Bind-mounted into the container. |
| **Persistent volume (`hermes_home`)** | A Docker volume that stores Hermes sessions, memory, skills, and config across rebuilds. |
| **Bind mount** | A way Docker exposes a host directory directly to the container. HADES uses it for the workspace. |
| **Non-interactive install** | Running `install.sh` without prompts, useful for CI or scripted use. Triggered with `HERMES_NONINTERACTIVE=1`. The PowerShell installer is non-interactive whenever you pass `-Provider`. |
| **`hades reset`** | Destructive command that removes the persistent volume. Sessions, memory, skills, and config inside it are lost. |
| **Browser tooling** | Optional Chromium/Playwright support inside the container. Off by default. Enable with `--browser` if you need it. |
| **`SHA256SUMS`** | A file listing the SHA-256 hash of each release asset, used to verify the download was not tampered with. |
| **SBOM (`sbom.spdx.json`)** | Software bill of materials. Lists the components of the release. Transparency, not a safety guarantee. |
| **Provenance attestation** | A signed GitHub statement saying *which* workflow built *which* file. Verified locally with `gh attestation verify`. |
| **CI** | Continuous integration. The automated checks that run on every push and pull request. |
| **Release workflow** | The GitHub Actions workflow that publishes assets, checksums, SBOM, and attestations when a `v*` tag is pushed. |
| **Conservative uninstall** | Default behavior of `uninstall.sh`. Stops the stack but does not delete data unless you ask. |
| **Localhost-only API** | Default network behavior. The API binds to `127.0.0.1` and is not reachable from other machines. |
| **OIDC** | OpenID Connect. The identity protocol GitHub Actions uses to sign attestations without long-lived secrets. |
