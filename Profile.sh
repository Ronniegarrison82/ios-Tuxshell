#!/bin/sh
# ~/.profile - TuxShell environment bootstrap

# Source user's ~/.bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi

# Define REPO_ROOT dynamically if not set (default to ~/ios-Tuxshell)
if [ -z "${REPO_ROOT-}" ]; then
export REPO_ROOT="$HOME/ios-Tuxshell"
fi

# Add local bin directories to PATH
export PATH="$HOME/bin:$REPO_ROOT/bin:$PATH"

# Source core profile configurations from repo if present
if [ -f "$REPO_ROOT/etc/profile" ]; then
. "$REPO_ROOT/etc/profile"
fi

# Source environment detection script if available
if [ -f "$REPO_ROOT/lib/env_detect.sh" ]; then
. "$REPO_ROOT/lib/env_detect.sh"
fi

# Custom aliases
alias ll='ls -lah --color=auto'
alias gs='git status'
alias gd='git diff'

# Prompt customization (only if running interactively)
if [ -n "$PS1" ]; then
PS1='\u@\h:\w\$ '
fi

# Export environment flag to indicate TuxShell environment
export TUXSHELL=true

# Source project user bashrc if available
if [ -f "$REPO_ROOT/home/user/.bashrc" ]; then
. "$REPO_ROOT/home/user/.bashrc"
fi
