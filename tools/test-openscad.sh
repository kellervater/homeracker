#!/usr/bin/env bash
#
# OpenSCAD Smoke Test
#
# Tests OpenSCAD installation by rendering a sample model
#
# Usage:
#   ./tools/test-openscad.sh              # Run smoke test
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INSTALL_DIR="${WORKSPACE_ROOT}/bin/openscad"

# Detect platform
detect_platform() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "mac";;
        CYGWIN*|MINGW*|MSYS*)    echo "windows";;
        *)          echo "unknown";;
    esac
}

PLATFORM=$(detect_platform)

# Source common functions
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

# Find OpenSCAD executable path
find_openscad_exe() {
    if [[ "${PLATFORM}" == "windows" ]]; then
        # First try .com (better for terminal usage)
        if [[ -f "${INSTALL_DIR}/openscad.com" ]]; then
            echo "${INSTALL_DIR}/openscad.com"
            return 0
        # Fall back to .exe if .com not found
        elif [[ -f "${INSTALL_DIR}/openscad.exe" ]]; then
            echo "${INSTALL_DIR}/openscad.exe"
            return 0
        else
            return 1
        fi
    else
        # Linux/Mac: check for openscad binary or AppImage
        if [[ -f "${INSTALL_DIR}/openscad" ]]; then
            echo "${INSTALL_DIR}/openscad"
            return 0
        elif [[ -f "${INSTALL_DIR}/OpenSCAD.AppImage" ]]; then
            echo "${INSTALL_DIR}/OpenSCAD.AppImage"
            return 0
        else
            return 1
        fi
    fi
}

# Run smoke test
smoke_test() {
    local openscad_exe
    local test_file="${WORKSPACE_ROOT}/models/wallmount/wallmount.scad"
    local output_file="/tmp/homeracker-smoketest.stl"
    
    log_info "Running smoke test..."
    
    # Find OpenSCAD executable
    if ! openscad_exe=$(find_openscad_exe); then
        log_error "OpenSCAD executable not found. Please install first."
        exit 1
    fi
    
    # Show OpenSCAD version
    local openscad_version
    openscad_version=$("${openscad_exe}" --version 2>&1 | awk '/OpenSCAD version/ {print $3}')
    log_info "Using OpenSCAD version: ${openscad_version}"
    
    # Library path is always relative to install dir
    local libraries_dir="${INSTALL_DIR}/libraries"
    
    if [[ ! -d "${libraries_dir}" ]]; then
        log_error "Libraries directory not found: ${libraries_dir}"
        exit 1
    fi
    
    # Check if test file exists
    if [[ ! -f "${test_file}" ]]; then
        log_error "Test file not found: ${test_file}"
        exit 1
    fi
    
    # Clean up old test output
    rm -f "${output_file}"
    
    # Render the test file with OPENSCADPATH set to bundled libraries
    log_info "Rendering $(basename "${test_file}")..."
    log_info "Using libraries from: ${libraries_dir}"
    if OPENSCADPATH="${libraries_dir}" "${openscad_exe}" -o "${output_file}" "${test_file}" --export-format=binstl 2>&1 | tee /tmp/openscad-test.log; then
        # Check if output file was created
        if [[ -f "${output_file}" ]]; then
            local file_size
            file_size=$(stat -c%s "${output_file}" 2>/dev/null || stat -f%z "${output_file}" 2>/dev/null)
            log_success "Smoke test passed! Generated STL: ${file_size} bytes"
            rm -f "${output_file}"
            rm -f /tmp/openscad-test.log
            return 0
        else
            log_error "Smoke test failed: No output file generated"
            cat /tmp/openscad-test.log
            return 1
        fi
    else
        log_error "Smoke test failed: OpenSCAD rendering error"
        cat /tmp/openscad-test.log
        return 1
    fi
}

# Main function
main() {
    smoke_test
}

main "$@"
