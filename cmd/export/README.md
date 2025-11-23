# MakerWorld Export Tool

Exports OpenSCAD models for MakerWorld's parametric feature by inlining all local includes into a single file.

## Usage

```bash
python cmd/export/export_makerworld.py <input.scad>
```

Output is written to `models/core/makerworld/<filename>.scad`

## File Structure Assumptions

This script is opinionated about file structure, following **OpenSCAD Customizer** conventions:

**Root files** (files being exported, e.g., `parts/*.scad`):
1. Parameter sections: `/* [SectionName] */` with customizable variables
2. Hidden section: `/* [Hidden] */` with constants/variables hidden from UI
3. Main code: module/function calls that generate geometry

**Variable placement behavior:**
- Variables between `/* [Hidden] */` and first module/function → included in Hidden section (hidden from UI)
- Variables after main code (after last module call) → filtered out (not included in export)
- Best practice: Keep all non-parameter variables in `/* [Hidden] */` section before the first module call

**Library files** (included via `include <...>`):
- Must contain ONLY module/function definitions and constants
- Must NOT have parameter section markers (`/* [Name] */`)
- The script validates this and fails with an error if violated

> [!NOTE]
> Library files (included via `include <...>`) **must not** contain parameter section markers like `/* [Parameters] */` or `/* [Hidden] */`. Only the root file being exported should have these markers. The script will fail with a clear error if it detects parameter sections in library files.

## What it does

- Preserves BOSL2 library references (required by MakerWorld)
- Keeps parameter sections with their comments (for MakerWorld customizer)
- Inlines all local includes recursively
- Strips comments from inlined library code
- Prevents duplicate includes

## Example

```bash
python cmd/export/export-makerworld.py models/core/parts/connector.scad
# → models/core/makerworld/connector.scad
```

## Testing

Use the automated export system:

```bash
# Export all configured models and validate
./cmd/export/export-core-models.sh
```

Or test a single model:

```bash
python cmd/export/export_makerworld.py models/core/parts/connector.scad
# → models/core/makerworld/connector.scad
```

## Automated Export System

### Setup Pre-commit Hooks

This project uses the [pre-commit](https://pre-commit.com/) framework:

```bash
# Install pre-commit (if not already installed)
pip install pre-commit

# Install git hooks
pre-commit install
```

### Components

**`export-core-models.sh`** - Orchestrates the export process:
- Auto-discovers models from configured paths (`models/core/parts`)
- Exports each via `export_makerworld.py`
- Validates exports with `test-models.sh`

**Pre-commit hook** - Configured in `.pre-commit-config.yaml`:
- Runs `export-core-models.sh` automatically on commit
- Validates exports are in sync with source files
- Only runs when core model files change

**GitHub Actions** - CI workflow runs all pre-commit hooks on PRs

### Running Manually

```bash
# Run all pre-commit hooks
pre-commit run --all-files

# Run only the MakerWorld export validation
pre-commit run validate-makerworld-exports --all-files
```

### Adding New Models

Edit `cmd/export/export-core-models.sh` and add to `EXPORT_PATHS`:

```bash
EXPORT_PATHS=(
    "models/core/parts"           # Folder: auto-discovers .scad files
    "models/other/special.scad"   # File: exports specific file
)
```
