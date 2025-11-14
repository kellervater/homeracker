# 🔧 OpenSCAD Installation Scripts

Automated installation of OpenSCAD for the HomeRacker workspace (Windows only atm).

## 📦 Quick Start

```bash
# Install or upgrade to latest nightly release (default)
./tools/install-openscad.sh

# Install nightly build (default)
./tools/install-openscad.sh --nightly

# Install dependencies (BOSL2 library) - already done on a fresh install-openscad call
./tools/install-dependencies.sh

# Check if update is available
./tools/install-openscad.sh --check

# Run smoke test - validates the current openscad installation against local models
./tools/install-openscad.sh --test

# Force reinstall
./tools/install-openscad.sh --force
```

## 🤖 Automatic Updates

Versions are tracked in the scripts and managed by Renovate Bot. When new releases are available, Renovate creates a PR to update the versions. After merging, run the install scripts to upgrade.

## 📝 Notes

- **Default**: Nightly snapshots - latest features and fixes
- **Stable**: Release 2021.01 - use `--stable` flag for BOSL2 compatibility
- **Current support**: Windows only (via Git Bash)
- **Future**: macOS/Linux support tracked in [#40](https://github.com/kellervater/homeracker/issues/40)
- **BOSL2**: Installed to bundled libraries directory
- **Source**: https://files.openscad.org/
