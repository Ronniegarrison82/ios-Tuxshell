#!/bin/bash

set -euo pipefail

echo "[+] Installing development/build tools..."

# Check if running as root or use sudo
if [ "$EUID" -ne 0 ]; then
SUDO='sudo'
else
SUDO=''
fi

# Detect package manager and install build tools
if command -v apt >/dev/null 2>&1; then
echo "[*] Detected apt package manager"
$SUDO apt update -y
$SUDO apt install -y gcc g++ make cmake gdb
elif command -v apk >/dev/null 2>&1; then
echo "[*] Detected apk package manager"
$SUDO apk update
$SUDO apk add gcc g++ make cmake gdb
else
echo "[!] No supported package manager found (apt or apk). Cannot install build tools."
exit 1
fi

echo "[✓] Build tools installed."
