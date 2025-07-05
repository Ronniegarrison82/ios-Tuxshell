#!/bin/bash
# install_net_tool.sh — Installs networking utilities for iOS-TuxShell

set -euo pipefail

echo "[+] Installing networking tools..."

# Check if sudo exists
SUDO=""
if command -v sudo >/dev/null 2>&1; then
SUDO="sudo"
fi

if command -v apt >/dev/null 2>&1; then
echo "[*] Detected apt (Debian/Ubuntu)..."
$SUDO apt update -y
$SUDO apt install -y \
net-tools \
iputils-ping \
dnsutils \
traceroute \
curl \
wget

elif command -v apk >/dev/null 2>&1; then
echo "[*] Detected apk (Alpine/iSH)..."
$SUDO apk update
$SUDO apk add --no-cache \
net-tools \
iputils \
bind-tools \
traceroute \
curl \
wget

else
echo "[!] Unsupported or missing package manager (apt/apk)."
exit 1
fi

echo "[✓] Networking tools installation complete."
