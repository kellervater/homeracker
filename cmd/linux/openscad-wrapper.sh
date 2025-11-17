#!/bin/bash
# OpenSCAD wrapper to fix Qt Wayland issues and set library path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
OPENSCAD_DIR="${WORKSPACE_ROOT}/bin/openscad"

export QT_QPA_PLATFORM=xcb
export OPENSCADPATH="${OPENSCAD_DIR}/libraries"
exec "${OPENSCAD_DIR}/OpenSCAD.AppImage" "$@"
