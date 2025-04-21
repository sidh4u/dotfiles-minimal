# 🛠️ My Dotfiles (minimal) — Simple Yet Powerful

Welcome to my dotfiles repository. These configs are designed to be simple, portable, and instantly useful across systems — helping you get a powerful dev environment with minimal setup.

💡 This setup is designed to be lean and fast — no Oh My Zsh overhead, just Zsh + smart plugins.

This repo includes:
- ⚡ A Vim setup with curated plugins and a modern theme
- 🐚 A Zsh setup with time-saving aliases and a Git-aware prompt

---

### ✨ Vim Configuration (`vimrc`)

This is not just a `vimrc` — it's a thoughtfully curated setup designed to enhance your productivity and make Vim a modern, powerful editor. With a combination of plugins, custom key bindings, and smart defaults, this configuration transforms Vim into a feature-rich development environment.

Key highlights include:
- **Plugin Management**: Powered by `vim-plug`, ensuring easy installation and management of plugins.
- **Modern Themes**: Includes `vim-code-dark` and `onedark.vim` for a sleek, modern look.
- **Enhanced Navigation**: Features like NERDTree for file exploration and UndoTree for visualizing undo history.
- **Smart Indentation**: Automatically handles indentation with settings optimized for coding.
- **Git Integration**: Displays the current Git branch in the status bar using `lightline` and `vim-gitbranch`.
- **Custom Key Bindings**: Intuitive shortcuts for toggling features like NERDTree, UndoTree, floating terminals, and more.
- **Persistent Undo**: Keeps your undo history across sessions for seamless editing.
- **Rainbow Parentheses**: Color-coded parentheses for better readability in nested code.
- **Floating Terminal**: Easily toggle a terminal within Vim for quick command-line access.

This configuration is designed to be lightweight yet powerful, making Vim a joy to use for both beginners and advanced users.

### `Vim Custom Key Bindings and Toggles`

This Vim configuration includes several custom key bindings and toggles to enhance productivity:

#### General Key Bindings
- **Toggle NERDTree**:
  Press `<C-n>` to open or close the NERDTree file explorer.

- **Undo Tree**:
  Press `<C-b>` to toggle the Undo Tree, which visualizes the undo history.

- **Floating Terminal**:
  - Press `<C-`>` to toggle the floating terminal.
  - Press `<C-d>` to kill the floating terminal.

- **Indent Guides**:
  Press `<C-i>` to toggle the visibility of indent guides.

- **Line Numbers**:
  Press `<C-l>` to toggle between absolute and relative line numbers.

- **Tab Navigation**:
  - Press `<S-Left>` to switch to the previous tab.
  - Press `<S-Right>` to switch to the next tab.

#### Other Features
- **Search Behavior**:
  - Case-insensitive search unless uppercase letters are used (`smartcase`).
  - Incremental search (`incsearch`) with highlighted matches (`hlsearch`).
  - Search highlights are cleared automatically when entering insert mode.

- **Auto Indentation**:
  - Smart indentation with `tabstop=2`, `shiftwidth=2`, and `expandtab` for spaces instead of tabs.

- **Persistent Undo**:
  - Undo history is saved in `~/.vim/undo` for persistent undo across sessions.

- **Rainbow Parentheses**:
  - Nested parentheses are color-coded for better readability.

- **Status Bar**:
  - Displays the current Git branch, file name, and mode using `lightline`.

- **Theme**:
  - Default theme is `vim-code-dark` with modern dark colors and italicized comments.

- **Scroll Behavior**:
  - Keeps the cursor centered with `scrolloff=2` and `sidescrolloff=2`.

- **File Explorer Behavior**:
  - NERDTree automatically closes Vim if it is the last open window.

#### Rendering and Display
- **Cursor Line**:
  - Highlights the current line for better focus.

- **UTF-8 Encoding**:
  - Ensures proper rendering of special characters with UTF-8 encoding.

- **Match Highlighting**:
  - Highlights matching parentheses or brackets when the cursor is on them.

#### Miscellaneous
- **Backup and Swap Files**:
  - Backup, swap, and undo files are stored in `/tmp//` to keep the working directory clean.
- **Visual Bell**:
  - Disables error sounds and uses a visual bell instead.

#### Toggle Summary
| Key Binding | Action                                |
| ----------- | ------------------------------------- |
| `<C-n>`     | Toggle NERDTree                       |
| `<C-b>`     | Toggle Undo Tree                      |
| `<C-`>`     | Toggle Floating Terminal              |
| `<C-d>`     | Kill Floating Terminal                |
| `<C-i>`     | Toggle Indent Guides                  |
| `<C-l>`     | Toggle Absolute/Relative Line Numbers |
| `<S-Left>`  | Switch to Previous Tab                |
| `<S-Right>` | Switch to Next Tab                    |

---

### 🐚 Zsh Configuration (`zshrc`)

This `zshrc` file customizes your shell environment to be fast, efficient, and developer-friendly. It includes smart defaults, helpful aliases, plugin support, and a Git-aware prompt to boost your productivity.

- **Homebrew Integration**:
  - Automatically detects system architecture (Intel or Apple Silicon) and sets the correct Homebrew path.
  - Provides handy aliases for common Homebrew actions:
- **Time-Saving Aliases**:
  - Enhances standard commands like ls, grep, rm, and cp with safer or more informative defaults.
  - Includes productivity aliases for: Docker, Kubernetes, Git, Vim/Zsh: quickly edit and reload config files etc.
- Git-Aware Prompt
  - Displays current Git branch and status directly in the shell prompt.
  - Helps avoid mistakes by keeping Git context visible at all times.
- Smart History Management
  - Persistent, shared history across sessions
  - Ignores duplicate entries and commands prefixed with a space
  - Makes shell history more useful and less cluttered
- Plugins for Enhanced UX
  - `zsh-autosuggestions`: Suggests previous commands as you type
  - `zsh-syntax-highlighting`: Highlights valid/invalid syntax in real time
  - `history-substring-search`: Search your history with arrow keys
  - `zsh-completions`: For zsh completions, helps providing command suggestions
- Intelligent Completions
  - Autocompletion support for: Docker, Kubernetes (kubectl, helm), Homebrew, Git and All general commands
  - Improves discoverability and speeds up command-line usage

### `Prerequisites for zshrc`

Ensure you have [Homebrew](https://brew.sh/) installed. If not, install it using:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Run the following commands to install the necessary `brew` packages:
```sh
# Linux packages - These helps bash scripts developed in Mac, will work on Linux seamlessly.
brew install coreutils gawk gnu-sed bash openssl

# Zsh plugins
brew install zsh-completions zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search

# Git and GitHub CLI
brew install git gh

# Docker - May not need to install, if you are using Docker Desktop
brew install docker

# Kubernetes tools
brew install kubernetes-cli aws-iam-authenticator

# AWS CLI
brew install awscli
```

**Additional Notes (zshrc):**
- For Docker and Kubernetes completions, ensure the completions are set up as described in the .zshrc.
- Install aws-profile-manager from [HERE](https://github.com/sidh4u/aws-profile-manager) for `AWS profile management`.
- VMware tools require VMware Fusion, which can be downloaded from [Broadcom](https://knowledge.broadcom.com/external/article/315638/download-and-install-vmware-fusion.html) website.

### ⚡️ Quickstart | How to setup

1. Clone the repo (or just checkout the relevant branch):
    ```sh
    gh repo clone sidh4u/dotfiles-minimal
    cd dotfiles-minimal
    ```
2. Set up Vim and Zsh configs:
   ```sh
    cp vim/vimrc ~/.vimrc
    cp zsh/zshrc ~/.zshrc
   ```
3. Launch Vim once to trigger automatic plugin installation:
   ```sh
   vi
   ```
4. Restart your terminal or source your .zshrc:
   ```sh
   source ~/.zshrc
   ```

⚠️ Note: Some Zsh features depend on Homebrew and a few commonly used plugins (e.g., zsh-autosuggestions, zsh-syntax-highlighting). Make sure you have those installed via brew.
