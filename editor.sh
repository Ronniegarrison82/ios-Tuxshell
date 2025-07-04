#!/bin/bash

set -e
set -u

echo "[+] Installing text editors..."

if command -v apt >/dev/null 2>&1; then
apt install -y nano vim
elif command -v apk >/dev/null 2>&1; then
apk add --no-cache nano vim
else
echo "[!] No supported package manager found."
exit 1
fi

echo "[✓] Text editors installed.
