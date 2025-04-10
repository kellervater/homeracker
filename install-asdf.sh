#!/bin/bash

set -euo pipefail

# renovate: datasource=github-releases depName=asdf-vm/asdf versioning=semver
ASDF_VERSION=v0.16.6

add_line_to_file_if_not_exists() {
  local file="$1"
  local line="$2"

  if ! grep -Fxq "$line" "$file"; then
    echo "Adding line to $file..."
    echo "$line" >> "$file"
  fi
}

# Download and extract the archive
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac
ARCHIVE_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-${OS}-${ARCH}.tar.gz"
INSTALL_DIR="$HOME/.asdf"

echo "🗑️  Removing existing asdf installation..."
if [ -d "$INSTALL_DIR" ]; then
  rm -rf "$INSTALL_DIR"
fi

echo "⬇️  Downloading asdf version ${ASDF_VERSION}..."
curl -sSL "$ARCHIVE_URL" -o /tmp/asdf.tar.gz

echo "📦 Extracting asdf..."
mkdir -p "$INSTALL_DIR"
tar -xzf /tmp/asdf.tar.gz -C "$INSTALL_DIR"

# Clean up
echo "🧹 Cleaning up..."
rm /tmp/asdf.tar.gz

add_line_to_file_if_not_exists "$HOME/.bashrc" 'export PATH="$HOME/.asdf:$PATH"'
add_line_to_file_if_not_exists "$HOME/.bash_profile" 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"'
add_line_to_file_if_not_exists "$HOME/.bashrc" '. <(asdf completion bash)'


export PATH="$HOME/.asdf:$PATH"
asdf -v

echo "✅ asdf version ${ASDF_VERSION} installed successfully. To enable code completion, please restart your terminal or run 'source ~/.bashrc'."
