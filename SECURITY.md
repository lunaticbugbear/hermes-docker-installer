# Security Policy

## Supported versions

The `main` branch is the supported release channel until tagged releases are published.

## Reporting a vulnerability

Do not open a public issue for secrets exposure, remote execution bugs, container breakout concerns, or credential leakage.

Report privately to the repository owner/security contact.

Include:

- operating system
- Docker version
- installer version / commit
- exact command used
- logs with secrets removed
- expected vs actual impact

## Security model

The installer:

- runs Hermes Agent inside Docker
- stores provider keys in `.env`
- exposes Hermes API Server on `127.0.0.1` by default
- uses a generated `API_SERVER_KEY`
- mounts a user workspace into `/workspace`

Users should not expose the API port publicly unless they understand the risk and protect it with network controls and a strong API key.

## Hardening guidance

- Keep Docker Desktop / Docker Engine updated.
- Prefer the default loopback bind (`127.0.0.1`) unless remote access is required.
- Rotate provider keys if they were ever pasted into public logs or shells with shared history.
- Review mounted project contents before giving Hermes access to sensitive repositories.
- If publishing a bug report, redact `.env` values, bearer keys, tokens, cookies, and internal hostnames.
