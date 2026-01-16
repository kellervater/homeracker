# Post-Migration Tasks

This document outlines manual tasks required after moving the repository from `kellervater/homeracker` to `kellerlabs/homeracker`.

## ✅ Completed Tasks

- [x] Updated all repository URLs in documentation (README, CONTRIBUTING, etc.)
- [x] Updated configuration files (_config.yml, CODEOWNERS)
- [x] Updated Renovate configuration (renovate.json5, renovate-dependencies.json)
- [x] Updated Python package metadata (pyproject.toml)
- [x] Validated configuration changes with pre-commit hooks

## 🔧 GitHub Apps & Integrations

### 1. Renovate Bot
**Status**: Needs reconfiguration

**Action Required**:
- Reinstall/reconfigure the Renovate GitHub App for the `kellerlabs` organization
- Verify Renovate is enabled for the `kellerlabs/homeracker` repository
- Check that all custom datasources and managers are working correctly
- Test by running: `./cmd/test/test-renovate-local.sh` (requires Docker + GitHub CLI)

**Expected Behavior**:
- Automatic dependency updates for OpenSCAD versions
- Updates for GitHub Actions
- Updates for pre-commit hooks
- Updates for BOSL2 library

### 2. Release Automation (release-please)
**Status**: Needs reconfiguration

**Action Required**:
- Verify GitHub App credentials configured in repository secrets
- Check that release workflows are functioning:
  - `.github/workflows/release-please.yml`
  - `.github/workflows/automerge-release.yml`
- Test by triggering a release workflow manually

**Expected Behavior**:
- Automated release PRs based on Conventional Commits
- Weekly auto-merge of release PRs
- Automatic changelog generation
- Tagged releases with version information

### 3. GitHub Pages
**Status**: May need reconfiguration

**Action Required**:
- Verify GitHub Pages is enabled for the repository
- Check that Pages is using the correct branch/directory
- Verify the site is accessible at the expected URL
- The `_config.yml` author field has been updated to `kellerlabs`

### 4. Discord Integration
**Status**: Should work (uses webhook)

**Action Required**:
- Verify Discord webhook still posts release notifications
- Check `#homeracker-announcements` channel for updates
- If broken, reconfigure webhook in repository settings

**Expected Behavior**:
- Automatic posts to Discord on new releases

## 🔗 External References

### PyPI Package (scadm)
**Status**: No action required for URLs

**Note**: 
- The `scadm` package metadata in `pyproject.toml` has been updated
- Future package releases will reference the new repository URLs
- Existing PyPI package versions still reference old URLs (this is expected and harmless)

### MakerWorld
**Status**: No action required

**Note**:
- MakerWorld links in README are unaffected (they link to @kellerlab profile)
- Model descriptions may contain old GitHub URLs, but will redirect automatically

## ✅ Testing Checklist

### Pre-commit Hooks
```bash
# Install pre-commit
pip install pre-commit

# Run all hooks
pre-commit run --all-files
```

**Status**: ✅ Tested - All configuration checks pass

### Renovate Configuration
```bash
# Requires: Docker, GitHub CLI
./cmd/test/test-renovate-local.sh
```

**Status**: ⏳ Pending - Requires Docker environment

### CI/CD Workflows
- [ ] Trigger a workflow run manually to verify GitHub Actions still work
- [ ] Check that automerge workflow functions correctly
- [ ] Verify PR title validation works

## 📝 Notes

- GitHub automatically redirects old repository URLs (`kellervater/homeracker`) to new ones (`kellerlabs/homeracker`)
- Existing commit SHAs and URLs in CHANGELOG files remain unchanged (they still reference kellervater)
- The redirect is permanent unless the old repository name is reclaimed

## 🔍 Verification Commands

```bash
# Check for any remaining kellervater references (should only be in CHANGELOGs)
grep -r "kellervater" . --exclude-dir=.git --exclude="CHANGELOG.md" --exclude="POST_MIGRATION_TASKS.md"

# Validate renovate configuration
pre-commit run renovate-config-validator --all-files
```
