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
- `sbom.spdx.json`

## Verifying a release

```bash
sha256sum -c SHA256SUMS
```

If release signing is enabled, verify that signature too and treat checksums as the baseline, not the whole story.

## Release integrity

Current release trust chain:

- release assets
- `SHA256SUMS`
- SPDX SBOM (`sbom.spdx.json`)
- GitHub artifact provenance attestation
- optional SBOM attestation when the workflow publishes an SBOM

Use checksums and attestations as tamper-evidence, not as a claim that the project is bug-free or inherently safe.

### Maintainer release checklist

- [ ] release workflow is green
- [ ] checksum file is attached
- [ ] SPDX SBOM is attached
- [ ] provenance attestation succeeded
- [ ] SBOM attestation succeeded if enabled
- [ ] release notes include exact verification commands
- [ ] release notes do not claim signatures unless the workflow actually publishes them

### Recovery

If a bad asset or tag goes out:

1. stop new promotion
2. fix the release workflow or source commit
3. cut a follow-up tag
4. explain the correction in the release notes
5. leave the broken asset visible only if you need it for audit

Document the verification steps in `docs/RELEASE_VERIFICATION.md` and keep `SECURITY.md` aligned.

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
- [ ] signing method is documented if used
- [ ] security-sensitive changes are reflected in `SECURITY.md` and `SUPPORT.md`
