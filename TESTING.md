# Testing Guide

## General Testing Principles

Always test changes before committing:
- **Use existing test scripts** in `/cmd/test/` when available
- **Write simple tests** if none exist (bash scripts, Python tests, or manual verification steps)
- **Document test steps** in commit messages or PR descriptions

## Renovate Configuration Testing

When modifying `renovate.json5`, always test changes before merging to prevent incorrect PRs.

### Workflow

1. **Create feature branch**
   ```bash
   git checkout -b fix/renovate-<description>
   ```

2. **Make changes and commit**
   ```bash
   git add renovate.json5
   git commit -m "fix(renovate): <description>"
   ```

3. **Push to remote** (required for testing)
   ```bash
   git push -u origin fix/renovate-<description>
   ```

4. **Test locally**
   ```bash
   ./cmd/test/test-renovate-local.sh
   ```

5. **Validate output**
   - Check that dependencies are detected correctly
   - Verify version extraction matches expected format
   - Confirm updates are grouped as intended

### Example: Testing OpenSCAD Updates

```bash
# Checkout the branch you want to test
git checkout fix/renovate-openscad-separate-extractors
./cmd/test/test-renovate-local.sh
```

Expected output should show:
- `OpenSCAD-Windows`: version without `.ai` suffix
- `OpenSCAD-Linux`: version with `.ai` suffix preserved

### Example: Testing Grouping and Automerge

```bash
# Test pre-commit hooks grouping
git checkout renovate-pre-commit
./cmd/test/test-renovate-local.sh
```

Expected output should show:
- **Single branch** `renovate/pre-commit-hooks` containing all pre-commit hook updates
- Both **major and minor** updates combined (verify `separateMajorMinor: false`)
- `"automerge": true` in the branch configuration
- No separate `renovate/major-pre-commit-hooks` branch

### Why Remote Push is Required

Renovate test fetches from GitHub, so changes must exist remotely before testing validates them.
