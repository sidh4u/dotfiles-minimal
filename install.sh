#!/usr/bin/env bash
# Bootstrap a Mac from this repo: Homebrew, packages, dotfiles (copied, never symlinked),
# vim plugins and VS Code extensions.
# Safe to re-run. Existing files that differ are moved to ~/.dotfiles-backup/<timestamp>/.
# Must stay bash 3.2 compatible - it runs on a fresh Mac before brew bash exists.

set -euo pipefail

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

CORE_ONLY=0
SKIP_BREW=0

usage() {
  cat <<EOF
Usage: ./install.sh [options]

  --core      Install only core Homebrew packages (what zshrc/vimrc need)
  --no-brew   Skip Homebrew install and brew bundle (only copy configs)
  -h, --help  Show this help

To copy changes made on this Mac back into the repo, use ./sync.sh
EOF
}

while (( $# )); do
  case $1 in
    --core) CORE_ONLY=1 ;;
    --no-brew) SKIP_BREW=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

backup() {
  mkdir -p "$BACKUP_DIR"
  mv "$1" "$BACKUP_DIR/"
  warn "backed up existing $1 -> $BACKUP_DIR/"
}

# install_file <repo-relative-src> <dest> - copy, backing up a differing existing file
install_file() {
  local src="$DOTFILES/$1" dest=$2
  if [[ -f $dest && ! -L $dest ]] && cmp -s "$src" "$dest"; then
    ok "$dest (up to date)"
    return
  fi
  if [[ -e $dest || -L $dest ]]; then
    backup "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  cp -p "$src" "$dest"
  ok "$dest (copied)"
}

[[ $(uname -s) == Darwin ]] || { echo "This script is for macOS only."; exit 1; }

# Homebrew
if (( ! SKIP_BREW )); then
  info "Homebrew"
  if ! command -v brew >/dev/null; then
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [[ -x $b ]] && eval "$("$b" shellenv)" && break
    done
  fi
  if ! command -v brew >/dev/null; then
    # Also installs Xcode Command Line Tools (git, make, clang)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [[ -x $b ]] && eval "$("$b" shellenv)" && break
    done
  fi
  ok "$(brew --version | head -1)"

  info "brew bundle ($( (( CORE_ONLY )) && echo core || echo core + dev ))"
  if (( CORE_ONLY )); then
    HOMEBREW_DOTFILES_CORE_ONLY=1 brew bundle --file="$DOTFILES/Brewfile" || warn "some packages failed - re-run or check 'brew bundle check'"
  else
    brew bundle --file="$DOTFILES/Brewfile" || warn "some packages failed - re-run or check 'brew bundle check'"
  fi
fi

# Config files (zshrc, vimrc, VS Code)
info "Config files"
while IFS='|' read -r rel dest; do
  install_file "$rel" "$dest"
done < <(file_pairs)

if [[ ! -e $HOME/.zshrc.local ]]; then
  cp "$DOTFILES/zsh/zshrc.local.example" "$HOME/.zshrc.local"
  chmod 600 "$HOME/.zshrc.local"
  warn "created ~/.zshrc.local from template - fill in secrets there"
else
  ok "$HOME/.zshrc.local (exists, left untouched)"
fi

# vim plugins
info "vim plugins"
mkdir -p "$HOME/.vim/undo"
if [[ ! -s $HOME/.vim/autoload/plug.vim ]]; then
  curl -fsSLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim -es -u "$HOME/.vimrc" -i NONE -c PlugInstall -c qa || true
ok "vim-plug plugins installed"

# VS Code extensions
info "VS Code extensions"
if command -v code >/dev/null; then
  installed=$(code --list-extensions 2>/dev/null || true)
  while read -r ext; do
    [[ -z $ext || $ext == \#* ]] && continue
    if grep -qix "$ext" <<<"$installed"; then
      ok "$ext"
    elif code --install-extension "$ext" --force >/dev/null 2>&1; then
      ok "$ext (installed)"
    else
      warn "$ext failed"
    fi
  done < "$EXTENSIONS"
else
  warn "'code' CLI not found - open VS Code, run 'Shell Command: Install code command in PATH', then re-run"
fi

info "Done. Open a new terminal (or run: exec zsh)"
[[ -d $BACKUP_DIR ]] && warn "previous files saved in $BACKUP_DIR"
exit 0
