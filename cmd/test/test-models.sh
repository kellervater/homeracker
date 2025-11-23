#!/bin/bash
# Automated Test Suite - All Models
#
# Discovers and tests all .scad files in:
#   - models/*/test/     - Unit tests for model components
#   - models/*/makerworld/ - Exported parametric models
#
# This wrapper uses openscad-render.sh to render each discovered file.
# Use this for CI/CD or comprehensive validation.
# For testing specific files, call openscad-render.sh directly.

set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

# Change to repository root
cd "${SCRIPT_DIR}/../.."

# Find all .scad files in test/ subdirectories
MODELS=()

while IFS= read -r -d '' model; do
  MODELS+=("${model}")
done < <(find models -path "*/test/*.scad" -type f -print0)

# Also find all .scad files in makerworld/ export directory
while IFS= read -r -d '' model; do
  MODELS+=("${model}")
done < <(find models -path "*/makerworld/*.scad" -type f -print0)

if [ ${#MODELS[@]} -eq 0 ]; then
  echo "No test models found in models/*/test/ or models/*/makerworld/ directories"
  exit 1
fi

echo "Found ${#MODELS[@]} test models to validate"

# Test all models
"${SCRIPT_DIR}/openscad-render.sh" "${MODELS[@]}"
