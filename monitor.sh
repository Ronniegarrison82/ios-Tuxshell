#!/bin/bash

set -e
set -u

CPU_THRESH=80
MEM_THRESH=80
DISK_THRESH=90

# CPU: iSH and Alpine might use 'top' differently; fall back if needed
if command -v top >/dev/null && top -bn1 | grep -q "%Cpu"; then
cpu=$(top -bn1 | grep "%Cpu" | awk '{print $2 + $4}')
else
cpu=0
fi

# MEM: Supports both Alpine and Debian-style 'free'
if command -v free >/dev/null; then
mem=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
else
mem=0
fi

# DISK: Use '/' but allow alternate mount points if needed
disk=$(df / | awk 'END {gsub("%", "", $5); print $5+0}')

echo "CPU Usage: ${cpu}%"
echo "Memory Usage: ${mem}%"
echo "Disk Usage: ${disk}%"

if (( $(echo "$cpu > $CPU_THRESH" | bc -l) )); then
echo "High CPU usage!"
fi

if (( $(echo "$mem > $MEM_THRESH" | bc -l) )); then
echo "High memory usage!"
fi

if [ "$disk" -gt "$DISK_THRESH" ]; then
echo "Low disk space!"
fi
