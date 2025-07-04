#!/bin/bash

# install_app.sh - Sets up core CLI tools and dev environment for iOS-Tuxshell

set -euo pipefail

echo "[+] Starting core environment setup..."

if command -v apt >/dev/null 2>&1; then
echo "[*] Using apt package manager..."
apt update -y
apt upgrade -y
echo "[+] Installing base packages..."
apt install -y \
build-essential curl wget git vim nano fish htop net-tools \
iputils-ping tcpdump python3 python3-pip python3-venv lsof \
software-properties-common screen tmux bash-completion man-db \
openssh-client unzip zip jq gcc g++ make automake autoconf pkg-config
elif command -v apk >/dev/null 2>&1; then
echo "[*] Using apk package manager..."
apk update
apk add --no-cache \
build-base curl wget git vim nano fish htop net-tools \
iputils tcpdump python3 py3-pip py3-virtualenv lsof \
bash-completion openssh unzip zip jq gcc g++ make automake autoconf pkgconf man
else
echo "[!] No supported package manager found (apt or apk). Exiting."
exit 1
fi

echo "[+] Upgrading Python packaging tools (pip, setuptools, wheel)..."
# Retry pip upgrade up to 3 times in case of transient network errors
for i in {1..3}; do
if pip3 install --upgrade pip setuptools wheel; then
break
else
echo "[!] pip upgrade attempt $i failed. Retrying..."
sleep 2
fi
done

echo "[✓] Core environment setup complete."

echo "[+] Verifying installed tools versions..."
echo -n "Git version: " && git --version
echo -n "Python3 version: " && python3 --version
echo -n "pip3 version: " && pip3 --version
echo -n "gcc version: " && gcc --version | head -n 1
echo -n "make version: " && make --version | head -n 1
echo "[+] Verification complete."
