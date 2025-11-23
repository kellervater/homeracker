#!/usr/bin/env bash
#
# HomeRacker Dependencies Installer
#
# Installs OpenSCAD libraries required by HomeRacker models.
# Currently installs: BOSL2
#
# Usage:
#   ./cmd/setup/install-dependencies.sh              # Install all dependencies
#   ./cmd/setup/install-dependencies.sh --check      # Check installation status
#   ./cmd/setup/install-dependencies.sh --help       # Show help
#

set -euo pipefail

# renovate: datasource=github-commits depName=BelfrySCAD/BOSL2 versioning=loose
BOSL2_VERSION="088d17ddd81d246fa1f0672a89a61c62958b7cee"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Source common functions
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

show_help() {
    cat << EOF
HomeRacker Dependencies Installer

Usage: $0 [OPTION]

Options:
  --check       Check installation status
  --force       Force reinstall even if version matches
  --help        Show this help message

Dependencies:
  BOSL2 ${BOSL2_VERSION} - Advanced OpenSCAD library

Examples:
  $0                    # Install all dependencies
  $0 --check            # Check installation status

EOF
}

# Find OpenSCAD libraries directory
find_libraries_dir() {
    local libraries_dir="${WORKSPACE_ROOT}/bin/openscad/libraries"

    if [[ -d "${libraries_dir}" ]]; then
        echo "${libraries_dir}"
        return 0
    else
        log_error "OpenSCAD installation not found. Run install-openscad.sh first."
        return 1
    fi
}

# Get installed BOSL2 version
get_bosl2_version() {
    local libraries_dir="$1"
    get_version "${libraries_dir}/BOSL2/.bosl2-version"
}

# Check installation status
check_status() {
    local libraries_dir

    if ! libraries_dir=$(find_libraries_dir); then
        exit 1
    fi

    local bosl2_version
    bosl2_version=$(get_bosl2_version "${libraries_dir}")

    log_info "BOSL2 tracked version: ${BOSL2_VERSION}"
    log_info "BOSL2 installed version: ${bosl2_version}"

    if [[ "${bosl2_version}" == "${BOSL2_VERSION}" ]]; then
        log_success "All dependencies up to date!"
        return 0
    else
        log_warning "Update available"
        return 1
    fi
}

# Install BOSL2
install_bosl2() {
    local libraries_dir="$1"
    local download_url="https://github.com/BelfrySCAD/BOSL2/archive/${BOSL2_VERSION}.tar.gz"
    local temp_file="/tmp/bosl2-${BOSL2_VERSION}.tar.gz"

    log_info "Installing BOSL2 ${BOSL2_VERSION}..."

    # Remove old installation
    if [[ -d "${libraries_dir}/BOSL2" ]]; then
        log_info "Removing old BOSL2 installation..."
        rm -rf "${libraries_dir}/BOSL2"
    fi

    # Download
    log_info "Downloading from ${download_url}..."
    if ! download_file "${download_url}" "${temp_file}"; then
        exit 1
    fi

    # Extract
    log_info "Extracting archive..."
    mkdir -p "${libraries_dir}/BOSL2"
    if ! tar -xzf "${temp_file}" -C "${libraries_dir}/BOSL2" --strip-components=1; then
        log_error "Failed to extract archive"
        rm -f "${temp_file}"
        exit 1
    fi

    # Cleanup
    rm -f "${temp_file}"

    # Save version info
    save_version "${libraries_dir}/BOSL2/.bosl2-version" "${BOSL2_VERSION}"

    log_success "BOSL2 ${BOSL2_VERSION} installed successfully!"
}

# Main function
main() {
    local check_only=false
    local force=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --check)
                check_only=true
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

    # Find libraries directory
    local libraries_dir
    if ! libraries_dir=$(find_libraries_dir); then
        exit 1
    fi

    # Execute based on flags
    if [[ "${check_only}" == true ]]; then
        check_status
        exit $?
    fi

    # Check if update needed (unless forced)
    if [[ "${force}" == false ]] && check_status; then
        log_info "Use --force to reinstall anyway"
    else
        install_bosl2 "${libraries_dir}"
    fi

    log_success "All dependencies installed!"
}

main "$@"
