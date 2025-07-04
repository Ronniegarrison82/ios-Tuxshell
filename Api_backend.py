#!/usr/bin/env python3
from flask import Flask, request, jsonify
import subprocess
import shlex
import os

app = Flask(__name__)

# Allowlist commands or safe execution logic
ALLOWED_COMMANDS = [
"ls", "cat", "pwd", "echo", "python3", "bash", "git",
"top", "htop", "df", "free", "uptime", "ping",
# Add more commands if safe
]

def is_command_allowed(cmd):
parts = shlex.split(cmd)
if not parts:
return False
return parts[0] in ALLOWED_COMMANDS

@app.route("/run", methods=["POST"])
def run_command():
data = request.json
if not data or "command" not in data:
return jsonify({"error": "No command provided"}), 400

cmd = data["command"]
if not is_command_allowed(cmd):
return jsonify({"error": "Command not allowed"}), 403

try:
result = subprocess.run(
cmd, shell=True, capture_output=True, text=True, timeout=15
)
output = result.stdout + result.stderr
return jsonify({"output": output})
except Exception as e:
return jsonify({"error": str(e)}), 500

@app.route("/file/read", methods=["GET"])
def read_file():
path = request.args.get("path")
if not path:
return jsonify({"error": "No path specified"}), 400
safe_dir = os.path.expanduser("~/ios-Tuxshell")
abs_path = os.path.abspath(os.path.expanduser(path))
if not abs_path.startswith(safe_dir):
return jsonify({"error": "Access denied"}), 403
if not os.path.isfile(abs_path):
return jsonify({"error": "File not found"}), 404

try:
with open(abs_path, "r") as f:
content = f.read()
return jsonify({"content": content})
except Exception as e:
return jsonify({"error": str(e)}), 500

@app.route("/file/write", methods=["POST"])
def write_file():
data = request.json
if not data or "path" not in data or "content" not in data:
return jsonify({"error": "Invalid request"}), 400

safe_dir = os.path.expanduser("~/ios-Tuxshell")
abs_path = os.path.abspath(os.path.expanduser(data["path"]))
if not abs_path.startswith(safe_dir):
return jsonify({"error": "Access denied"}), 403

try:
with open(abs_path, "w") as f:
f.write(data["content"])
return jsonify({"message": "File saved"})
except Exception as e:
return jsonify({"error": str(e)}), 500

@app.route("/list_dir", methods=["GET"])
def list_dir():
dir_path = request.args.get("dir")
if not dir_path:
return jsonify({"error": "No directory specified"}), 400

safe_dir = os.path.expanduser("~/ios-Tuxshell")
abs_path = os.path.abspath(os.path.expanduser(dir_path))
if not abs_path.startswith(safe_dir):
return jsonify({"error": "Access denied"}), 403
if not os.path.isdir(abs_path):
return jsonify({"error": "Directory not found"}), 404

try:
files = os.listdir(abs_path)
return jsonify({"files": files})
except Exception as e:
return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
app.run(host="0.0.0.0", port=5000)
