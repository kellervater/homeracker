#!/usr/bin/env bash
#
# OpenSCAD Nightly Installer for Windows (Git Bash)
#
# This script downloads and installs the latest OpenSCAD nightly build
# for Windows. Version tracking is handled by Renovate Bot.
#
# Usage:
#   ./tools/install-openscad.sh              # Install/upgrade to nightly build (default)
#   ./tools/install-openscad.sh --stable     # Install stable release
#   ./tools/install-openscad.sh --check      # Check current vs tracked version
#   ./tools/install-openscad.sh --test       # Run smoke test
#   ./tools/install-openscad.sh --configure  # Update VS Code settings only
#   ./tools/install-openscad.sh --force      # Force reinstall
#   ./tools/install-openscad.sh --help       # Show help
#

set -euo pipefail

# Default to nightly builds for latest features, use --stable for BOSL2 compatibility
INSTALL_NIGHTLY=true

# renovate: datasource=github-releases depName=openscad/openscad
OPENSCAD_STABLE_VERSION="2021.01"

# renovate: datasource=custom.openscad-snapshots depName=OpenSCAD versioning=loose
OPENSCAD_NIGHTLY_VERSION="2024.11.18"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INSTALL_DIR="${WORKSPACE_ROOT}/bin/openscad"

# Source common functions
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

show_help() {
    local openscad_version="${OPENSCAD_STABLE_VERSION}"
    [[ "${INSTALL_NIGHTLY}" == true ]] && openscad_version="${OPENSCAD_NIGHTLY_VERSION}"
    
    cat << EOF
OpenSCAD Installer

Usage: $0 [OPTION]

Options:
  --check       Check current installation vs tracked version
  --test        Run smoke test (render wallmount.scad)
  --nightly     Install nightly snapshot (default, latest features)
  --stable      Install stable release (for BOSL2 compatibility)
  --force       Force reinstall even if version matches
  --help        Show this help message

Version Management:
  Nightly version (default): ${OPENSCAD_NIGHTLY_VERSION}
  Stable version: ${OPENSCAD_STABLE_VERSION}
  Current tracked version: ${openscad_version}

Examples:
  $0                    # Install/upgrade OpenSCAD (nightly)
  $0 --stable           # Install/upgrade OpenSCAD (stable 2021.01 for BOSL2)
  $0 --check            # Check versions
  $0 --test             # Verify installation with smoke test

EOF
}

# Get currently installed version from binary
get_installed_version() {
    if [[ -f "${INSTALL_DIR}/openscad.exe" ]]; then
        "${INSTALL_DIR}/openscad.exe" --version 2>&1 | awk '/OpenSCAD version/ {print $3}'
    else
        echo "none"
    fi
}

# Get OpenSCAD version based on nightly flag
get_openscad_version() {
    if [[ "${INSTALL_NIGHTLY}" == true ]]; then
        echo "${OPENSCAD_NIGHTLY_VERSION}"
    else
        echo "${OPENSCAD_STABLE_VERSION}"
    fi
}

# Check if installation is needed
check_version() {
    local installed_version
    local openscad_version
    installed_version=$(get_installed_version)
    openscad_version=$(get_openscad_version)
    
    log_info "Tracked version: ${openscad_version}"
    log_info "Installed version: ${installed_version}"
    
    if [[ "${installed_version}" == "${openscad_version}" ]]; then
        log_success "OpenSCAD is up to date!"
        return 0
    else
        log_warning "Version mismatch - update available"
        return 1
    fi
}

# Download and install OpenSCAD
install_openscad() {
    local openscad_version
    openscad_version=$(get_openscad_version)
    
    local download_url
    if [[ "${INSTALL_NIGHTLY}" == true ]]; then
        download_url="https://files.openscad.org/snapshots/OpenSCAD-${openscad_version}-x86-64.zip"
    else
        download_url="https://files.openscad.org/OpenSCAD-${openscad_version}-x86-64.zip"
    fi
    
    local temp_file="/tmp/openscad-${openscad_version}.zip"
    
    log_info "Installing OpenSCAD ${openscad_version}..."
    
    # Remove old installation
    if [[ -d "${INSTALL_DIR}" ]]; then
        log_info "Cleaning up old installation..."
        rm -rf "${INSTALL_DIR}"
    fi
    
    # Create installation directory
    mkdir -p "${INSTALL_DIR}"
    
    # Download
    log_info "Downloading from ${download_url}..."
    if ! download_file "${download_url}" "${temp_file}"; then
        log_error "URL: ${download_url}"
        exit 1
    fi
    
    # Extract (strip top-level folder)
    log_info "Extracting archive..."
    if ! unzip -q "${temp_file}" -d "${INSTALL_DIR}"; then
        log_error "Failed to extract archive"
        rm -f "${temp_file}"
        exit 1
    fi
    
    # Move contents up one level (zip contains OpenSCAD-VERSION/* structure)
    shopt -s dotglob
    mv "${INSTALL_DIR}"/OpenSCAD-*/* "${INSTALL_DIR}/"
    rmdir "${INSTALL_DIR}"/OpenSCAD-*
    shopt -u dotglob
    
    rm -f "${temp_file}"
    
    # Verify installation
    if [[ -f "${INSTALL_DIR}/openscad.exe" ]]; then
        log_success "OpenSCAD ${openscad_version} installed successfully!"
    else
        log_error "Installation completed but openscad executable not found"
        exit 1
    fi
    
    # Install dependencies (BOSL2)
    log_info "Installing dependencies..."
    "${SCRIPT_DIR}/install-dependencies.sh"
}

# Run smoke test
smoke_test() {
    "${SCRIPT_DIR}/test-openscad.sh"
}

# Main function
main() {
    local check_only=false
    local test_only=false
    local force=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --check)
                check_only=true
                shift
                ;;
            --test)
                test_only=true
                shift
                ;;
            --stable)
                INSTALL_NIGHTLY=false
                shift
                ;;
            --nightly)
                INSTALL_NIGHTLY=true
                shift
                ;;
            --force)
                force=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Execute based on flags
    if [[ "${check_only}" == true ]]; then
        check_version
        exit $?
    fi
    
    if [[ "${test_only}" == true ]]; then
        smoke_test
        exit $?
    fi
    
    # Check if update needed (unless forced)
    if [[ "${force}" == false ]] && check_version; then
        log_info "Use --force to reinstall anyway"
    else
        install_openscad
    fi
    
    local openscad_version
    openscad_version=$(get_openscad_version)
    log_success "Setup complete! OpenSCAD ${openscad_version} is ready to use."
}

main "$@"
