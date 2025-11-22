#!/bin/bash
# Test script for validating OpenSCAD models
# This script finds and executes all .scad files in test/ subdirectories

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

if [ ${#MODELS[@]} -eq 0 ]; then
  echo "No test models found in models/*/test/ directories"
  exit 1
fi

echo "Found ${#MODELS[@]} test models to validate"

# Test all models
"${SCRIPT_DIR}/test-openscad.sh" "${MODELS[@]}"
