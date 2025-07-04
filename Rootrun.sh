#!/bin/bash

# run_with_root.sh - Run commands as root with fallback logic
# Usage: ./run_with_root.sh <command> [args...]

set -e
set -u

# Check if we are running as root
if [ "$(id -u)" -ne 0 ]; then
echo "[*] Root privileges required. Trying to elevate..."

if command -v sudo >/dev/null 2>&1; then
exec sudo "$0" "$@"
elif command -v su >/dev/null 2>&1; then
exec su -c "$0 $*"
else
echo "[!] Cannot escalate privileges — 'sudo' or 'su' not found."
exit 1
fi
fi

# If we're here, we are root. Execute the user-provided command:
if [ "$#" -eq 0 ]; then
echo "[!] No command provided. Usage: $0 <command> [args...]"
exit 1
fi

echo "[✓] Running as root: $*"
exec "$@"
