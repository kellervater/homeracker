#!/usr/bin/env python3
"""
HomeRacker Dependency Installer

Installs OpenSCAD libraries defined in dependencies.json.
"""

import argparse
import json
import shutil
import sys
import tarfile
import urllib.request
import urllib.error
from pathlib import Path

# Constants
SCRIPT_DIR = Path(__file__).parent.resolve()
WORKSPACE_ROOT = SCRIPT_DIR.parent.parent
DEPENDENCIES_FILE = SCRIPT_DIR / "dependencies.json"
LIBRARIES_DIR = WORKSPACE_ROOT / "bin" / "openscad" / "libraries"


# Colors
class Colors:  # pylint: disable=too-few-public-methods
    """ANSI Color codes"""

    HEADER = "\033[95m"
    BLUE = "\033[94m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    ENDC = "\033[0m"


def log_info(msg):
    """Log info message"""
    print(f"{Colors.BLUE}ℹ{Colors.ENDC} {msg}")


def log_success(msg):
    """Log success message"""
    print(f"{Colors.GREEN}✓{Colors.ENDC} {msg}")


def log_warning(msg):
    """Log warning message"""
    print(f"{Colors.YELLOW}⚠{Colors.ENDC} {msg}")


def log_error(msg):
    """Log error message"""
    print(f"{Colors.RED}✗{Colors.ENDC} {msg}")


def load_dependencies():
    """Load dependencies from JSON file"""
    if not DEPENDENCIES_FILE.exists():
        log_error(f"Dependencies file not found: {DEPENDENCIES_FILE}")
        sys.exit(1)

    with open(DEPENDENCIES_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def get_installed_version(lib_path, name):
    """Get currently installed version"""
    # Check for new generic version file
    version_file = lib_path / ".version"
    if version_file.exists():
        return version_file.read_text(encoding="utf-8").strip()

    # Check for legacy version file (e.g., .bosl2-version)
    legacy_file = lib_path / f".{name.lower()}-version"
    if legacy_file.exists():
        return legacy_file.read_text(encoding="utf-8").strip()

    return None


def install_dependency(dep, force=False):
    """Install a single dependency"""
    name = dep["name"]
    repo = dep["repository"]
    version = dep["version"]
    source = dep.get("source", "github")

    lib_path = LIBRARIES_DIR / name

    # Check existing installation
    current_version = get_installed_version(lib_path, name)

    if current_version == version and not force:
        log_success(f"{name} is up to date ({version})")
        return True

    if current_version:
        log_info(f"Updating {name} from {current_version} to {version}...")
    else:
        log_info(f"Installing {name} {version}...")

    # Prepare download URL
    if source == "github":
        url = f"https://github.com/{repo}/archive/{version}.tar.gz"
    else:
        log_error(f"Unknown source type: {source}")
        return False

    # Download and extract
    temp_file = SCRIPT_DIR / f"{name}-{version}.tar.gz"
    try:
        log_info(f"Downloading {url}...")
        urllib.request.urlretrieve(url, temp_file)

        # Remove old installation
        if lib_path.exists():
            shutil.rmtree(lib_path)
        lib_path.mkdir(parents=True, exist_ok=True)

        log_info("Extracting...")
        with tarfile.open(temp_file, "r:gz") as tar:
            # Get the top level directory name in the tarball
            # GitHub archives usually have a top level dir like "Repo-Ref"
            # We want to strip that.

            # Python's tarfile extraction with stripping components is manual
            members = []
            for member in tar.getmembers():
                # Remove the first component of the path
                p = Path(member.name)
                if len(p.parts) > 1:
                    member.name = str(Path(*p.parts[1:]))
                    members.append(member)

            tar.extractall(path=lib_path, members=members, filter="data")

        # Cleanup
        temp_file.unlink()

        # Save version
        (lib_path / ".version").write_text(version, encoding="utf-8")

        log_success(f"{name} installed successfully!")
        return True

    except (urllib.error.URLError, tarfile.TarError, OSError) as e:
        log_error(f"Failed to install {name}: {e}")
        if temp_file.exists():
            temp_file.unlink()
        return False


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description="HomeRacker Dependency Installer")
    parser.add_argument("--check", action="store_true", help="Check installation status only")
    parser.add_argument("--force", action="store_true", help="Force reinstall")
    args = parser.parse_args()

    if not LIBRARIES_DIR.exists():
        log_error(f"OpenSCAD libraries directory not found: {LIBRARIES_DIR}")
        log_error("Please run install-openscad.sh first.")
        sys.exit(1)

    data = load_dependencies()
    dependencies = data.get("dependencies", [])

    success = True
    for dep in dependencies:
        if args.check:
            current = get_installed_version(LIBRARIES_DIR / dep["name"], dep["name"])
            if current != dep["version"]:
                log_warning(f"{dep['name']}: Update available ({current or 'not installed'} -> {dep['version']})")
                success = False
            else:
                log_success(f"{dep['name']}: Up to date")
        else:
            if not install_dependency(dep, force=args.force):
                success = False

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
