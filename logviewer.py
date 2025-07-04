#!/usr/bin/env python3
import os

log_dir = os.path.expanduser("~/Documents/console-logs")
if not os.path.exists(log_dir):
print("[!] No log directory found.")
exit(1)

logs = sorted(os.listdir(log_dir), reverse=True)

print("=== Log Files ===")
for i, log in enumerate(logs):
print(f"{i+1}: {log}")

choice = input("\nEnter log number to view: ")
try:
log_file = logs[int(choice)-1]
with open(os.path.join(log_dir, log_file), 'r') as f:
print("\n--- Log Start ---\n")
print(f.read())
print("\n--- Log End ---")
except:
print("[!] Invalid selection.")
