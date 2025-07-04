#!/bin/bash

set -e
set -u

echo "[+] Installing networking tools..."

if command -v apt >/dev/null 2>&1; then
apt install -y net-tools iputils-ping dnsutils traceroute
elif command -v apk >/dev/null 2>&1; then
apk add --no-cache net-tools iputils bind-tools traceroute
else
echo "[!] Unsupported package manager."
exit 1
fi

echo "[+] Networking tools installation complete."
