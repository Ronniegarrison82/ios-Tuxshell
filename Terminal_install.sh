#!/bin/bash
# setup.sh - iOS-TuxShell bootstrap script
# Usage: Run from inside the repo folder (iSH or jailbroken terminal)
# License: GPL v3.0

set -e
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_HOME="$REPO_ROOT/home/user"
BIN_DIR="$REPO_ROOT/bin"
LOG_DIR="$USER_HOME/Documents/console-logs"

echo "[+] TuxShell: Portable Linux Terminal Environment for iOS"
echo "[+] Detected repo root at: $REPO_ROOT"

# Optional package manager detection (iSH has apk, jailbreak has apt)
detect_pkg_mgr() {
if command -v apt >/dev/null 2>&1; then echo "apt"
elif command -v apk >/dev/null 2>&1; then echo "apk"
else echo "none"
fi
}

PKG_MGR=$(detect_pkg_mgr)
echo "[+] Package manager detected: $PKG_MGR"

echo "[+] Updating package lists..."
case $PKG_MGR in
apt)
sudo apt update -y && sudo apt upgrade -y
;;
apk)
sudo apk update && sudo apk upgrade
;;
*)
echo "[!] No supported package manager found. Skipping system package install."
;;
esac

echo "[+] Installing core Linux development tools..."
case $PKG_MGR in
apt)
sudo apt install -y \
build-essential coreutils \
bash bash-completion \
sudo locales \
file lsof tree \
make cmake gcc g++ \
nano vim neovim \
python3 python3-pip python3-venv python3-dev \
nodejs npm ruby-full php-cli \
curl wget git unzip zip \
openssh-client openssh-server \
screen tmux jq sed awk grep \
man less more dos2unix tar gzip bzip2 xz-utils \
rsync dfu-util dialog expect \
net-tools iftop iputils-ping traceroute dnsutils cron
;;
apk)
sudo apk add \
bash coreutils build-base \
python3 py3-pip py3-virtualenv \
nodejs npm ruby php-cli \
curl wget git unzip zip \
openssh screen tmux jq sed grep \
nano vim less rsync tar gzip xz \
busybox-extras
;;
esac

echo "[+] Setting up environment directories..."
mkdir -p "$USER_HOME/bin" "$USER_HOME/projects" "$USER_HOME/scripts" "$LOG_DIR"

echo "[+] Configuring locales..."
if [[ "$PKG_MGR" == "apt" ]]; then
sudo locale-gen en_US.UTF-8
fi

echo "[+] Upgrading pip and npm..."
pip3 install --upgrade pip setuptools wheel
npm install -g npm

echo "[+] Verifying toolchain versions..."
{
echo "Python3: $(python3 --version 2>&1)"
echo "Node.js: $(node -v 2>&1)"
echo "Ruby: $(ruby --version 2>&1)"
echo "PHP: $(php -v 2>&1 | head -n 1)"
echo "GCC: $(gcc --version 2>&1 | head -n 1)"
echo "Git: $(git --version 2>&1)"
} | tee "$LOG_DIR/setup-versions.log"

echo "[+] Enabling cron service (if available)..."
if command -v systemctl >/dev/null 2>&1; then
sudo systemctl enable cron || true
elif command -v service >/dev/null 2>&1; then
sudo service cron enable || true
fi

echo "[+] TuxShell terminal setup complete. Ready for portable development!"
