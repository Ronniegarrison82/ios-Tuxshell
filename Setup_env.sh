#!/bin/bash
# setup_env.sh - Complete dev environment installer for iSH/Linux (Debian/Alpine)
# Compatible with apt and apk package managers
# Sets up editors, Python, Node.js, Git, and essential CLI tools

set -euo pipefail

echo "[*] Starting TuxShell full environment setup..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
PKG_MGR="apt"
elif command -v apk >/dev/null 2>&1; then
PKG_MGR="apk"
else
echo "[!] Unsupported package manager. Only apt and apk supported."
exit 1
fi

echo "[*] Detected package manager: $PKG_MGR"

# Detect if sudo is available (skip if not)
SUDO=""
if command -v sudo >/dev/null 2>&1; then
SUDO="sudo"
fi

install_packages() {
local pkgs=("$@")
if [ "$PKG_MGR" = "apt" ]; then
echo "[*] Updating apt repositories..."
$SUDO apt update -y
echo "[*] Upgrading installed packages..."
$SUDO apt upgrade -y
echo "[*] Installing packages: ${pkgs[*]}"
$SUDO apt install -y "${pkgs[@]}"
else
echo "[*] Updating apk repositories..."
$SUDO apk update
echo "[*] Upgrading installed packages..."
$SUDO apk upgrade
echo "[*] Installing packages: ${pkgs[*]}"
$SUDO apk add --no-cache "${pkgs[@]}"
fi
}

# Define packages per package manager (do NOT mix build-essential/build-base)
if [ "$PKG_MGR" = "apt" ]; then
PKGS=(
build-essential curl wget git nano vim python3 python3-pip python3-venv
nodejs npm bash-completion tmux htop screen unzip zip man-db fish net-tools
iputils-ping tcpdump jq
)
elif [ "$PKG_MGR" = "apk" ]; then
PKGS=(
build-base curl wget git nano vim python3 py3-pip py3-virtualenv
nodejs npm bash-completion tmux htop screen unzip zip man fish net-tools
iputils tcpdump jq
)
fi

install_packages "${PKGS[@]}"

echo "[*] Upgrading Python tooling..."
pip3 install --upgrade pip setuptools wheel

echo "[*] Upgrading npm and installing useful global npm packages..."
npm install -g npm
npm install -g nodemon eslint

echo "[*] Configuring Git global settings..."

read -rp "Enter your Git user.name: " git_name
read -rp "Enter your Git user.email: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global core.editor "vim"
git config --global pull.rebase false

echo "[✓] TuxShell environment setup complete!"
echo "You can now use editors (vim, nano), Python3, Node.js, Bash, Git, and more."

# Update PATH in .bashrc if not already present
PROFILE="$HOME/.bashrc"
if ! grep -q 'ios-Tuxshell/bin' "$PROFILE"; then
echo "[*] Adding PATH update to $PROFILE..."
{
echo ''
echo '# Added by TuxShell setup_env.sh'
echo 'export PATH="$HOME/bin:$PATH"'
echo 'export PATH="$HOME/ios-Tuxshell/bin:$PATH"'
} >> "$PROFILE"
echo "Please restart your shell or run 'source $PROFILE' to update PATH."
else
echo "[*] PATH already configured in $PROFILE."
fi
