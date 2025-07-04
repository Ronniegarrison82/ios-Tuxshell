#!/usr/bin/env python3
import os
import subprocess
import datetime
import sys
import shutil

def run_cmd(cmd_list, cwd=None):
result = subprocess.run(cmd_list, cwd=cwd, capture_output=True, text=True)
if result.returncode != 0:
print(f"[!] Error running: {' '.join(cmd_list)}")
print(result.stderr.strip())
sys.exit(1)
return result.stdout.strip()

def gh_auth_check():
if shutil.which("gh"):
print("[*] Checking GitHub CLI authentication...")
auth_check = subprocess.run(["gh", "auth", "status"], capture_output=True, text=True)
if auth_check.returncode != 0:
print("[!] GitHub CLI not authenticated. Run: gh auth login")
sys.exit(1)

def main():
repo_path = os.getenv("TUXSHELL_REPO_PATH", os.getcwd())
branch = os.getenv("TUXSHELL_GIT_BRANCH", "main")

if not os.path.isdir(repo_path):
print(f"[!] Repository path does not exist: {repo_path}")
sys.exit(1)

if not os.path.exists(os.path.join(repo_path, ".git")):
print("[!] Not a Git repository.")
sys.exit(1)

os.chdir(repo_path)

timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print(f"[*] Syncing repo at {repo_path} on branch '{branch}'")

# Use GitHub CLI if available
use_gh = shutil.which("gh") is not None

if use_gh:
gh_auth_check()

print("[*] Staging changes...")
run_cmd(["git", "add", "."])

print("[*] Checking for staged changes...")
if subprocess.run(["git", "diff", "--cached", "--quiet"]).returncode == 0:
print("[*] No changes to commit.")
return

print("[*] Committing changes...")
run_cmd(["git", "commit", "-m", f"Auto-sync {timestamp}"])

print(f"[*] Pushing to origin/{branch}...")
run_cmd(["git", "push", "origin", branch"])

print(f"[✓] Auto-synced to GitHub at {timestamp}")

if __name__ == "__main__":
main()
