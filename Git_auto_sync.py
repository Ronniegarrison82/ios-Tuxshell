#!/usr/bin/env python3
import os
import subprocess
import datetime
import sys

def run_git_command(args, cwd):
result = subprocess.run(["git", "-C", cwd] + args, capture_output=True, text=True)
if result.returncode != 0:
print(f"[!] Git error: {' '.join(args)}\n{result.stderr.strip()}")
sys.exit(1)
return result.stdout.strip()

repo_path = os.getcwd()
timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# Check if .git directory exists
if not os.path.exists(os.path.join(repo_path, ".git")):
print("[!] Not a Git repository.")
sys.exit(1)

print("[*] Staging changes...")
run_git_command(["add", "."], repo_path)

# Check if there are staged changes
diff_output = subprocess.run(
["git", "-C", repo_path, "diff", "--cached", "--quiet"]
).returncode

if diff_output == 0:
print("[*] No changes to commit.")
sys.exit(0)

print("[*] Committing...")
run_git_command(["commit", "-m", f"Auto-sync {timestamp}"], repo_path)

print("[*] Pushing to remote...")
run_git_command(["push"], repo_path)

print(f"[✓] Synced to GitHub at {timestamp}")
