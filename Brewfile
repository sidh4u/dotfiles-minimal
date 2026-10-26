# Homebrew bundle - installed by install.sh
#   ./install.sh          -> core + languages + DevOps/cloud tools
#   ./install.sh --core   -> core only (what zshrc/vimrc need)
# Check what's missing: brew bundle check --verbose

# Skip casks whose app was installed outside Homebrew (cask install would fail)
def app?(name)
  File.exist?("/Applications/#{name}.app")
end

########## Core - required by zshrc ##########
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "zsh-history-substring-search"
brew "zsh-syntax-highlighting"
brew "coreutils"          # gls, gdate
brew "gawk"
brew "gnu-sed"
brew "gnu-tar"
brew "jq"
brew "yq"
brew "gh"
brew "wget"
brew "tree"
brew "xz"                 # also needed by rustup and python

cask "iterm2" unless app?("iTerm")
cask "visual-studio-code" unless app?("Visual Studio Code")

# brew drops non-HOMEBREW_* env vars, hence the prefix
unless ENV["HOMEBREW_DOTFILES_CORE_ONLY"]
  ########## Languages / runtimes ##########
  brew "bash"
  brew "python"
  brew "go"
  brew "node"
  brew "bun"
  brew "ruby", link: false   # left unlinked; zshrc puts opt/ruby/bin on PATH
  brew "rustup"           # keg-only; zshrc puts opt/rustup/bin on PATH
  brew "composer"         # pulls in php
  cask "corretto@21"      # JAVA_HOME in zshrc

  ########## Containers / Kubernetes ##########
  cask "docker-desktop" unless app?("Docker")
  brew "kubernetes-cli"
  brew "helm"
  brew "kind"
  brew "minikube"

  ########## Cloud CLIs / IaC ##########
  brew "awscli"
  cask "gcloud-cli"
  cask "azure-cli"
  tap "hashicorp/tap"
  brew "hashicorp/tap/terraform"
  brew "hashicorp/tap/vault"

  ########## Dev utilities ##########
  brew "shellcheck"
  brew "shfmt"
  brew "hyperfine"        # benchmark shell startup: hyperfine --warmup 3 'zsh -i -c exit'
end
