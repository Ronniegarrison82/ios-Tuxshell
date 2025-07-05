#!/bin/bash
# master_tuxshell_setup.sh - Full iOS-TuxShell environment installer and monitor
# Compatible with iSH (apk) and Debian/Ubuntu (apt)
# License: GPL v3.0

set -euo pipefail

echo "[+] Starting TuxShell Master Setup..."

### --- Common Utilities --- ###
SUDO=""
if command -v sudo >/dev/null 2>&1; then
SUDO="sudo"
fi

detect_pkg_mgr() {
if command -v apt >/dev/null 2>&1; then echo "apt"
elif command -v apk >/dev/null 2>&1; then echo "apk"
else echo "none"
fi
}

PKG_MGR=$(detect_pkg_mgr)
if [ "$PKG_MGR" = "none" ]; then
echo "[!] Unsupported package manager. Exiting."
exit 1
fi

echo "[+] Detected package manager: $PKG_MGR"

### --- Retry Helper --- ###
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

### --- Install Packages --- ###
echo "[+] Updating package lists..."
case $PKG_MGR in
apt)
$SUDO apt update -y && $SUDO apt upgrade -y
;;
apk)
$SUDO apk update && $SUDO apk upgrade
;;
esac

echo "[+] Installing core development tools..."
if [ "$PKG_MGR" = "apt" ]; then
$SUDO apt install -y build-essential curl wget git vim nano fish htop net-tools \
iputils-ping tcpdump python3 python3-pip python3-venv lsof \
software-properties-common screen tmux bash-completion man-db \
openssh-client unzip zip jq gcc g++ make automake autoconf pkg-config \
file tree nodejs npm ruby-full php-cli sudo locales expect
elif [ "$PKG_MGR" = "apk" ]; then
$SUDO apk add --no-cache build-base curl wget git vim nano fish htop net-tools \
iputils tcpdump python3 py3-pip py3-virtualenv lsof \
bash-completion openssh unzip zip jq gcc g++ make automake autoconf pkgconf man \
nodejs npm ruby php-cli expect
fi

echo "[+] Upgrading Python and npm tools..."
pip3 install --upgrade pip setuptools wheel
npm install -g npm

### --- Directory Setup --- ###
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$REPO_ROOT/home/user"
LOG_DIR="$USER_HOME/Documents/console-logs"
mkdir -p "$USER_HOME/bin" "$USER_HOME/projects" "$USER_HOME/scripts" "$LOG_DIR"

### --- Profile Setup --- ###
echo "[+] Setting up profile..."
PROFILE_FILE="$HOME/.bashrc"
if ! grep -q 'ios-Tuxshell/bin' "$PROFILE_FILE"; then
echo '# Added by TuxShell Master Setup' >> "$PROFILE_FILE"
echo 'export PATH="$HOME/bin:$HOME/ios-Tuxshell/bin:$PATH"' >> "$PROFILE_FILE"
fi

### --- Version Report --- ###
echo "[+] Checking system versions..."
{
echo "Python3: $(python3 --version 2>&1)"
echo "Node.js: $(node -v 2>&1)"
echo "Ruby: $(ruby --version 2>&1)"
echo "PHP: $(php -v 2>&1 | head -n 1)"
echo "GCC: $(gcc --version 2>&1 | head -n 1)"
echo "Git: $(git --version 2>&1)"
} | tee "$LOG_DIR/setup-versions.log"

echo "[✓] Setup complete."

### --- Monitor System Resources --- ###
echo "[+] Running resource monitor..."

CPU_THRESH=80
MEM_THRESH=80
DISK_THRESH=90

cpu="n/a"
mem="n/a"
disk="n/a"

# CPU
if command -v top >/dev/null 2>&1; then
if top -bn1 2>/dev/null | grep -q "%Cpu"; then
cpu=$(top -bn1 | awk '/%Cpu/ {print $2 + $4}' | awk '{printf("%.2f", $1)}')
elif top -l 1 | grep -q "CPU usage:"; then
cpu=$(top -l 1 | awk '/CPU usage:/ {print $3}' | sed 's/%//' | awk '{printf("%.2f", $1)}')
fi
fi

# Memory
if command -v free >/dev/null 2>&1; then
total_mem=$(free | awk '/Mem:/ {print $2}')
used_mem=$(free | awk '/Mem:/ {print $3}')
if [ "$total_mem" -ne 0 ]; then
mem=$(awk "BEGIN {printf(\"%.2f\", $used_mem / $total_mem * 100)}")
fi
fi

# Disk
if command -v df >/dev/null 2>&1; then
disk=$(df / | awk 'END {gsub("%", "", $5); print $5+0}')
fi

echo "-----------------------------"
echo " CPU Usage: ${cpu}%"
echo " Memory Usage: ${mem}%"
echo " Disk Usage: ${disk}%"
echo "-----------------------------"

[[ "$cpu" != "n/a" && $(echo "$cpu > $CPU_THRESH" | bc -l) -eq 1 ]] && echo "[!] High CPU usage detected."
[[ "$mem" != "n/a" && $(echo "$mem > $MEM_THRESH" | bc -l) -eq 1 ]] && echo "[!] High memory usage detected."
[[ "$disk" != "n/a" && "$disk" -gt "$DISK_THRESH" ]] && echo "[!] Low disk space detected."

echo "[✓] TuxShell setup and diagnostics complete."
