#!/bin/bash
# monitor.sh - Resource usage monitor for iOS-TuxShell (iSH-safe)

set -euo pipefail

CPU_THRESH=80
MEM_THRESH=80
DISK_THRESH=90

echo "[+] Running resource monitor..."

cpu="n/a"
mem="n/a"
disk="n/a"

# CPU Usage
if command -v top >/dev/null 2>&1; then
if top -bn1 2>/dev/null | grep -q "%Cpu"; then
cpu=$(top -bn1 | awk '/%Cpu/ {print $2 + $4}' | awk '{printf("%.2f", $1)}')
elif top -l 1 | grep -q "CPU usage:"; then
cpu=$(top -l 1 | awk '/CPU usage:/ {print $3}' | sed 's/%//' | awk '{printf("%.2f", $1)}')
fi
fi

# Memory Usage
if command -v free >/dev/null 2>&1; then
total_mem=$(free | awk '/Mem:/ {print $2}')
used_mem=$(free | awk '/Mem:/ {print $3}')
if [ "$total_mem" -ne 0 ]; then
mem=$(awk "BEGIN {printf(\"%.2f\", $used_mem / $total_mem * 100)}")
fi
fi

# Disk Usage
if command -v df >/dev/null 2>&1; then
disk=$(df / | awk 'END {gsub("%", "", $5); print $5+0}')
fi

# Output
echo "-----------------------------"
echo " CPU Usage: ${cpu}%"
echo " Memory Usage: ${mem}%"
echo " Disk Usage: ${disk}%"
echo "-----------------------------"

# Warnings
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
