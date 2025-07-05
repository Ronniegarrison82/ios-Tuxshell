#!/usr/bin/env python3
import subprocess
import difflib
import openai
import os
import sys

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

KNOWN_COMMANDS = [
"git", "ls", "vim", "nano", "python3", "pip3", "tmux",
"htop", "cd", "mkdir", "rm", "cp", "mv", "curl", "wget",
"ssh", "screen", "bash", "sh", "clear", "exit",
# Add your main project commands here
"setup.sh", "install_apps.sh", "monitor.sh", "git_auto_sync.py", "run.sh"
]

def run_command_with_suggestion(command):
try:
result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
return {"output": result.stdout, "suggestion": None}
except subprocess.CalledProcessError as e:
cmd_word = command.strip().split()[0]
close_matches = difflib.get_close_matches(cmd_word, KNOWN_COMMANDS, n=1, cutoff=0.6)
if close_matches:
suggestion = f"Did you mean: '{close_matches[0]}'?"
return {"output": e.stderr, "suggestion": suggestion}

if not OPENAI_API_KEY:
return {"output": e.stderr, "suggestion": "No suggestion available (OpenAI API key not set)."}

prompt = (
f"The user typed an invalid shell command: '{command}'. "
"Suggest the correct command or what they might have meant, "
"and explain briefly."
)
try:
response = openai.Completion.create(
engine="gpt-4o-mini",
prompt=prompt,
max_tokens=60,
temperature=0.3,
n=1,
stop=None,
)
suggestion_text = response.choices[0].text.strip()
return {"output": e.stderr, "suggestion": suggestion_text}
except Exception:
return {"output": e.stderr, "suggestion": "No suggestion available (API error)."}

def main():
if len(sys.argv) < 2:
print("Usage: command_assistant.py <command>")
sys.exit(1)
cmd = " ".join(sys.argv[1:])
result = run_command_with_suggestion(cmd)

print("\nCommand output/error:")
print(result["output"])
if result["suggestion"]:
print("\nSuggestion:")
print(result["suggestion"])

if __name__ == "__main__":
main()
