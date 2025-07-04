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

# Common install function for apt and apk
install_packages() {
local pkgs=("$@")
if [ "$PKG_MGR" = "apt" ]; then
echo "[*] Updating apt repositories..."
sudo apt update -y
echo "[*] Upgrading installed packages..."
sudo apt upgrade -y
echo "[*] Installing packages: ${pkgs[*]}"
sudo apt install -y "${pkgs[@]}"
else
echo "[*] Updating apk repositories..."
sudo apk update
echo "[*] Upgrading installed packages..."
sudo apk upgrade
echo "[*] Installing packages: ${pkgs[*]}"
sudo apk add --no-cache "${pkgs[@]}"
fi
}

# Essential packages for both systems
COMMON_PKGS=(
build-essential # Debian only, will be ignored in apk
build-base # Alpine equivalent (apk)
curl
wget
git
nano
vim
python3
python3-pip
python3-venv
nodejs
npm
bash-completion
tmux
htop
screen
unzip
zip
man-db
fish
net-tools
iputils-ping
tcpdump
jq
)

# Separate pkg arrays for apt and apk to handle differences
if [ "$PKG_MGR" = "apt" ]; then
# Debian/Ubuntu package names
PKGS=(
build-essential curl wget git nano vim python3 python3-pip python3-venv
nodejs npm bash-completion tmux htop screen unzip zip man-db fish net-tools
iputils-ping tcpdump jq
)
elif [ "$PKG_MGR" = "apk" ]; then
# Alpine package names
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

# Ask user for git config details if not set
read -rp "Enter your Git user.name: " git_name
read -rp "Enter your Git user.email: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global core.editor "vim"
git config --global pull.rebase false

echo "[✓] TuxShell environment setup complete!"
echo "You can now use editors (vim, nano), Python3, Node.js, Bash, Git, and more."

echo "Tip: Add '$HOME/bin' and your repo's 'bin' directory to your PATH in your shell profile."
