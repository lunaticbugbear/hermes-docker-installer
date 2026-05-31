# Release Verification

Use this when validating a published HADES release.

## What to download

- release assets
- `SHA256SUMS`
- `sbom.spdx.json` if published
- any attestation artifacts linked from the release notes

## Integrity check

```bash
sha256sum -c SHA256SUMS
```

Windows fallback:

```powershell
Get-FileHash .\install.ps1 -Algorithm SHA256
```

## What each proof means

- checksums → integrity vs the published checksum file
- SBOM → inventory/transparency, not a guarantee of safety
- attestation → GitHub build provenance for the published subject files
- signatures → only if the release notes explicitly say they exist

## What to verify

- the release tag starts with `v`
- the asset bundle includes the expected installer scripts
- the plaintext installers look sane before execution
- the SBOM exists if the release notes mention it
- the release notes list the exact local verification commands users should repeat

GitHub attestation example:

```bash
gh attestation verify ./install.sh -R lunaticbugbear/hades-hermes-agent
```
