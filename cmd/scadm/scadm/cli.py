"""CLI interface for scadm."""

import argparse
import logging
import sys

from scadm.installer import install_libraries, install_openscad

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s", handlers=[logging.StreamHandler()])
logger = logging.getLogger(__name__)


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        prog="scadm",
        description="OpenSCAD Dependency Manager - Install OpenSCAD and manage library dependencies",
    )
    parser.add_argument("--check", action="store_true", help="Check installation status only")
    parser.add_argument("--force", action="store_true", help="Force reinstall")
    parser.add_argument(
        "--stable", action="store_false", dest="nightly", help="Install stable release (2021.01) instead of nightly"
    )
    parser.add_argument("--openscad-only", action="store_true", help="Install only OpenSCAD binary")
    parser.add_argument("--libs-only", action="store_true", help="Install only libraries")

    args = parser.parse_args()

    # Set default to nightly (True) unless --stable was specified
    if not hasattr(args, "nightly"):
        args.nightly = True

    success = True

    try:
        if not args.libs_only:
            if not install_openscad(nightly=args.nightly, force=args.force, check_only=args.check):
                success = False
                if not args.check:
                    logger.error("OpenSCAD installation failed. Aborting.")
                    sys.exit(1)

        if not args.openscad_only:
            if not install_libraries(force=args.force, check_only=args.check):
                success = False
    except FileNotFoundError as e:
        logger.error("%s", e)
        logger.error("Create a scadm.json file in your project root to get started.")
        sys.exit(1)

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
