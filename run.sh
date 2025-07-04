#!/bin/bash

set -e
set -u

REPO_PATH="https://raw.githubusercontent.com/Ronniegarrison82/ios-Tuxshell/main"
LOG_DIR="$HOME/Documents/console-logs"
TMP_SCRIPT="/tmp/main.py"

mkdir -p "$LOG_DIR"

if ! command -v curl >/dev/null; then
echo "Error: curl not found. Please install curl."
exit 1
fi

if ! command -v python3 >/dev/null; then
echo "Error: python3 not found. Please install Python 3."
exit 1
fi

curl -s "$REPO_PATH/scripts/main.py" -o "$TMP_SCRIPT"
python3 "$TMP_SCRIPT" | tee "$LOG_DIR/output-$(date +%F-%T).log"
rm "$TMP_SCRIPT"
