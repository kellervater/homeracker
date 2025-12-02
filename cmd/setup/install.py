#!/usr/bin/env python3
"""
HomeRacker Setup Script

Installs OpenSCAD (Nightly/Stable) and required libraries (BOSL2, etc.).
Replaces install-openscad.sh and install_dependencies.py.
"""

import argparse
import ctypes
import json
import os
import platform
import re
import shutil
import stat
import subprocess
import sys
import tarfile
import urllib.request
import urllib.error
import zipfile
from pathlib import Path

# --- Configuration ---

# renovate: datasource=github-releases depName=openscad/openscad
OPENSCAD_STABLE_VERSION = "2021.01"

# renovate: datasource=custom.openscad-snapshots depName=OpenSCAD versioning=loose
OPENSCAD_NIGHTLY_VERSION_WINDOWS = "2025.11.29"
# renovate: datasource=custom.openscad-snapshots depName=OpenSCAD versioning=loose
OPENSCAD_NIGHTLY_VERSION_LINUX = "2025.11.29.ai29571"

# Constants
SCRIPT_DIR = Path(__file__).parent.resolve()
WORKSPACE_ROOT = SCRIPT_DIR.parent.parent
DEPENDENCIES_FILE = SCRIPT_DIR / "dependencies.json"
INSTALL_DIR = WORKSPACE_ROOT / "bin" / "openscad"
LIBRARIES_DIR = INSTALL_DIR / "libraries"


# --- Colors & Logging ---
class Colors:  # pylint: disable=too-few-public-methods
    """ANSI Color codes"""

    HEADER = "\033[95m"
    BLUE = "\033[94m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    ENDC = "\033[0m"

    @staticmethod
    def disable():
        """Disable colors"""
        Colors.HEADER = ""
        Colors.BLUE = ""
        Colors.GREEN = ""
        Colors.YELLOW = ""
        Colors.RED = ""
        Colors.ENDC = ""


if os.name == "nt":
    # Enable ANSI colors in Windows terminal if possible, or disable them
    try:
        kernel32 = ctypes.windll.kernel32
        kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)
    except Exception:  # pylint: disable=broad-exception-caught
        Colors.disable()


def log_info(msg):
    """Log info message.

    Args:
        msg: The message to log.
    """
    print(f"{Colors.BLUE}ℹ{Colors.ENDC} {msg}")


def log_success(msg):
    """Log success message.

    Args:
        msg: The message to log.
    """
    print(f"{Colors.GREEN}✓{Colors.ENDC} {msg}")


def log_warning(msg):
    """Log warning message.

    Args:
        msg: The message to log.
    """
    print(f"{Colors.YELLOW}⚠{Colors.ENDC} {msg}")


def log_error(msg):
    """Log error message.

    Args:
        msg: The message to log.
    """
    print(f"{Colors.RED}✗{Colors.ENDC} {msg}")


# --- Helpers ---


def download_file(url, dest_path):
    """Download a file from URL to dest_path.

    Args:
        url: The URL to download from.
        dest_path: The destination path to save the file.

    Returns:
        True if download succeeded, False otherwise.
    """
    try:
        log_info(f"Downloading {url}...")
        urllib.request.urlretrieve(url, dest_path)
        return True
    except urllib.error.URLError as e:
        log_error(f"Failed to download {url}: {e}")
        return False


def get_system_platform():
    """Get system platform (windows, linux, unknown).

    Returns:
        String representing the platform ('windows', 'linux', or 'unknown').
    """
    system = platform.system().lower()
    if system == "windows":
        return "windows"
    if system == "linux":
        return "linux"
    if system == "darwin":
        return "linux"  # Treat macOS as Linux (AppImage) for now
    return "unknown"


def get_openscad_version(nightly=True, os_name="linux"):
    """Get target OpenSCAD version.

    Args:
        nightly: Whether to use nightly build.
        os_name: Operating system name.

    Returns:
        Version string.
    """
    if not nightly:
        return OPENSCAD_STABLE_VERSION

    if os_name == "windows":
        return OPENSCAD_NIGHTLY_VERSION_WINDOWS
    return OPENSCAD_NIGHTLY_VERSION_LINUX


def get_installed_openscad_version(os_name):
    """Get currently installed OpenSCAD version.

    Args:
        os_name: Operating system name.

    Returns:
        Version string if installed, None otherwise.
    """
    if os_name == "windows":
        exe = INSTALL_DIR / "openscad.exe"
    else:
        exe = INSTALL_DIR / "openscad"  # Symlink or script
        if not exe.exists():
            exe = INSTALL_DIR / "OpenSCAD.AppImage"

    if not exe.exists():
        return None

    # Try to run it to get version
    try:
        # On Windows, we might need to be careful with path
        cmd = [str(exe), "--version"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=False)
        # OpenSCAD prints version to stderr usually
        output = result.stderr + result.stdout
        # Parse "OpenSCAD version 2024.03.17"
        match = re.search(r"OpenSCAD version ([^\s]+)", output)
        if match:
            return match.group(1)
    except Exception:  # pylint: disable=broad-exception-caught
        pass
    return None


# --- OpenSCAD Installation ---


def install_openscad(nightly=True, force=False, check_only=False):
    """Install OpenSCAD binary.

    Args:
        nightly: Whether to install nightly build.
        force: Force reinstall even if version matches.
        check_only: Only check installation status.

    Returns:
        True if successful or up to date, False otherwise.
    """
    os_name = get_system_platform()
    if os_name == "unknown":
        log_error("Unsupported platform")
        return False

    target_version = get_openscad_version(nightly, os_name)
    current_version = get_installed_openscad_version(os_name)

    if check_only:
        if current_version == target_version:
            log_success(f"OpenSCAD: Up to date ({target_version})")
            return True
        log_warning(f"OpenSCAD: Update available ({current_version or 'none'} -> {target_version})")
        return False

    if current_version == target_version and not force:
        log_success(f"OpenSCAD is up to date ({target_version})")
        return True

    log_info(f"Installing OpenSCAD {target_version} ({'Nightly' if nightly else 'Stable'})...")

    if INSTALL_DIR.exists():
        log_info("Cleaning old installation...")
        shutil.rmtree(INSTALL_DIR)

    INSTALL_DIR.mkdir(parents=True, exist_ok=True)

    if os_name == "windows":
        return install_openscad_windows(target_version, nightly)
    return install_openscad_linux(target_version, nightly)


def install_openscad_windows(version, nightly):
    """Install OpenSCAD on Windows.

    Args:
        version: Version string to install.
        nightly: Whether it is a nightly build.

    Returns:
        True if successful, False otherwise.
    """
    if nightly:
        url = f"https://files.openscad.org/snapshots/OpenSCAD-{version}-x86-64.zip"
    else:
        url = f"https://files.openscad.org/OpenSCAD-{version}-x86-64.zip"

    zip_path = INSTALL_DIR / f"openscad-{version}.zip"
    if not download_file(url, zip_path):
        return False

    log_info("Extracting...")
    try:
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            # Extract to a temp dir first to handle the top-level folder
            temp_extract = INSTALL_DIR / "temp_extract"
            zip_ref.extractall(temp_extract)

            # Find the top level folder
            content = list(temp_extract.iterdir())
            if len(content) == 1 and content[0].is_dir():
                source_dir = content[0]
            else:
                source_dir = temp_extract  # No top level folder?

            # Move contents to INSTALL_DIR
            for item in source_dir.iterdir():
                shutil.move(str(item), str(INSTALL_DIR))

            # Cleanup
            shutil.rmtree(temp_extract)

        zip_path.unlink()
        log_success(f"OpenSCAD {version} installed successfully!")
        return True
    except Exception as e:  # pylint: disable=broad-exception-caught
        log_error(f"Extraction failed: {e}")
        return False


def install_openscad_linux(version, nightly):
    """Install OpenSCAD on Linux.

    Args:
        version: Version string to install.
        nightly: Whether it is a nightly build.

    Returns:
        True if successful, False otherwise.
    """
    if nightly:
        url = f"https://files.openscad.org/snapshots/OpenSCAD-{version}-x86_64.AppImage"
    else:
        url = f"https://files.openscad.org/OpenSCAD-{version}-x86_64.AppImage"

    appimage_path = INSTALL_DIR / "OpenSCAD.AppImage"
    if not download_file(url, appimage_path):
        return False

    # Make executable
    st_mode = os.stat(appimage_path).st_mode
    os.chmod(appimage_path, st_mode | stat.S_IEXEC)

    # Create symlink 'openscad' -> 'OpenSCAD.AppImage'
    symlink_path = INSTALL_DIR / "openscad"
    if symlink_path.exists():
        symlink_path.unlink()

    try:
        os.symlink("OpenSCAD.AppImage", symlink_path)
    except OSError:
        # Fallback if symlinks not supported (rare on Linux)
        pass

    log_success(f"OpenSCAD {version} installed successfully!")
    return True


# --- Library Installation ---


def get_installed_lib_version(lib_path, name):
    """Get installed library version.

    Args:
        lib_path: Path to the library directory.
        name: Name of the library.

    Returns:
        Version string if found, None otherwise.
    """
    version_file = lib_path / ".version"
    if version_file.exists():
        return version_file.read_text(encoding="utf-8").strip()

    legacy_file = lib_path / f".{name.lower()}-version"
    if legacy_file.exists():
        return legacy_file.read_text(encoding="utf-8").strip()

    return None


def install_library(dep, force=False):
    """Install a single library.

    Args:
        dep: Dependency dictionary.
        force: Force reinstall.

    Returns:
        True if successful, False otherwise.
    """
    name = dep["name"]
    repo = dep["repository"]
    version = dep["version"]
    source = dep.get("source", "github")

    lib_path = LIBRARIES_DIR / name
    current_version = get_installed_lib_version(lib_path, name)

    if current_version == version and not force:
        log_success(f"{name}: Up to date ({version})")
        return True

    if current_version:
        log_info(f"Updating {name} from {current_version} to {version}...")
    else:
        log_info(f"Installing {name} {version}...")

    if source == "github":
        url = f"https://github.com/{repo}/archive/{version}.tar.gz"
    else:
        log_error(f"Unknown source type: {source}")
        return False

    temp_file = SCRIPT_DIR / f"{name}-{version}.tar.gz"
    try:
        log_info(f"Downloading {url}...")
        urllib.request.urlretrieve(url, temp_file)

        if lib_path.exists():
            shutil.rmtree(lib_path)
        lib_path.mkdir(parents=True, exist_ok=True)

        log_info("Extracting...")
        with tarfile.open(temp_file, "r:gz") as tar:
            members = []
            for member in tar.getmembers():
                p = Path(member.name)
                if len(p.parts) > 1:
                    member.name = str(Path(*p.parts[1:]))
                    members.append(member)
                elif len(p.parts) == 1:
                    # Include root-level files as-is
                    members.append(member)
            tar.extractall(path=lib_path, members=members, filter="data")

        temp_file.unlink()
        (lib_path / ".version").write_text(version, encoding="utf-8")
        log_success(f"{name} installed successfully!")
        return True

    except Exception as e:  # pylint: disable=broad-exception-caught
        log_error(f"Failed to install {name}: {e}")
        if temp_file.exists():
            temp_file.unlink()
        return False


def install_libraries(force=False, check_only=False):
    """Install all libraries.

    Args:
        force: Force reinstall.
        check_only: Only check status.

    Returns:
        True if all libraries processed successfully, False otherwise.
    """
    if not DEPENDENCIES_FILE.exists():
        log_error(f"Dependencies file not found: {DEPENDENCIES_FILE}")
        return False

    try:
        with open(DEPENDENCIES_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
    except json.JSONDecodeError as e:
        log_error(f"Invalid JSON in dependencies file: {e}")
        return False

    dependencies = data.get("dependencies", [])
    success = True

    # Validate required fields in each dependency
    required_fields = ["name", "repository", "version"]
    for dep in dependencies:
        missing = [f for f in required_fields if f not in dep]
        if missing:
            log_error(f"Dependency missing required fields: {missing}")
            return False

    for dep in dependencies:
        if check_only:
            current = get_installed_lib_version(LIBRARIES_DIR / dep["name"], dep["name"])
            if current != dep["version"]:
                log_warning(f"{dep['name']}: Update available ({current or 'not installed'} -> {dep['version']})")
                success = False
            else:
                log_success(f"{dep['name']}: Up to date")
        else:
            if not install_library(dep, force=force):
                success = False

    return success


# --- Main ---


def main():
    """Main entry point.

    Parses command-line arguments and executes OpenSCAD and/or library installation.

    Returns:
        Exits with code 0 on success, 1 on failure.
    """
    parser = argparse.ArgumentParser(description="HomeRacker Setup (OpenSCAD + Libraries)")
    parser.add_argument("--check", action="store_true", help="Check installation status only")
    parser.add_argument("--force", action="store_true", help="Force reinstall")
    parser.add_argument("--nightly", action="store_true", default=True, help="Install nightly build (default)")
    parser.add_argument("--stable", action="store_false", dest="nightly", help="Install stable release")
    parser.add_argument("--openscad-only", action="store_true", help="Install only OpenSCAD binary")
    parser.add_argument("--libs-only", action="store_true", help="Install only libraries")

    args = parser.parse_args()

    success = True

    # 1. OpenSCAD
    if not args.libs_only:
        if not install_openscad(nightly=args.nightly, force=args.force, check_only=args.check):
            success = False
            if not args.check:
                log_error("OpenSCAD installation failed. Aborting.")
                sys.exit(1)

    # 2. Libraries
    if not args.openscad_only:
        # Ensure LIBRARIES_DIR exists (it might have been wiped if we reinstalled OpenSCAD)
        LIBRARIES_DIR.mkdir(parents=True, exist_ok=True)

        if not install_libraries(force=args.force, check_only=args.check):
            success = False

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
