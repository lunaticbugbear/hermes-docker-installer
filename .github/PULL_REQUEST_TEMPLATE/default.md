## Summary

What changed and why?

## Checklist

- [ ] `bash -n install.sh uninstall.sh` passes
- [ ] `shellcheck -x install.sh uninstall.sh` passes
- [ ] Generated files still work (`--skip-build` or `-SkipBuild` path)
- [ ] README and docs updated if UX, flags, defaults, release flow, or support flow changed
- [ ] Security / support notes updated if the change affects trust, reporting, or secrets handling
- [ ] Trust-facing claims remain literal and verified
- [ ] Release-process changes include verification steps if relevant
- [ ] Secrets removed from logs and examples

## Testing

List the exact commands you ran.

## Output / screenshots

Optional. Include terminal output or visual proof if the change affects onboarding.

## Risk notes

If this changes installer behavior, release assets, defaults, or generated runtime files, say so plainly.
