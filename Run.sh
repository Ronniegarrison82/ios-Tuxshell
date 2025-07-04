#!/bin/bash

REPO_RAW_URL="https://raw.githubusercontent.com/Ronniegarrison82/iOS-Tuxshell/main"
LOG_DIR="$HOME/Documents/console-logs"
TMP_SCRIPT="/tmp/command_assistant.py"

mkdir -p "$LOG_DIR"

echo "[+] Downloading Python assistant..."
curl -s "$REPO_RAW_URL/scripts/command_assistant.py" -o "$TMP_SCRIPT"

if [ ! -s "$TMP_SCRIPT" ]; then
  echo "[!] Failed to download script. Check the path."
  exit 1
fi

echo "[+] Running assistant..."
python3 "$TMP_SCRIPT" | tee "$LOG_DIR/output-$(date +%F-%T).log"

rm "$TMP_SCRIPT"
