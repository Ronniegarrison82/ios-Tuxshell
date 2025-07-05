#!/usr/bin/env python3

import os
import sys
import shutil
import datetime
import subprocess

### === Helper: Require essential tools === ###
def require_tools(tools):
for tool in tools:
if shutil.which(tool) is None:
print(f"[!] Required tool missing: {tool}")
sys.exit(1)

### === Git Auto Sync === ###
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

def git_auto_sync():
repo_path = os.getenv("TUXSHELL_REPO_PATH", os.getcwd())
branch = os.getenv("TUXSHELL_GIT_BRANCH", "main")

if not os.path.isdir(repo_path) or not os.path.exists(os.path.join(repo_path, ".git")):
print(f"[!] Invalid Git repo at: {repo_path}")
sys.exit(1)

os.chdir(repo_path)
timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print(f"[*] Syncing repo at {repo_path} on branch '{branch}'")

if shutil.which("gh"):
gh_auth_check()

print("[*] Staging changes...")
run_cmd(["git", "add", "."])

if subprocess.run(["git", "diff", "--cached", "--quiet"]).returncode == 0:
print("[*] No changes to commit.")
return

print("[*] Committing changes...")
run_cmd(["git", "commit", "-m", f"Auto-sync {timestamp}"])

print(f"[*] Pushing to origin/{branch}...")
run_cmd(["git", "push", "origin", branch])
print(f"[✓] Auto-synced to GitHub at {timestamp}")

### === Environment Logger === ###
def log_environment():
repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
user_home = os.path.join(repo_root, "home", "user")
log_dir = os.path.join(user_home, "Documents", "console-logs")
os.makedirs(log_dir, exist_ok=True)

try:
disk_usage = shutil.disk_usage(user_home)
available_gb = disk_usage.free / (1024 ** 3)
except Exception:
available_gb = 0.0

if available_gb < 0.1:
print("[!] Warning: Low disk space (<100MB)")

print("\niOS-TuxShell Environment")
print("Session started:", datetime.datetime.now())
print("Repo user directory:", user_home)
print("Free disk space: {:.2f} GB".format(available_gb))
print("Directory listing:\n")
for item in os.listdir(user_home):
print(" ", item)

timestamp = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
log_file = os.path.join(log_dir, f"fs_log_{timestamp}.txt")

with open(log_file, 'w') as f:
f.write("Session Start: " + str(datetime.datetime.now()) + "\n")
f.write("Free Space: {:.2f} GB\n".format(available_gb))
f.write("User Directory Listing:\n")
for item in os.listdir(user_home):
f.write(" " + item + "\n")

return log_dir

### === Log Viewer === ###
def view_logs(log_dir):
if not os.path.exists(log_dir):
print("[!] No log directory found at:", log_dir)
return

logs = sorted(
[f for f in os.listdir(log_dir) if os.path.isfile(os.path.join(log_dir, f))],
reverse=True
)

if not logs:
print("[!] No log files found.")
return

print("\n=== Log Files ===")
for i, log in enumerate(logs):
print(f"{i + 1}: {log}")

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

### === Main Runner === ###
def main():
print("[*] Starting iOS-TuxShell Python Suite...")

require_tools(["git", "python3"])
if shutil.which("gh"): require_tools(["gh"])

git_auto_sync()
log_dir = log_environment()
view_logs(log_dir)

print("[✓] All steps completed successfully.")

if __name__ == "__main__":
main()
