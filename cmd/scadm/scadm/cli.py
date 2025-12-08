"""CLI interface for scadm."""

import argparse
import logging
import sys

from scadm.installer import install_libraries, install_openscad
from scadm.vscode import setup_openscad_extension, setup_python_extension

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s", handlers=[logging.StreamHandler()])
logger = logging.getLogger(__name__)


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        prog="scadm",
        description="OpenSCAD Dependency Manager - Install OpenSCAD and manage library dependencies",
    )

    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Install command
    install_parser = subparsers.add_parser("install", help="Install OpenSCAD and libraries")
    install_parser.add_argument("--check", action="store_true", help="Check installation status only")
    install_parser.add_argument("--force", action="store_true", help="Force reinstall")
    install_parser.add_argument(
        "--stable",
        action="store_false",
        dest="nightly",
        default=True,
        help="Install stable release (2021.01) instead of nightly",
    )
    install_parser.add_argument("--openscad-only", action="store_true", help="Install only OpenSCAD binary")
    install_parser.add_argument("--libs-only", action="store_true", help="Install only libraries")

    # VSCode command
    vscode_parser = subparsers.add_parser("vscode", help="Configure VS Code extensions")
    vscode_parser.add_argument("--openscad", action="store_true", help="Install and configure OpenSCAD extension")
    vscode_parser.add_argument("--python", action="store_true", help="Install and configure Python extension")

    args = parser.parse_args()

    # Show help if no command provided
    if not args.command:
        parser.print_help()
        sys.exit(0)

    # Handle vscode command
    if args.command == "vscode":
        if args.openscad:
            success = setup_openscad_extension()
            sys.exit(0 if success else 1)
        elif args.python:
            success = setup_python_extension()
            sys.exit(0 if success else 1)
        else:
            vscode_parser.print_help()
            sys.exit(0)

    # Handle install command
    if args.command == "install":
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
