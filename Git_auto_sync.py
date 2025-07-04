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

def main():
# Get repo path from env or default to current working dir
repo_path = os.getenv("TUXSHELL_REPO_PATH", os.getcwd())
branch = os.getenv("TUXSHELL_GIT_BRANCH", "main")

if not os.path.isdir(repo_path):
print(f"[!] Repository path does not exist: {repo_path}")
sys.exit(1)

if not os.path.exists(os.path.join(repo_path, ".git")):
print("[!] Not a Git repository.")
sys.exit(1)

timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

print(f"[*] Syncing repo at {repo_path} on branch '{branch}'")

print("[*] Staging changes...")
run_git_command(["add", "."], repo_path)

# Check if there are staged changes
diff_code = subprocess.run(
["git", "-C", repo_path, "diff", "--cached", "--quiet"]
).returncode

if diff_code == 0:
print("[*] No changes to commit.")
sys.exit(0)

print("[*] Committing changes...")
run_git_command(["commit", "-m", f"Auto-sync {timestamp}"], repo_path)

print(f"[*] Pushing to origin {branch}...")
run_git_command(["push", "origin", branch], repo_path)

print(f"[✓] Synced to GitHub at {timestamp}")

if __name__ == "__main__":
main()
