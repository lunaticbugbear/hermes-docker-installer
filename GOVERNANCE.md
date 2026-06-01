# Governance

This document describes how decisions get made in this project. The goal is clarity, not bureaucracy.

## Project type

HADES is a single-maintainer open-source project. It is not vendor-backed. There is no foundation, no steering committee, and no paid release engineering.

## Roles

### Maintainer

The maintainer is `@lunaticbugbear`. The maintainer:

- accepts and reviews issues and pull requests
- merges changes after review
- creates release tags
- decides what ships and when
- responds to security reports
- updates governance, security, and support documents

### Contributors

Anyone who opens an issue, comments, or sends a pull request. Contributors do not have merge rights.

### Users

Anyone running HADES on their own machine. Users have no obligations.

## How decisions are made

| Decision | Who decides | How |
|---|---|---|
| Bug fix scope | Maintainer | Based on the issue and reproduction. |
| Default behavior change | Maintainer | Discussed in the issue or PR before merge. |
| Installer flag, default, or path change | Maintainer | Must update README, CHANGELOG, and CI assertions. |
| Security-sensitive change | Maintainer | Private review, see `SECURITY.md`. |
| Release timing | Maintainer | Based on what's ready, not a fixed cadence. |
| Roadmap priorities | Maintainer | Listed in `ROADMAP.md`, open to suggestions. |
| Adding a new provider | Maintainer | Must be free or low-cost to test, must not require a private SDK. |

If a contributor wants something the maintainer disagrees with, the contributor is welcome to fork. That is the OSS escape valve and it is healthy.

## Change classes

### 1. Trivial

Typo fix, doc clarification, link fix. Maintainer merges directly after a quick read.

### 2. Standard

Bug fix, small feature, doc rewrite. Requires:

- a clear reproduction or use case
- updated tests or validation if behavior changes
- updated docs if the change is user-visible

### 3. Sensitive

Anything touching:

- defaults
- installer paths
- uninstall behavior
- API server bind address or auth
- release assets or release workflow
- security or support docs

Sensitive changes require a deliberate review pass and an entry in `CHANGELOG.md`.

### 4. Breaking

Changes that break existing installs or scripted use. Avoid when possible. When required:

- announce in `CHANGELOG.md` under a clear `### Changed` or `### Removed` section
- bump the minor or major version
- add migration notes in the release notes

## Release authority

Only the maintainer should:

- create release tags
- publish or edit GitHub Releases
- change the release workflow
- change branch protection or required checks
- change repository settings related to security or actions

## Conflict resolution

Disagreement on a PR or issue is resolved by the maintainer's call. If you think a call was wrong, say so in the thread with reasons. Heat is not a substitute for evidence.

## Bus factor

This project has a single maintainer. That risk is real. Mitigations:

- automation: CI runs on every push, release workflow publishes attestations and SBOM, scheduled upstream check files an issue when Hermes ships a new version
- defaults: conservative uninstall, localhost-only API, opt-in browser tooling
- documentation: README, SECURITY, SUPPORT, MAINTAINERS, ROADMAP, RELEASE_PROCESS, RELEASE_VERIFICATION, OPERATIONS, FAQ, GLOSSARY, QUICKSTART
- recoverability: every release ships verifiable assets, source is plain-text shell and PowerShell

If the maintainer becomes unavailable, the project can be forked from the latest release with the trust chain intact.

## Code of conduct

See [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).

## Updates to this document

Updates follow the standard contribution process. Any change to governance is sensitive and needs a corresponding `CHANGELOG.md` entry.
