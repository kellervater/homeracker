#!/usr/bin/env bash
#
# VSCode OpenSCAD Language Support Installer
#
# Installs the OpenSCAD extension and configures settings.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
INSTALL_DIR="${WORKSPACE_ROOT}/bin/openscad"
VSCODE_SETTINGS="${WORKSPACE_ROOT}/.vscode/settings.json"
EXTENSION_ID="Leathong.openscad-language-support"

# Source common functions
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

# Detect platform
case "$(uname -s)" in
    Linux*)     PLATFORM="linux";;
    CYGWIN*|MINGW*|MSYS*)    PLATFORM="windows";;
    *)          PLATFORM="unknown";;
esac

# Install extension
log_info "Installing OpenSCAD extension..."
code --install-extension "${EXTENSION_ID}" --force > /dev/null 2>&1 || true

# Get OpenSCAD path
if [[ "${PLATFORM}" == "windows" ]]; then
    OPENSCAD_PATH=$(cygpath -w "${INSTALL_DIR}/openscad.exe" | sed 's/\\/\\\\/g')
    SEARCH_PATHS=$(cygpath -w "${INSTALL_DIR}/libraries" | sed 's/\\/\\\\/g')
else
    OPENSCAD_PATH="${INSTALL_DIR}/openscad"
    SEARCH_PATHS="${INSTALL_DIR}/libraries"
fi

# Configure settings
log_info "Configuring settings..."
mkdir -p "${WORKSPACE_ROOT}/.vscode"

cat > "${VSCODE_SETTINGS}" << EOF
{
  "scad-lsp.launchPath": "${OPENSCAD_PATH}",
  "scad-lsp.searchPaths": "${SEARCH_PATHS}",
  "files.associations": {
    "*.scad": "scad"
  },
  "files.eol": "\n"
}
EOF

log_success "VSCode configured for OpenSCAD"
