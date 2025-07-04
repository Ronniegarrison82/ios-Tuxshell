#!/bin/bash

# install_editors.sh - Installs nano and vim for iOS-Tuxshell

set -e
set -u

echo "[+] Installing text editors (nano, vim)..."

if command -v apt >/dev/null 2>&1; then
echo "[*] Using apt (Debian/Ubuntu/iSH)..."
apt update -y
apt install -y nano vim
elif command -v apk >/dev/null 2>&1; then
echo "[*] Using apk (Alpine/iSH)..."
apk update
apk add --no-cache nano vim
else
echo "[!] No supported package manager found (apt/apk)."
exit 1
fi

echo "[✓] Text editors successfully installed."
