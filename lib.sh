# Shared by install.sh (repo -> Mac) and sync.sh (Mac -> repo). Sourced, not run.
# Must stay bash 3.2 compatible.
# shellcheck shell=bash disable=SC2034  # vars are used by the sourcing scripts

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_USER="$HOME/Library/Application Support/Code/User"
EXTENSIONS="$DOTFILES/vscode-settings/extensions.txt"

info() { printf '\033[0;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[0;32m  ✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m  !\033[0m %s\n' "$*"; }

# Tracked files as "<repo path>|<path on this Mac>" - the one list both scripts use.
# To track another file, add a line here.
file_pairs() {
  echo "zsh/zshrc|$HOME/.zshrc"
  echo "vim/vimrc|$HOME/.vimrc"
  echo "vscode-settings/settings.json|$VSCODE_USER/settings.json"
  echo "vscode-settings/keybindings.json|$VSCODE_USER/keybindings.json"
}
