#!/bin/bash

set -e
set -u

echo "[+] Running iOS-Tuxshell Helper Installer..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
PKG_MANAGER="apt"
elif command -v apk >/dev/null 2>&1; then
PKG_MANAGER="apk"
else
echo "[!] Unsupported package manager. Only apt and apk supported."
exit 1
fi

# Update repos
echo "[+] Updating package lists..."
if [ "$PKG_MANAGER" = "apt" ]; then
apt update -y
elif [ "$PKG_MANAGER" = "apk" ]; then
apk update
fi

# Install some helper utilities common to the project
echo "[+] Installing helper utilities..."
if [ "$PKG_MANAGER" = "apt" ]; then
apt install -y curl wget git jq
elif [ "$PKG_MANAGER" = "apk" ]; then
apk add --no-cache curl wget git jq
fi

# Setup environment variables or config files if needed
echo "[+] Setting up environment configuration..."
# Example: export some env var or create config directory
mkdir -p ~/ios-tuxshell-config
echo "export TUXSHELL_CONFIG_DIR=~/ios-tuxshell-config" >> ~/.bashrc

echo "[✓] Helper installer completed."


