# 🔧 OpenSCAD Installation and Testing

This directory contains testing scripts for OpenSCAD models.

For installation, use the **scadm** package (see `cmd/scadm/` or install via `pip install scadm`).

## 📦 Quick Start

```bash
# Install scadm (if not already installed)
pip install -e cmd/scadm

# Install OpenSCAD + dependencies from scadm.json
scadm install

# Check if updates are available
scadm install --check

# Run smoke test - validates the current openscad installation against local models
./cmd/test/openscad-render.sh models/core/parts/connector.scad

# Run automated test suite (all models in test/ and makerworld/ directories)
./cmd/test/test-models.sh
```

## 🤖 Automatic Updates

OpenSCAD versions are managed by Renovate Bot in `cmd/scadm/scadm/constants.py`. When new releases are available, Renovate creates a PR to update the versions.

## 📦 Dependency Management

Dependencies are defined in `scadm.json` at the repository root. The installer supports both Git commit hashes (SHAs) and SemVer tags.

### Configuration Format (`scadm.json`)

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

> **Note**: Use `github>...` for external repositories. Internally, this repository uses `local>...`.

```json
{
  "extends": [
    "github>kellervater/homeracker:renovate-dependencies.json"
  ]
}
```
