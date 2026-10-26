#!/usr/bin/env bash
# Copy the live configs from this Mac back into the repo (the reverse of install.sh),
# then show what changed. Run periodically, review with 'git diff', commit yourself.
# Never commits or pushes. Must stay bash 3.2 compatible.

set -euo pipefail

# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Config files (zshrc, vimrc, VS Code)
info "Config files"
while IFS='|' read -r rel live; do
  if [[ ! -f $live ]]; then
    warn "$live not found - skipped"
  elif cmp -s "$live" "$DOTFILES/$rel"; then
    ok "$rel"
  else
    cp "$live" "$DOTFILES/$rel"   # plain cp keeps the repo file's mode
    warn "$rel updated"
  fi
done < <(file_pairs)

# VS Code extensions
info "VS Code extensions"
if command -v code >/dev/null; then
  tmp=$(mktemp)
  code --list-extensions 2>/dev/null > "$tmp" || true
  if [[ ! -s $tmp ]]; then
    warn "'code --list-extensions' returned nothing - extensions.txt left unchanged"
    rm -f "$tmp"
  elif cmp -s "$tmp" "$EXTENSIONS"; then
    ok "extensions.txt"
    rm -f "$tmp"
  else
    mv "$tmp" "$EXTENSIONS"
    warn "extensions.txt updated"
  fi
else
  warn "'code' CLI not found - skipped"
fi

# Homebrew - report drift only; edit the Brewfile by hand (keep its sections)
if command -v brew >/dev/null; then
  info "Homebrew (Brewfile drift)"
  if brew bundle check --file="$DOTFILES/Brewfile" >/dev/null 2>&1; then
    ok "everything in Brewfile is installed"
  else
    warn "missing from this Mac: run 'brew bundle check --file=Brewfile --verbose'"
  fi
  extra=$(comm -23 <( (brew leaves; brew list --cask) | sort -u) \
                   <(brew bundle list --file="$DOTFILES/Brewfile" --all | sort -u) | tr '\n' ' ')
  if [[ -n $extra ]]; then
    warn "installed but not in Brewfile (add the ones to keep): $extra"
  else
    ok "no packages outside the Brewfile"
  fi
fi

# Secrets guard - nothing secret may reach git
info "Secret scan"
if git -C "$DOTFILES" grep -nE 'hvs\.[A-Za-z0-9]{20}|AKIA[0-9A-Z]{16}|BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9]{30}' -- . ':!lib.sh' ':!sync.sh'; then
  warn "possible secret above - move it to ~/.zshrc.local before committing"
else
  ok "no secrets found"
fi

info "Changes in repo"
git -C "$DOTFILES" status --short
