# 🔧 OpenSCAD Installation Scripts

Automated installation of OpenSCAD for the HomeRacker workspace (Windows/Linux/macOS).

## 📦 Quick Start

```bash
# Install or upgrade to latest nightly release (default) + dependencies
python3 cmd/setup/install.py

# Install nightly build (default)
python3 cmd/setup/install.py --nightly

# Install stable release
python3 cmd/setup/install.py --stable

# Check if update is available
python3 cmd/setup/install.py --check

# Run smoke test - validates the current openscad installation against local models
./cmd/test/openscad-render.sh models/core/parts/connector.scad

# Run automated test suite (all models in test/ and makerworld/ directories)
./cmd/test/test-models.sh

# Force reinstall
python3 cmd/setup/install.py --force
```

## 🤖 Automatic Updates

Versions are tracked in the scripts and managed by Renovate Bot. When new releases are available, Renovate creates a PR to update the versions. After merging, run the install scripts to upgrade.

## 📝 Notes

- **Default**: Nightly snapshots - latest features and fixes
- **Stable**: Release 2021.01 - use `--stable` flag for BOSL2 compatibility
- **Platform Support**: Windows, Linux, and macOS (macOS treated as Linux using AppImage - untested)
- **BOSL2**: Installed to bundled libraries directory
- **Source**: https://files.openscad.org/

## 📦 Dependency Management

Dependencies are defined in `cmd/setup/dependencies.json`. The installer supports both Git commit hashes (SHAs) and SemVer tags.

### Configuration Format (`dependencies.json`)

```json
{
  "dependencies": [
    {
      "name": "BOSL2",
      "repository": "BelfrySCAD/BOSL2",
      "version": "266792b2a4bbf7514e73225dfadb92da95f2afe1",
      "source": "github"
    },
    {
      "name": "homeracker",
      "repository": "kellervater/homeracker",
      "version": "v1.1.0",
      "source": "github"
    }
  ]
}
```

### Renovate Integration

To enable Renovate to update these dependencies, extend the configuration from this repository in your `renovate.json`:

```json
{
  "extends": [
    "github>kellervater/homeracker:renovate-dependencies.json"
  ]
}
```
