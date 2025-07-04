#!/bin/bash

set -e
set -u

echo "[+] Installing development/build tools..."

# Detect package manager and install build tools accordingly
if command -v apt >/dev/null 2>&1; then
# Debian/Ubuntu/iSH with apt
apt update -y
apt install -y gcc g++ make cmake gdb
elif command -v apk >/dev/null 2>&1; then
# Alpine/iSH with apk
apk update
apk add gcc g++ make cmake gdb
else
echo "[!] No supported package manager found (apt or apk). Cannot install build tools."
exit 1
fi

echo "[✓] Build tools installed."
