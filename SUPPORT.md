# Support

## Getting help

1. Check the README troubleshooting section first.
2. Check `docs/OPERATIONS.md` for recovery and maintainer flow.
3. If it's still not covered, open a GitHub issue with the bug report template.

## What to include

- OS and version
- Shell or terminal
- Docker version
- Whether you used `install.sh` or `install.ps1`
- Hades version or commit
- The exact command you ran
- Relevant logs, with secrets removed
- Whether the issue is install-time, runtime, or release-related

## What not to post publicly

- Provider API keys
- `.env` file contents
- Bearer tokens
- Cookies or session data
- Internal hostnames or private URLs
- Release signing material or secret tokens

## Public issues are for

- installer failures
- runtime regressions
- docs gaps
- platform compatibility bugs
- provider configuration problems
- release/integrity issues when the release notes and verification doc do not match

## Before posting logs

- read `SECURITY.md`
- strip secrets, bearer tokens, cookies, and internal URLs
- include OS, Docker, shell, exact command, and release tag/commit
- say whether the issue is install-time, runtime, or release-related

## Supported vs best-effort

Supported: Linux, macOS, Windows, WSL with the documented Docker setup.
Best-effort: unusual shells, custom Docker environments, or older platform combinations not listed in the docs.
Maintainers may close issues that cannot be reproduced after the requested details are missing.

## Security issues

Use the guidance in [SECURITY.md](SECURITY.md). Don't open a public issue for vulnerabilities.

## Response style

Support responses should be short, factual, and reproduction-focused. Include the exact next command when you can.
