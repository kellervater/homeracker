#!/bin/bash
# Test script for validating OpenSCAD models
# This script finds and validates all .scad files in the models directory

set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

# Change to repository root
cd "${SCRIPT_DIR}/../.."

# Find all .scad files in model subdirectories, excluding core/
MODELS=()

# Dynamically discover all directories under models/ except core
for dir in models/*/; do
  # Skip if not a directory
  [ -d "${dir}" ] || continue
  
  # Extract directory name
  dirname=$(basename "${dir}")
  
  # Skip core directory (library components, not standalone models)
  if [[ "${dirname}" == "core" ]]; then
    continue
  fi
  
  # Find all .scad files in this directory
  for model in "${dir}"*.scad; do
    if [ -f "${model}" ]; then
      MODELS+=("${model}")
    fi
  done
done

echo "Found ${#MODELS[@]} models to validate"

# Test all models
"${SCRIPT_DIR}/test-openscad.sh" "${MODELS[@]}"
