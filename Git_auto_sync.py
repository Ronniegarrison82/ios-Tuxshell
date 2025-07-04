#!/usr/bin/env python3
import os, subprocess, datetime

repo_path = os.getcwd()
timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

subprocess.run(["git", "-C", repo_path, "add", "."])
subprocess.run(["git", "-C", repo_path, "commit", "-m", f"Auto-sync {timestamp}"])
subprocess.run(["git", "-C", repo_path, "push"])
print(f"[✓] Synced to GitHub at {timestamp}")
