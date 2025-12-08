"""VSCode extension management for scadm."""

import json
import logging
import platform
import shutil
import subprocess
from pathlib import Path

from scadm.installer import get_install_paths, get_workspace_root

logger = logging.getLogger(__name__)

EXTENSION_OPENSCAD = "Leathong.openscad-language-support"


def install_extension(extension_id: str) -> bool:
    """Install a VS Code extension.

    Args:
        extension_id: The extension identifier (e.g., 'publisher.extension').

    Returns:
        True if installation succeeded, False otherwise.
    """
    try:
        logger.info("Installing extension %s...", extension_id)
        # Use shell=True on Windows to properly find code.cmd
        use_shell = platform.system() == "Windows"
        subprocess.run(
            ["code", "--install-extension", extension_id, "--force"],
            check=True,
            capture_output=True,
            text=True,
            shell=use_shell,
        )
        logger.info("Extension %s installed", extension_id)
        return True
    except FileNotFoundError:
        logger.warning("VS Code CLI 'code' command not found")
        logger.warning("Install VS Code from: https://code.visualstudio.com/download")
        logger.warning("Make sure to enable 'Add to PATH' during installation")
        return False
    except subprocess.CalledProcessError as e:
        logger.error("Failed to install extension %s: %s", extension_id, e.stderr)
        return False


def get_openscad_paths(workspace_root: Path) -> tuple[str, str]:
    """Get OpenSCAD executable and library paths for VS Code config.

    Args:
        workspace_root: Workspace root directory.

    Returns:
        Tuple of (openscad_path, search_paths) formatted for VS Code settings.
    """
    install_dir, libraries_dir = get_install_paths(workspace_root)

    system = platform.system()
    if system == "Windows":
        # Convert to Windows paths with single backslashes (JSON will handle escaping)
        openscad_path = str(install_dir / "openscad.exe").replace("/", "\\")
        search_paths = str(libraries_dir).replace("/", "\\")
    else:
        # Linux/macOS: use wrapper script
        openscad_path = str(workspace_root / "cmd" / "linux" / "openscad-wrapper.sh")
        search_paths = str(libraries_dir)

    return openscad_path, search_paths


def update_vscode_settings(workspace_root: Path, openscad: bool = False) -> bool:
    """Update VS Code settings.json with extension configuration.

    Args:
        workspace_root: Workspace root directory.
        openscad: Whether to configure OpenSCAD settings.

    Returns:
        True if settings were updated successfully, False otherwise.
    """
    vscode_dir = workspace_root / ".vscode"
    settings_file = vscode_dir / "settings.json"

    # Load existing settings or start with empty dict
    settings = {}
    if settings_file.exists():
        try:
            with open(settings_file, "r", encoding="utf-8") as f:
                settings = json.load(f)
        except json.JSONDecodeError:
            logger.warning("Invalid JSON in settings.json, will overwrite")

    # Update OpenSCAD settings
    if openscad:
        openscad_path, search_paths = get_openscad_paths(workspace_root)
        # Deep merge for files.associations
        if "files.associations" not in settings or not isinstance(settings["files.associations"], dict):
            settings["files.associations"] = {}
        settings["files.associations"]["*.scad"] = "scad"
        settings["files.eol"] = "\n"
        settings["scad-lsp.launchPath"] = openscad_path
        settings["scad-lsp.searchPaths"] = search_paths

    # Write settings
    vscode_dir.mkdir(parents=True, exist_ok=True)
    try:
        with open(settings_file, "w", encoding="utf-8") as f:
            json.dump(settings, f, indent=2, sort_keys=True)
        logger.info("Updated VS Code settings")
        return True
    except OSError as e:
        logger.error("Failed to write settings.json: %s", e)
        return False


def setup_openscad_extension() -> bool:
    """Install and configure OpenSCAD extension for VS Code.

    Returns:
        True if setup succeeded, False otherwise.
    """
    # Check VS Code is installed
    if not shutil.which("code"):
        logger.warning("VS Code CLI 'code' command not found")
        logger.warning("Install VS Code from: https://code.visualstudio.com/download")
        logger.warning("Make sure to enable 'Add to PATH' during installation")
        return False

    # Get workspace root
    try:
        workspace_root = get_workspace_root()
    except FileNotFoundError as e:
        logger.error("%s", e)
        return False

    # Install extension
    if not install_extension(EXTENSION_OPENSCAD):
        return False

    # Update settings
    if not update_vscode_settings(workspace_root, openscad=True):
        return False

    logger.info("VS Code configured for OpenSCAD")
    return True
