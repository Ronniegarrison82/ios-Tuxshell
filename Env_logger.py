import os
import shutil
import datetime

repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
user_home = os.path.join(repo_root, "home", "user")
log_dir = os.path.join(user_home, "Documents", "console-logs")

os.makedirs(log_dir, exist_ok=True)

try:
disk_usage = shutil.disk_usage(user_home)
available_gb = disk_usage.free / (1024 ** 3)
except:
available_gb = 0.0

print("AI Environment Terminal")
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
