#!/bin/bash

REPO_RAW_URL="https://raw.githubusercontent.com/Ronniegarrison82/iOS-Tuxshell/main"
LOG_DIR="$HOME/Documents/console-logs"
TMP_SCRIPT="/tmp/command_assistant.py"

mkdir -p "$LOG_DIR"

echo "[+] Downloading Python assistant..."

if ! command -v curl >/dev/null 2>&1; then
echo "[!] curl not found. Please install curl first."
exit 1
fi

curl -sf "$REPO_RAW_URL/scripts/command_assistant.py" -o "$TMP_SCRIPT"
if [ ! -s "$TMP_SCRIPT" ]; then
echo "[!] Failed to download script. Check the URL or network connection."
exit 1
fi

echo "[+] Running assistant..."

if ! command -v python3 >/dev/null 2>&1; then
echo "[!] python3 not found. Please install Python 3."
rm -f "$TMP_SCRIPT"
exit 1
fi

# Use a safe timestamp format for log filename (no colons)
LOG_FILE="$LOG_DIR/output-$(date +%Y%m%d-%H%M%S).log"

python3 "$TMP_SCRIPT" | tee "$LOG_FILE"

rm -f "$TMP_SCRIPT"
