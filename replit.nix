{ pkgs }: {
deps = [
pkgs.bashInteractive # Interactive bash shell
pkgs.git # Git version control
pkgs.curl # Curl HTTP client
pkgs.wget # Wget downloader
pkgs.nano # Simple text editor
pkgs.vim # Advanced text editor
pkgs.nodejs # Node.js runtime
pkgs.python3 # Python 3 interpreter
pkgs.ruby # Ruby language
pkgs.php # PHP CLI
pkgs.gcc # GNU Compiler Collection
pkgs.gnumake # GNU Make tool
pkgs.nettools # Networking tools (netstat, ifconfig, etc.)

# Additional useful packages:
pkgs.tmux # Terminal multiplexer
pkgs.htop # Interactive process viewer
pkgs.lsof # List open files
pkgs.jq # JSON processor
pkgs.traceroute # Network route tracing
pkgs.bash-completion # Shell command completion
pkgs.gnupg # Encryption and signing tools
pkgs.unzip # Unzip utility
pkgs.zip # Zip utility
pkgs.grep # Text searching tool
pkgs.sed # Stream editor
pkgs.awk # Text processing language
];
}
