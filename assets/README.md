# Repository assets

## Social preview

Primary file for GitHub social preview:

- `social-preview.png`

Suggested upload path in GitHub UI:

1. Open repository settings
2. Go to **General**
3. Find **Social preview**
4. Upload `assets/social-preview.png`

The matching SVG source is `social-preview.svg` for future edits.

## README visuals

These SVGs are linked from the README as lightweight project visuals:

- `hades-install.svg` — install/onboarding flow
- `hades-status.svg` — status/runtime flow

Regenerate them with:

```bash
python assets/generate_install_shot.py
python assets/generate_status_shot.py
```
