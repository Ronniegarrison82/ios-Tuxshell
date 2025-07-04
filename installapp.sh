#!/bin/bash

# install_app.sh - Sets up core CLI tools and dev environment for iOS-Tuxshell

set -e
set -u

echo "[+] Updating package manager..."

if command -v apt >/dev/null 2>&1; then
echo "[*] Using apt..."
apt update -y
apt upgrade -y
echo "[+] Installing base packages..."
apt install -y \
build-essential curl wget git vim nano fish htop net-tools \
iputils-ping tcpdump python3 python3-pip python3-venv lsof \
software-properties-common screen tmux bash-completion man-db \
openssh-client unzip zip jq gcc g++ make automake autoconf pkg-config

elif command -v apk >/dev/null 2>&1; then
echo "[*] Using apk..."
apk update
apk add --no-cache \
build-base curl wget git vim nano fish htop net-tools \
iputils tcpdump python3 py3-pip py3-virtualenv lsof \
bash-completion openssh unzip zip jq gcc g++ make automake autoconf pkgconf man

else
echo "[!] No supported package manager found (apt/apk)."
exit 1
fi

echo "[+] Upgrading Python packages..."
pip3 install --upgrade pip setuptools wheel

echo "[✓] Core environment setup complete."
