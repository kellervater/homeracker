#!/usr/bin/env bash
#
# OpenSCAD Nightly Installer (Cross-platform: Windows/Linux)
#
# This script downloads and installs the latest OpenSCAD nightly build.
# Version tracking is handled by Renovate Bot.
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
OPENSCAD_NIGHTLY_VERSION_WINDOWS="2025.11.20"
# renovate: datasource=custom.openscad-snapshots depName=OpenSCAD versioning=loose
OPENSCAD_NIGHTLY_VERSION_LINUX="2025.11.20.ai29236"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INSTALL_DIR="${WORKSPACE_ROOT}/bin/openscad"

# Detect platform
detect_platform() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        CYGWIN*|MINGW*|MSYS*)    echo "windows";;
        *)          echo "unknown";;
    esac
}

PLATFORM=$(detect_platform)

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
    local openscad_exe
    if [[ "${PLATFORM}" == "windows" ]]; then
        if [[ -f "${INSTALL_DIR}/openscad.exe" ]]; then
            openscad_exe="${INSTALL_DIR}/openscad.exe"
        else
            echo "none"
            return
        fi
    else
        if [[ -f "${INSTALL_DIR}/openscad" ]]; then
            openscad_exe="${INSTALL_DIR}/openscad"
        elif [[ -f "${INSTALL_DIR}/OpenSCAD.AppImage" ]]; then
            openscad_exe="${INSTALL_DIR}/OpenSCAD.AppImage"
        else
            echo "none"
            return
        fi
    fi
    
    "${openscad_exe}" --version 2>&1 | awk '/OpenSCAD version/ {print $3}'
}

# Get OpenSCAD version based on nightly flag
get_openscad_version() {
    if [[ "${INSTALL_NIGHTLY}" == true ]]; then
        if [[ "${PLATFORM}" == "linux" ]]; then
            echo "${OPENSCAD_NIGHTLY_VERSION_LINUX}"
        else
            echo "${OPENSCAD_NIGHTLY_VERSION_WINDOWS}"
        fi
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
    
    if [[ "${PLATFORM}" == "linux" ]]; then
        install_openscad_linux "${openscad_version}"
    elif [[ "${PLATFORM}" == "windows" ]]; then
        install_openscad_windows "${openscad_version}"
    else
        log_error "Unsupported platform: ${PLATFORM}"
        exit 1
    fi
    
    log_success "OpenSCAD ${openscad_version} installed successfully!"
    
    # Install dependencies (BOSL2)
    log_info "Installing dependencies..."
    chmod +x "${SCRIPT_DIR}/install-dependencies.sh"
    "${SCRIPT_DIR}/install-dependencies.sh"
}

# Install OpenSCAD on Linux
install_openscad_linux() {
    local openscad_version="$1"
    local download_url
    
    if [[ "${INSTALL_NIGHTLY}" == true ]]; then
        download_url="https://files.openscad.org/snapshots/OpenSCAD-${openscad_version}-x86_64.AppImage"
    else
        download_url="https://files.openscad.org/OpenSCAD-${openscad_version}-x86_64.AppImage"
    fi
    
    log_info "Installing OpenSCAD ${openscad_version} for Linux..."
    
    # Remove old installation
    if [[ -d "${INSTALL_DIR}" ]]; then
        log_info "Cleaning up old installation..."
        rm -rf "${INSTALL_DIR}"
    fi
    
    # Create installation directory
    mkdir -p "${INSTALL_DIR}/libraries"
    
    # Download
    log_info "Downloading from ${download_url}..."
    if ! download_file "${download_url}" "${INSTALL_DIR}/OpenSCAD.AppImage"; then
        log_error "URL: ${download_url}"
        exit 1
    fi
    
    # Make executable
    chmod +x "${INSTALL_DIR}/OpenSCAD.AppImage"
    
    # Create symlink (relative path)
    cd "${INSTALL_DIR}"
    ln -sf OpenSCAD.AppImage openscad
    cd - > /dev/null
}

# Install OpenSCAD on Windows
install_openscad_windows() {
    local openscad_version="$1"
    local download_url
    
    if [[ "${INSTALL_NIGHTLY}" == true ]]; then
        download_url="https://files.openscad.org/snapshots/OpenSCAD-${openscad_version}-x86-64.zip"
    else
        download_url="https://files.openscad.org/OpenSCAD-${openscad_version}-x86-64.zip"
    fi
    
    local temp_file="/tmp/openscad-${openscad_version}.zip"
    
    log_info "Installing OpenSCAD ${openscad_version} for Windows..."
    
    # Remove old installation
    if [[ -d "${INSTALL_DIR}" ]]; then
        log_info "Cleaning up old installation..."
        rm -rf "${INSTALL_DIR}"
    fi
    
    # Create installation directory
    mkdir -p "${INSTALL_DIR}/libraries"
    
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
