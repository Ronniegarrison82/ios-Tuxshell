#!/bin/bash
# install_all.sh - Combined installer for iOS-TuxShell environment
# Designed for iSH Alpine Linux and Debian/Ubuntu compatibility

set -euo pipefail

SUDO=""
if command -v sudo >/dev/null 2>&1; then
SUDO="sudo"
fi

# Retry helper: try a command up to 3 times with 2s delay
retry() {
local n=1
local max=3
local delay=2
until "$@"; do
if (( n == max )); then
echo "[!] Command failed after $n attempts."
return 1
else
echo "[!] Command failed. Attempt $n/$max. Retrying in $delay seconds..."
sleep $delay
((n++))
fi
done
}

echo "[+] Starting full environment installation..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
PKG_MANAGER="apt"
elif command -v apk >/dev/null 2>&1; then
PKG_MANAGER="apk"
else
echo "[!] Unsupported or missing package manager (apt or apk). Exiting."
exit 1
fi

# Update repos
echo "[+] Updating package lists..."
if [ "$PKG_MANAGER" = "apt" ]; then
retry $SUDO apt update -y
elif [ "$PKG_MANAGER" = "apk" ]; then
retry $SUDO apk update
fi

# 1. Core CLI tools & dev environment
echo "[+] Installing core CLI tools and dev environment..."
if [ "$PKG_MANAGER" = "apt" ]; then
$SUDO apt upgrade -y || true
$SUDO apt install -y \
build-essential curl wget git vim nano fish htop net-tools \
iputils-ping tcpdump python3 python3-pip python3-venv lsof \
software-properties-common screen tmux bash-completion man-db \
openssh-client unzip zip jq gcc g++ make automake autoconf pkg-config
elif [ "$PKG_MANAGER" = "apk" ]; then
retry $SUDO apk update
$SUDO apk add --no-cache \
build-base curl wget git vim nano fish htop net-tools \
iputils tcpdump python3 py3-pip py3-virtualenv lsof \
bash-completion openssh unzip zip jq gcc g++ make automake autoconf pkgconf man
fi

# 2. Helper utilities
echo "[+] Installing helper utilities..."
if [ "$PKG_MANAGER" = "apt" ]; then
$SUDO apt install -y curl wget git jq
elif [ "$PKG_MANAGER" = "apk" ]; then
$SUDO apk add --no-cache curl wget git jq
fi

# 3. Networking tools
echo "[+] Installing networking tools..."
if [ "$PKG_MANAGER" = "apt" ]; then
$SUDO apt install -y net-tools iputils-ping dnsutils traceroute curl wget || true
elif [ "$PKG_MANAGER" = "apk" ]; then
$SUDO apk add --no-cache net-tools iputils bind-tools traceroute curl wget || true
fi

# 4. Text editors
echo "[+] Installing text editors (nano, vim)..."
if [ "$PKG_MANAGER" = "apt" ]; then
$SUDO apt install -y nano vim || true
elif [ "$PKG_MANAGER" = "apk" ]; then
$SUDO apk add --no-cache nano vim || true
fi

# 5. Extra useful tools
echo "[+] Installing extra tools (networking, dev, convenience)..."
if [ "$PKG_MANAGER" = "apt" ]; then
$SUDO apt install -y \
curl wget iproute2 netcat procps zsh micro jq python3-dev python3-pip \
gcc g++ make cmake htop tree bind9-host iputils-ping openssh-client bash-completion tmux screen || true
elif [ "$PKG_MANAGER" = "apk" ]; then
$SUDO apk add --no-cache \
curl wget iproute2 netcat procps zsh micro jq python3-dev py3-pip \
gcc g++ make cmake htop tree bind-tools iputils openssh bash-completion tmux screen || true
fi

# 6. Upgrade Python packaging tools
echo "[+] Upgrading Python packaging tools (pip, setuptools, wheel)..."
PIP_CMD=""
if command -v pip3 >/dev/null 2>&1; then
PIP_CMD="pip3"
elif command -v python3 >/dev/null 2>&1; then
PIP_CMD="python3 -m pip"
fi

if [ -n "$PIP_CMD" ]; then
retry $PIP_CMD install --upgrade pip setuptools wheel
else
echo "[!] pip3 or python3 not found. Skipping Python package upgrades."
fi

echo "[✓] Full environment installation complete."
