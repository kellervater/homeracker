# 🔧 OpenSCAD Installation Scripts

Automated installation of OpenSCAD for the HomeRacker workspace (Windows/Linux/macOS).

## 📦 Quick Start

```bash
# Install or upgrade to latest nightly release (default)
./cmd/setup/install-openscad.sh

# Install nightly build (default)
./cmd/setup/install-openscad.sh --nightly

# Install dependencies (BOSL2 library) - already done on a fresh install-openscad call
./cmd/setup/install-dependencies.sh

# Check if update is available
./cmd/setup/install-openscad.sh --check

# Run smoke test - validates the current openscad installation against local models
./cmd/setup/install-openscad.sh --test

# Test specific model files (e.g., after export or during development)
./cmd/test/openscad-render.sh models/core/parts/connector.scad

# Run automated test suite (all models in test/ and makerworld/ directories)
./cmd/test/test-models.sh

# Force reinstall
./cmd/setup/install-openscad.sh --force
```

## 🤖 Automatic Updates

Versions are tracked in the scripts and managed by Renovate Bot. When new releases are available, Renovate creates a PR to update the versions. After merging, run the install scripts to upgrade.

## 📝 Notes

- **Default**: Nightly snapshots - latest features and fixes
- **Stable**: Release 2021.01 - use `--stable` flag for BOSL2 compatibility
<<<<<<< HEAD
- **Platform Support**: Windows, Linux, and macOS (macOS treated as Linux using AppImage - untested)
=======
- **Platform Support**: Windows, Linux, and macOS fully supported
>>>>>>> bd83f37ec35c27c70bc7a353551fc0e99c3c04fa
- **BOSL2**: Installed to bundled libraries directory
- **Source**: https://files.openscad.org/
