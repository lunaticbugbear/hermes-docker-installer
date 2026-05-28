# Contributing

Omnipod's job is to be boring and reliable. A non-technical user should be able to install Hermes Agent on Linux, macOS, Windows, or WSL without reading a manual. Changes should preserve that.

## Before submitting

Run these locally:

```bash
bash -n install.sh uninstall.sh
shellcheck -x install.sh uninstall.sh
HERMES_NONINTERACTIVE=1 OPENROUTER_API_KEY=*** bash install.sh --skip-build --force --port 18642 --dir /tmp/omnipod-ci
cd /tmp/omnipod-ci && docker compose config
bash -n bootstrap.sh healthcheck.sh bin/omnipod
```

Windows:

```powershell
$errors = $null
[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw .\install.ps1), [ref]$errors) | Out-Null
if ($errors) { $errors | Format-List; exit 1 }
$errors = $null
[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw .\uninstall.ps1), [ref]$errors) | Out-Null
if ($errors) { $errors | Format-List; exit 1 }
```

## Principles

- Keep the interactive flow simple and forgiving.
- Keep non-interactive install stable — don't break scripted use.
- Don't commit `.env` or generated runtime files.
- Uninstall must be conservative by default. Destructive behavior requires explicit flags.
- Error messages should tell the user what to do, not just what went wrong.

## Review checklist

- Is this cross-platform or intentionally scoped to one platform?
- Does it preserve existing flags and defaults?
- Does uninstall stay conservative?
- Are README, docs, and CI updated to match?
- Would a non-expert understand the error output if something goes wrong?
