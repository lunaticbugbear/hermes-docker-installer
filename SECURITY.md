# Security Policy

## Supported versions

`main` is the active branch. Tagged releases are stable snapshots. Security fixes are backported to the latest stable tag when practical.

## Disclosure timeline

When a vulnerability is reported privately, the maintainer will:

1. confirm receipt,
2. reproduce or validate the issue,
3. triage severity,
4. publish a fix or mitigation,
5. update the release notes and changelog.

There is no guaranteed SLA. Urgent installer or secret-handling issues are prioritized ahead of feature work.

## Reporting a vulnerability

Don't open a public issue for security bugs. That includes:

- secrets or credentials exposure
- remote code execution paths
- container breakout scenarios
- credential leakage through logs or env vars
- release integrity issues

Contact the repository owner directly and privately.

When reporting, include:

- OS and Docker version
- installer version or commit
- the exact command you ran
- logs with secrets removed
- what you expected vs what happened
- whether the issue is in install, runtime, or release verification

## Security model

- Hermes Agent runs inside Docker, isolated from the host.
- Provider keys live in `.env`, chmod 600 on Unix.
- The API server binds to `127.0.0.1` by default, not exposed to the network.
- A random bearer token (`API_SERVER_KEY`) is generated at install time.
- The workspace directory is bind-mounted into the container; treat it like any other shared folder.
- Browser tooling is opt-in and increases the attack surface, so keep it disabled unless you need it.

Exposing the API port externally is your call, but do it with intention and protect it appropriately.

## Integrity model

Use layered verification:

1. checksum the downloaded release assets
2. inspect the SBOM if the release publishes one
3. verify the GitHub artifact provenance attestation if the release notes mention one

Do not treat any of those as a claim that the software is safe, bug-free, or malware-free.

## Hardening notes

- Keep Docker up to date.
- Don't change the default `127.0.0.1` bind unless you have a specific reason.
- Rotate provider keys if they ended up in shell history, public logs, or anywhere unexpected.
- Check what's in your workspace before pointing Hermes at a sensitive repo.
- When filing a bug report, strip `.env` values, bearer tokens, and internal URLs before posting.
- Validate downloaded release assets with `sha256sum -c SHA256SUMS` before installing.

## Supported versions matrix

| Area | Supported |
|---|---|
| Branch | `main` |
| Releases | `v*` tags |
| OS | Linux, macOS, Windows, WSL |
| Docker | Current stable Docker Engine / Docker Desktop |
| Shells | bash, PowerShell |

If you need an older compatibility target, open an issue and explain the use case before assuming it is supported.
