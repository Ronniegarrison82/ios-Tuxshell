#!/bin/bash
# install_pip.sh — Installs Python packages with optional quiet mode and logging

set -euo pipefail

QUIET=0
PACKAGES=()

# Parse arguments
for arg in "$@"; do
case "$arg" in
--quiet|-q)
QUIET=1
;;
*)
PACKAGES+=("$arg")
;;
esac
done

if [ ${#PACKAGES[@]} -eq 0 ]; then
echo "Usage: $0 [--quiet|-q] <python-package-name> [<python-package-name>...]"
exit 1
fi

# Determine pip command
if command -v pip3 >/dev/null 2>&1; then
PIP_CMD="pip3"
elif command -v python3 >/dev/null 2>&1; then
PIP_CMD="python3 -m pip"
else
echo "[!] Error: pip3 or python3 not found."
exit 1
fi

# Define log directory and file
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$REPO_ROOT/home/user/Documents/pip-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_$(date +%Y-%m-%d_%H-%M-%S).log"

# Install packages
for pkg in "${PACKAGES[@]}"; do
echo "[+] Installing Python package: $pkg"
if [ "$QUIET" -eq 1 ]; then
$PIP_CMD install --user "$pkg" >>"$LOG_FILE" 2>&1
else
$PIP_CMD install --user "$pkg" | tee -a "$LOG_FILE"
fi
done

echo "[✓] Installation complete. Log saved to: $LOG_FILE"
