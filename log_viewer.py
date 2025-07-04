#!/usr/bin/env python3
import os
import sys

# Define log directory
log_dir = os.path.expanduser("~/Documents/console-logs")

# Check if directory exists
if not os.path.exists(log_dir):
print("[!] No log directory found at:", log_dir)
sys.exit(1)

# Gather and sort logs
logs = sorted([f for f in os.listdir(log_dir) if os.path.isfile(os.path.join(log_dir, f))], reverse=True)

if not logs:
print("[!] No log files found.")
sys.exit(1)

# Display log file list
print("=== Log Files ===")
for i, log in enumerate(logs):
print(f"{i+1}: {log}")

# Prompt for selection
try:
choice = int(input("\nEnter log number to view: "))
if choice < 1 or choice > len(logs):
raise ValueError("Choice out of range.")

log_file = logs[choice - 1]
log_path = os.path.join(log_dir, log_file)

print("\n--- Log Start ---\n")
with open(log_path, 'r', encoding='utf-8') as f:
print(f.read())
print("\n--- Log End ---")

except (ValueError, IndexError):
print("[!] Invalid selection.")
except Exception as e:
print(f"[!] Error reading log: {e}")
