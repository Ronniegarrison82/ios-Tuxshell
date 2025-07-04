# ~/.profile - TuxShell environment bootstrap

# Source ~/.bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi

# Define REPO_ROOT dynamically if not set (assumes repo is cloned in ~/ios-Tuxshell)
if [ -z "${REPO_ROOT-}" ]; then
export REPO_ROOT="$HOME/ios-Tuxshell"
fi

# Add local bin directory to PATH
export PATH="$HOME/bin:$REPO_ROOT/bin:$PATH"

# Load core profile configurations from the repo if available
if [ -f "$REPO_ROOT/etc/profile" ]; then
. "$REPO_ROOT/etc/profile"
fi

# Load environment-specific shell initializations
if [ -f "$REPO_ROOT/lib/env_detect.sh" ]; then
. "$REPO_ROOT/lib/env_detect.sh"
fi

# Custom aliases
alias ll='ls -lah --color=auto'
alias gs='git status'
alias gd='git diff'

# Prompt customization
if [ -z "$PS1" ]; then
PS1='\u@\h:\w\$ '
fi

# Export environment variables useful for scripts
export TUXSHELL=true

# Load user bashrc from repo home if present
if [ -f "$REPO_ROOT/home/user/.bashrc" ]; then
. "$REPO_ROOT/home/user/.bashrc"
fi
