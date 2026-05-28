# Omnipod Operations Guide

## Scope

This document is for maintainers operating, validating, and troubleshooting the Omnipod installer and its generated Docker runtime.

See also:

- [`ARCHITECTURE.md`](ARCHITECTURE.md) for system design and lifecycle
- [`RELEASE_PROCESS.md`](RELEASE_PROCESS.md) for tagging and release publication
- [`CONTRIBUTING.md`](../CONTRIBUTING.md) for contributor expectations

## Repository invariants

These rules should remain true unless a deliberate breaking change is made:

- the installer entrypoints are `install.sh` and `install.ps1`
- uninstall stays conservative by default
- browser tooling remains opt-in
- generated API exposure stays bound to `127.0.0.1` by default
- generated runtime files are not committed to this repository
- persistent Hermes state survives rebuilds and restarts

## Generated runtime contract

The repository contains installer source, not a checked-in runtime.

Generated at install time:

- `Dockerfile`
- `docker-compose.yml`
- `bootstrap.sh`
- `healthcheck.sh`
- `bin/omnipod`
- `bin/omnipod.ps1`
- `bin/omnipod.cmd`
- install directory `.env`
- install directory `workspace/`

Persistent Hermes data lives in the Compose volume key `hermes_home` mounted at `/root/.hermes` inside the container.

## Local validation before merge

Run the same core checks CI expects:

```bash
bash -n install.sh uninstall.sh
shellcheck -x install.sh uninstall.sh
python3 - <<'PY'
import yaml, pathlib
for p in pathlib.Path('.github/workflows').glob('*.yml'):
    yaml.safe_load(p.read_text())
print('workflow-yaml-ok')
PY
HERMES_NONINTERACTIVE=1 OPENROUTER_API_KEY=dummy-token-123456789 bash install.sh --skip-build --force --dir /tmp/omnipod-ci
cd /tmp/omnipod-ci && docker compose config
bash -n bootstrap.sh healthcheck.sh bin/omnipod
```

Optional Windows parser check:

```powershell
$errors = $null
[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw .\install.ps1), [ref]$errors) | Out-Null
if ($errors) { $errors | Format-List; exit 1 }
$errors = $null
[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw .\uninstall.ps1), [ref]$errors) | Out-Null
if ($errors) { $errors | Format-List; exit 1 }
```

## Common maintainer tasks

### Regenerate a runtime without building

```bash
HERMES_NONINTERACTIVE=1 OPENROUTER_API_KEY=dummy-token-123456789 bash install.sh --skip-build --force --dir /tmp/omnipod-ci
```

Use this when validating generated files, flags, paths, or Compose wiring.

### Full local smoke test

```bash
HERMES_NONINTERACTIVE=1 OPENROUTER_API_KEY=dummy-token-123456789 bash install.sh --force --dir /tmp/omnipod-smoke
cd /tmp/omnipod-smoke
./bin/omnipod start
curl -sf http://127.0.0.1:8642/health
./bin/omnipod logs
./bin/omnipod down
```

### Inspect a live install

```bash
omnipod status
omnipod url
omnipod logs
omnipod shell
```

If the wrapper is unavailable:

```bash
cd ~/.omnipod
docker compose ps
docker compose logs --tail 120 hermes
curl -sf http://127.0.0.1:8642/health
```

## Triage playbook

### Installer failure

Collect:

- operating system and version
- shell or PowerShell version
- Docker version
- exact install command
- whether the run was interactive or non-interactive
- sanitized stderr/stdout

Check for:

- missing Docker daemon
- PATH registration issues
- permission problems writing install directory
- stale generated files during non-forced reruns

### API health failure

1. inspect container state: `omnipod status`
2. inspect logs: `omnipod logs`
3. confirm bind address and port in generated `.env`
4. verify local probe: `curl -sf http://127.0.0.1:8642/health`
5. if version-related, rebuild with `omnipod update`

### Suspected regression in generated files

1. regenerate into a clean temp dir with `--skip-build --force`
2. diff old vs new generated files
3. confirm README, CI, and changelog reflect the intended behavior
4. test uninstall flow if install/startup logic changed

## Change-management rules

When changing flags, defaults, paths, or generated files:

- update `README.md`
- update `CHANGELOG.md`
- update CI assertions if behavior moved
- keep Unix and PowerShell installers aligned
- preserve non-interactive automation unless intentionally changed

## GitHub admin baseline

Repository governance should stay aligned with these expectations:

- `main` protected
- required CI checks configured
- stale reviews dismissed
- conversation resolution required
- force-pushes disabled
- branch deletion disabled
- squash merge preferred
- merge commits and rebase merges disabled unless policy changes deliberately

## Recovery and rollback

If a change breaks installs in the field:

1. stop merging new changes
2. identify last known good commit or tag
3. revert the offending change or pin the prior behavior
4. rerun local validation and CI
5. publish a follow-up release if the break affected tagged users

If a user's runtime is broken but data should survive:

```bash
omnipod down
omnipod update
omnipod start
```

If the user explicitly accepts destructive recovery:

```bash
omnipod reset
```

Use destructive recovery only after warning that Hermes sessions, memory, and config stored in the persistent volume may be removed.
