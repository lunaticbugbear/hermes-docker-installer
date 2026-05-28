# Release Process

## Channels

- `main` — continuously validated, always deployable
- `v*` tags — immutable release snapshots published to GitHub Releases

## Before tagging

Validate locally:

```bash
bash -n install.sh uninstall.sh
shellcheck -x install.sh uninstall.sh
python3 - <<'PY'
import yaml, pathlib
for p in pathlib.Path('.github/workflows').glob('*.yml'):
    yaml.safe_load(p.read_text())
print('workflow-yaml-ok')
PY
```

Make sure `main` CI is green.

## Tagging

```bash
git tag v1.1.7
git push origin v1.1.7
```

The release workflow picks it up automatically and publishes assets to GitHub Releases.

## What gets published

- `install.sh`
- `install.ps1`
- `uninstall.sh`
- `uninstall.ps1`
- `README.md`
- `LICENSE`
- `CHANGELOG.md`
- `SECURITY.md`
- `SUPPORT.md`
- `SHA256SUMS`

## Verifying a release

```bash
sha256sum -c SHA256SUMS
```

## Changelog

Every user-visible change goes in `CHANGELOG.md` before tagging. That includes:

- flag or default changes
- generated file behavior changes
- CI or governance changes
- security posture changes
- release tooling changes

## Release checklist

- [ ] `main` CI is green
- [ ] README reflects current flags, defaults, and commands
- [ ] `CHANGELOG.md` has an entry
- [ ] tag format is `v*`
- [ ] published assets include `SHA256SUMS`
