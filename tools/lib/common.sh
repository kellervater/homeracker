#!/usr/bin/env bash
#
# HomeRacker Common Shell Functions
#
# Shared utilities for installation scripts.
# Usage: source "${SCRIPT_DIR}/lib/common.sh"
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $*"
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $*"
}

log_error() {
    echo -e "${RED}✗${NC} $*"
}

# Version file helpers
save_version() {
    local version_file="$1"
    local version="$2"
    echo "${version}" > "${version_file}"
}

get_version() {
    local version_file="$1"
    if [[ -f "${version_file}" ]]; then
        cat "${version_file}"
    else
        echo "none"
    fi
}

# Download helper
download_file() {
    local url="$1"
    local output="$2"
    
    if ! curl -L -f -o "${output}" "${url}"; then
        log_error "Failed to download from ${url}"
        return 1
    fi
    return 0
}
