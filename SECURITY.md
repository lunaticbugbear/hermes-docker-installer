# Security Policy

## Supported versions

`main` is the active branch. Tagged releases are stable snapshots.

## Reporting a vulnerability

Don't open a public issue for security bugs. That includes:

- secrets or credentials exposure
- remote code execution paths
- container breakout scenarios
- credential leakage through logs or env vars

Contact the repository owner directly and privately.

When reporting, include:

- OS and Docker version
- installer version or commit
- the exact command you ran
- logs with secrets removed
- what you expected vs what happened

## Security model

- Hermes Agent runs inside Docker, isolated from the host
- Provider keys live in `.env`, chmod 600 on Unix
- The API server binds to `127.0.0.1` by default — not exposed to the network
- A random bearer token (`API_SERVER_KEY`) is generated at install time
- The workspace directory is bind-mounted into the container; treat it like any other shared folder

Exposing the API port externally is your call, but do it with intention and protect it appropriately.

## Hardening notes

- Keep Docker up to date
- Don't change the default `127.0.0.1` bind unless you have a specific reason
- Rotate provider keys if they ended up in shell history, public logs, or anywhere unexpected
- Check what's in your workspace before pointing Hermes at a sensitive repo
- When filing a bug report, strip `.env` values, bearer tokens, and internal URLs before posting
