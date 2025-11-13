# 🔧 OpenSCAD Installation Scripts

Automated installation of OpenSCAD for the HomeRacker workspace (Windows only atm).

## 📦 Quick Start

```bash
# Install or upgrade to latest stable release (default)
./tools/install-openscad.sh

# Install nightly build
./tools/install-openscad.sh --nightly

# Install dependencies (BOSL2 library)
./tools/install-dependencies.sh

# Check if update is available
./tools/install-openscad.sh --check

# Run smoke test
./tools/install-openscad.sh --test

# Reconfigure VS Code only
./tools/install-openscad.sh --configure

# Force reinstall
./tools/install-openscad.sh --force
```

## 🤖 Automatic Updates

Versions are tracked in the scripts and managed by Renovate Bot. When new releases are available, Renovate creates a PR to update the versions. After merging, run the install scripts to upgrade.

## 📝 Notes

- **Default**: Stable release (2021.01) - recommended for compatibility with BOSL2
- **Nightly**: Development snapshots - use `--nightly` flag for latest features
- **Current support**: Windows only (via Git Bash)
- **Future**: macOS/Linux support tracked in [#40](https://github.com/kellervater/homeracker/issues/40)
- **VS Code**: Auto-configures workspace settings after installation
- **BOSL2**: Installed to bundled libraries directory
- **Source**: https://files.openscad.org/

