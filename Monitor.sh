#!/bin/bash
# monitor.sh - Resource usage monitor for iOS-TuxShell (iSH-safe version)

set -euo pipefail

CPU_THRESH=80
MEM_THRESH=80
DISK_THRESH=90

echo "[+] Running resource monitor..."

# Default values
cpu="0"
mem="0"
disk="0"

# CPU Usage (%)
if command -v top >/dev/null 2>&1; then
if top -bn1 2>/dev/null | grep -q "%Cpu"; then
cpu=$(top -bn1 | awk '/%Cpu/ {print $2 + $4}' | awk '{printf("%.2f", $1)}')
elif top -l 1 | grep -q "CPU usage:"; then
cpu=$(top -l 1 | awk '/CPU usage:/ {print $3}' | sed 's/%//' | awk '{printf("%.2f", $1)}')
else
cpu="n/a"
fi
else
cpu="n/a"
fi

# Memory Usage (%)
if command -v free >/dev/null 2>&1; then
mem=$(free | awk '/Mem:/ {printf("%.2f", $3/$2 * 100.0)}')
elif command -v vm_stat >/dev/null 2>&1; then
pages_free=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
pages_active=$(vm_stat | grep "Pages active" | awk '{print $3}' | tr -d '.')
pages_inactive=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
total=$(($pages_free + $pages_active + $pages_inactive))
used=$(($pages_active + $pages_inactive))
mem=$(awk "BEGIN {printf(\"%.2f\", $used / $total * 100)}")
else
mem="n/a"
fi

# Disk Usage (%)
if command -v df >/dev/null 2>&1; then
disk=$(df / | awk 'END {gsub("%", "", $5); print $5+0}')
else
disk="n/a"
fi

# Output summary
echo "-----------------------------"
echo " CPU Usage: ${cpu}%"
echo " Memory Usage: ${mem}%"
echo " Disk Usage: ${disk}%"
echo "-----------------------------"

# Warnings (only if numeric)
if [[ "$cpu" != "n/a" ]] && [[ $(echo "$cpu > $CPU_THRESH" | bc -l) -eq 1 ]]; then
echo "[!] High CPU usage detected."
fi

if [[ "$mem" != "n/a" ]] && [[ $(echo "$mem > $MEM_THRESH" | bc -l) -eq 1 ]]; then
echo "[!] High memory usage detected."
fi

if [[ "$disk" != "n/a" ]] && [[ "$disk" -gt "$DISK_THRESH" ]]; then
echo "[!] Low disk space detected."
fi

exit 0
