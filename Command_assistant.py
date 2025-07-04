#!/usr/bin/env python3
import subprocess
import difflib
import openai
import os
import json

# Setup your OpenAI API key securely, e.g. via environment variable
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
if not OPENAI_API_KEY:
print("Error: OPENAI_API_KEY environment variable not set.")
exit(1)

openai.api_key = OPENAI_API_KEY

# Known commands to do quick local fuzzy matching (extend this list as you add commands)
KNOWN_COMMANDS = [
"git", "ls", "vim", "nano", "python3", "pip3", "tmux",
"htop", "cd", "mkdir", "rm", "cp", "mv", "curl", "wget",
"ssh", "screen", "bash", "sh", "clear", "exit"
]

def run_command_with_suggestion(command):
try:
result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
return {"output": result.stdout, "suggestion": None}
except subprocess.CalledProcessError as e:
# Extract first word as command to check
cmd_word = command.strip().split()[0]
close_matches = difflib.get_close_matches(cmd_word, KNOWN_COMMANDS, n=1, cutoff=0.6)
if close_matches:
suggestion = f"Did you mean: '{close_matches[0]}'?"
return {"output": e.stderr, "suggestion": suggestion}

# If no local suggestion, query ChatGPT API
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
except Exception as api_err:
return {"output": e.stderr, "suggestion": "No suggestion available (API error)."}

def main():
import sys
if len(sys.argv) < 2:
print(json.dumps({"error": "No command provided"}))
sys.exit(1)
cmd = " ".join(sys.argv[1:])
result = run_command_with_suggestion(cmd)
print(json.dumps(result))

if __name__ == "__main__":
main()
