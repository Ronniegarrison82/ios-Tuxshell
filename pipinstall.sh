#!/bin/bash

set -e
set -u

QUIET=0
PACKAGES=()

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
echo "Usage: $0 [--quiet] <python-package-name> [<python-package-name>...]"
exit 1
fi

if command -v pip3 >/dev/null; then
PIP_CMD="pip3"
elif command -v python3 >/dev/null; then
PIP_CMD="python3 -m pip"
else
echo "Error: pip3 or python3 not found."
exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$REPO_ROOT/home/user/Documents/pip-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_$(date +%Y-%m-%d_%H-%M-%S).log"

for pkg in "${PACKAGES[@]}"; do
echo "[+] Installing Python package: $pkg"
if [ "$QUIET" -eq 1 ]; then
$PIP_CMD install --user "$pkg" >>"$LOG_FILE" 2>&1
else
$PIP_CMD install --user "$pkg" | tee -a "$LOG_FILE"
fi
done

echo "[✓] Installation complete. Log saved to: $LOG_FILE"
