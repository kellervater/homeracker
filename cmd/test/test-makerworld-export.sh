#!/usr/bin/env bash
# DEPRECATED: Use cmd/export/export-core-models.sh instead
#
# This script is kept for backward compatibility but will be removed in the future.
# Please use the new export-core-models.sh script which handles all models automatically.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "WARNING: This script is deprecated. Use cmd/export/export-core-models.sh instead"
echo ""
echo "Testing MakerWorld export script..."

# Test with connector.scad
echo "Exporting connector.scad..."
python "$PROJECT_ROOT/cmd/export/export_makerworld.py" "$PROJECT_ROOT/models/core/parts/connector.scad"

# Verify output exists
EXPORT_FILE="$PROJECT_ROOT/models/core/makerworld/connector.scad"
if [ ! -f "$EXPORT_FILE" ]; then
    echo "ERROR: Export file not created"
    exit 1
fi

# Verify it contains no local includes (only BOSL2)
if grep -E "include <(?!BOSL2)" "$EXPORT_FILE" > /dev/null; then
    echo "ERROR: Found local includes in exported file"
    exit 1
fi

# Verify it contains BOSL2 include
if ! grep -q "include <BOSL2/std.scad>" "$EXPORT_FILE"; then
    echo "ERROR: Missing BOSL2 include"
    exit 1
fi

# Verify it contains parameters section
if ! grep -q "/\* \[Parameters\] \*/" "$EXPORT_FILE"; then
    echo "ERROR: Missing parameters section"
    exit 1
fi

# Verify it renders without errors
echo "Validating with OpenSCAD..."
OPENSCAD_OUTPUT=$("$PROJECT_ROOT/bin/openscad/openscad.com" --export-format=echo --o /dev/null "$EXPORT_FILE" 2>&1)
OPENSCAD_EXIT=$?

# Check for errors or syntax errors
if echo "$OPENSCAD_OUTPUT" | grep -iE "error|syntax" > /dev/null; then
    echo "ERROR: OpenSCAD rendering failed"
    echo "$OPENSCAD_OUTPUT"
    exit 1
fi

if [ $OPENSCAD_EXIT -ne 0 ]; then
    echo "ERROR: OpenSCAD exited with code $OPENSCAD_EXIT"
    echo "$OPENSCAD_OUTPUT"
    exit 1
fi

echo "✓ All tests passed"
