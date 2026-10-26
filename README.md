# 🛠️ My Dotfiles (minimal) — Simple Yet Powerful

Welcome to my dotfiles repository. These configs are simple, portable and instantly useful. One
command takes a fresh Mac to a fast, fully loaded terminal and editor setup.

💡 This setup is lean and fast: no Oh My Zsh overhead, just zsh + smart plugins. A new shell is
ready in **about 35 ms**.

🧑‍💻 **Built for DevOps, SRE, platform and cloud engineers, and for hardcore developers** who live in the
terminal and move between containers, clusters and cloud accounts all day. If you open dozens of
shells a day, a shell that starts in under 50 ms and has short aliases plus completions for every CLI
is a must-have, not a nice-to-have.

This repo includes:
- 🐚 A **Zsh** setup with time-saving aliases, a git-aware prompt and cached completions
- ⚡ A **Vim** setup with curated plugins and a modern theme
- 🎨 **VS Code** settings, key bindings and an extensions list
- 🧰 **Languages** ready to use: Rust, Go, Python, Java (Corretto 21), Ruby, Node.js, Bun, PHP
- ☁️ A **DevOps toolbox**: Docker, Kubernetes (kubectl, helm, kind, minikube), AWS, Google Cloud,
  Azure, Terraform, Vault
- 🚀 **One-command install** (`./install.sh`) and **sync back** (`./sync.sh`). Plain copies, no
  symlinks, everything backed up before it's replaced

---

## ⚡️ Quickstart | How to setup

1. Clone the repo:
    ```sh
    git clone https://github.com/sidh4u/dotfiles-minimal.git ~/dotfiles-minimal
    cd ~/dotfiles-minimal
    ```
2. Run the installer (installs Homebrew if needed, all packages, configs, vim plugins and VS Code extensions):
    ```sh
    ./install.sh
    ```
3. Restart your terminal, or reload zsh:
    ```sh
    exec zsh
    ```

| Command | Installs |
| --- | --- |
| `./install.sh` | Core tools + all languages + DevOps/cloud CLIs, then copies the configs |
| `./install.sh --core` | Only what zshrc and vimrc need, then copies the configs |
| `./install.sh --no-brew` | Configs only (Homebrew already set up) |

⚠️ Note: On a brand-new Mac, the first `git` command prompts you to install the Xcode Command Line
Tools. Accept, then run the steps again. The installer is safe to re-run: identical files are skipped,
and anything it replaces is moved to `~/.dotfiles-backup/<timestamp>/` first.

### `Prerequisites`

- macOS (Apple Silicon or Intel) with zsh, the default shell
- [Homebrew](https://brew.sh/). `install.sh` installs it if it's missing, or install it yourself:
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- Everything else comes from the [Brewfile](Brewfile). To install packages without the configs:
  `brew bundle --file=Brewfile`

---

## 🚀 Speed — measure it yourself

Startup time is the point of this zshrc. Every new tab, split, `tmux` pane, VS Code terminal and
`zsh -c` script pays it. With all the tools above installed (Apple Silicon):

```console
$ zt                       # alias: for i in {1..5}; do time zsh -i -c exit; done
zsh -i -c exit  0.02s user 0.01s system 92% cpu 0.034 total
zsh -i -c exit  0.02s user 0.01s system 92% cpu 0.034 total
zsh -i -c exit  0.02s user 0.01s system 93% cpu 0.034 total
```

`total` is the wall-clock time to start an interactive shell, load everything and exit. For comparison,
`time zsh -f -i -c exit` (zsh with no config at all) gives the floor, about 3 ms on the same Mac.

**Find what's slow** with `zp` (runs zsh's built-in profiler, `zprof`):

```console
$ zp
num  calls                time                       self            name
-----------------------------------------------------------------------------------
 1)    1          10.77    10.77   62.79%     10.77    10.77   62.79%  compinit
 2)    1           3.02     3.02   17.61%      2.98     2.98   17.36%  _zsh_highlight_load_highlighters
 3)    8           1.67     0.21    9.72%      1.67     0.21    9.72%  _comp
```

**More precise numbers** (warm-up runs, mean ± deviation) with [hyperfine](https://github.com/sharkdp/hyperfine),
which the Brewfile installs:

```console
$ hyperfine --warmup 3 'zsh -i -c exit'
Benchmark 1: zsh -i -c exit (88 runs)
                mean     ±       σ          min     …     max
  Wall Time     33.7 ms  ±     0.4 ms      32.9 ms  …    34.8 ms
  Memory         4.9 MiB ±     0.0 MiB      4.9 MiB …     4.9 MiB
```

The zshrc always finishes with exit status 0, so `zsh -i -c exit` is safe to benchmark (hyperfine stops
on a non-zero exit). Close busy apps for steady numbers; a loaded Mac shows a bigger `±`.

#### Why it's fast
- **No framework**: no Oh My Zsh, Prezto or plugin manager. The plugins are sourced directly from Homebrew.
- **Cached `brew shellenv`**: generated once into `~/.zsh/`, regenerated only when brew itself changes.
- **Cached completions**: `docker`, `kubectl`, `helm`, `gh`, … completions are generated into
  `~/.zsh/completions/` and regenerated only when that binary is newer than its cached copy, so there's
  no `eval "$(tool completion zsh)"` on every start.
- **`compinit` security check once a day**: every other start uses the cached dump (`compinit -C`).
- **No version-manager hooks**: languages come from Homebrew, so there's no `nvm`, `pyenv` or `rbenv`
  initialisation on every start.

#### Keep it fast
Run `zt` after every change. If it jumps, run `zp`. The usual culprits are `eval "$(some-tool init zsh)"`
lines and slow `source` calls. Cache their output the way `_comp` does, or move rarely used tools into a
function that loads them on first use.

#### Install time vs load time
Install time barely matters: you run `./install.sh` once per Mac. Most of it is Homebrew downloading
packages, so it depends on your network and what's already installed (`--core` is much quicker).
Copying the configs and installing the vim plugins takes about 2 s; an up-to-date re-run about 0.3 s.
**Load time** is what you pay all day, on every new shell, so it's the number this setup is tuned for.

---

## 🐚 Zsh Configuration (`zshrc`)

This `zshrc` makes your shell fast, efficient and developer-friendly: smart defaults, helpful aliases,
plugin support and a git-aware prompt.

- **Homebrew Integration**
  - Detects Apple Silicon or Intel, sets the right Homebrew paths and caches `brew shellenv`.
  - Handy aliases: `bri` install, `brr` uninstall, `brs` search, `brl` list, `bro` show outdated,
    `bru` upgrade everything and clean up.
- **Time-Saving Aliases**
  - Safer or more informative defaults for standard commands (`rm`/`mv`/`cp` ask first, coloured `ls`/`grep`).
  - GNU `date`, `awk` and `sed` when installed, so scripts behave the same as on Linux.
  - Productivity aliases for GitHub CLI, Docker, Kubernetes, AWS, Google Cloud, Azure, Terraform, Vault,
    networking, and quickly editing/reloading zsh and vim configs.
- **Git-Aware Prompt**
  - Shows the current directory, git branch and status using git's own `git-prompt.sh`: `*` unstaged,
    `+` staged, `$` stash, `%` untracked, `<`/`>` behind/ahead, and in-progress rebase/merge state.
  - Keeps git context visible at all times, so it's harder to commit to the wrong branch.
- **Smart History Management**
  - 200k entries, persistent and shared across sessions.
  - Ignores duplicates and commands prefixed with a space.
  - `h <text>` searches history; ↑/↓ search by what you've typed so far.
- **Plugins for Enhanced UX**
  - `zsh-autosuggestions`: suggests previous commands as you type
  - `zsh-syntax-highlighting`: highlights valid/invalid syntax in real time
  - `zsh-history-substring-search`: search your history with the arrow keys
  - `zsh-completions`: extra completion definitions
- **Intelligent Completions**
  - Cached completions for docker, kubectl, helm, kind, minikube, gh, rustup and cargo; plus aws, gcloud,
    az and terraform. Each one only loads if the tool is installed.
- **Languages on PATH**: Java, Python, Go, Rust, Ruby, Node, Bun and Composer, with no extra setup
  (see 🧰 Languages below).
- **Secrets stay local**: `~/.zshrc.local` (untracked) is sourced for tokens and per-machine overrides.

#### General Aliases
| Aliases | Action |
| --- | --- |
| `zc` `ze` `zs` | Show / edit / reload zshrc (`zs` restarts the shell cleanly) |
| `zt` `zp` | Time startup (5 runs) / profile startup |
| `vc` `ve` | Show / edit vimrc |
| `vpi` `vpu` `vpc` `vps` `vpr` | Vim plugins: install / update / clean / status / reinstall |
| `ghs` `ghl` `ghrl` `ghc` `ghv` | gh: auth status / login / list repos / clone / open in browser |
| `ghpr` `ghprl` `ghprv` | Create PR from branch / list PRs / open PR in browser |
| `ghrun` `ghrw` | Recent Actions runs / watch a run |
| `ll` `la` `path` | Long listing / including hidden / print `$PATH` one per line |
| `wanip` `lanip` `ips` `listen` `dnsflush` | Public IP / LAN IP / all IPs / listening ports / flush DNS |
| `weather [city]` | Forecast in the terminal |
| `mac-upgrade` `mac-time-sync` | Install macOS updates / resync the clock |

#### DevOps Aliases
| Tool | Aliases |
| --- | --- |
| **Docker** | `di` images, `dps` all containers, `de <ctr> [sh]` exec shell, `dr <img> [sh]` run throwaway, `dlg` follow logs, `ds` stop, `dt` tag, `dpul`/`dpus` pull/push, `din` inspect, `dh` history, `drmi`/`drmc` remove image/container |
| Docker cleanup | `dip` images, `dpsp` stopped containers, `dpb` build cache, `dsp` everything incl. volumes |
| Docker buildx | `dbc` create a multi-arch (amd64+arm64) builder, `dbin` inspect, `dbl` list, `dbrm` remove |
| Registries | `dl`/`dlo` log in/out of AWS ECR (current account + region), `dhl <repo>` list Docker Hub tags (`DOCKER_USER`) |
| **kubectl** | `kl` contexts, `kc` current, `ks <ctx>` switch, `kns <ns>` set namespace, `kgp`/`kgn` pods/nodes, `kdp` describe pod, `ktop` pods by memory, `kevent` recent events, `kv` current config, `kd` delete context |
| kubectl helpers | `kpf <svc/x> <local:remote> [ns]` port-forward, `klog <pod> [container] [ns]` follow logs |
| Clusters | `kg <name>` EKS kubeconfig, `gke <cluster> <region>` GKE, `aks <rg> <cluster>` AKS, `ka` edit EKS aws-auth |
| **kind** | `kindc` create, `kindcc <config.yaml>` create from config, `kindl` list, `kindd` delete, `kindload <img>` load image, `kindssh` shell into node, `kindexp` export logs |
| **minikube** | `mk`, `mkc` start, `mks` status, `mkd` delete, `mkssh`, `mkip`, `mkdash`, `mkload <img>`, `mkls` images, `mkenv`/`mkenvu` point docker at minikube and back |
| **AWS** | `awsw` who am I, `awsls` profiles, `awsp <profile>` switch, `awsr` region, `awssso` SSO login |
| AWS profiles | `aws_create`/`aws_login`/`aws_list`/`aws_check`/`aws_clear`: encrypted local credentials via [aws-profile-manager](https://github.com/sidh4u/aws-profile-manager) (optional) |
| **Google Cloud** | `gcauth` login, `gcadc` application-default login, `gcls` configs, `gcuse <cfg>` switch, `gcinfo` active settings, `gcproj <id>` set project |
| **Azure** | `azl` login, `azs` current subscription, `azls` list, `azuse <sub>` switch |
| **Terraform** | `tf`, `tfi` init, `tfu` init -upgrade, `tfp` plan, `tfa` apply, `tfd` destroy, `tff` fmt, `tfv` validate, `tfo` output, `tfs` state list, `tfw` workspaces |
| **Vault** | `vl` log in to a local Vault (`VAULT_ADDR`/`VAULT_TOKEN` from `~/.zshrc.local`) |
| VMware Fusion | `vmlist`, `vmup`/`vmdown`/`vmkill`/`vmsusp <vm>`, `vmip <vm>` |

**Additional Notes (zshrc):**
- Docker aliases need [Docker Desktop](https://www.docker.com/products/docker-desktop/) (installed by the Brewfile).
- `aws_*` profile aliases need [aws-profile-manager](https://github.com/sidh4u/aws-profile-manager) in `~/.bin`.
- VMware aliases need VMware Fusion, available from [Broadcom](https://knowledge.broadcom.com/external/article/315638/download-and-install-vmware-fusion.html).

---

## ✨ Vim Configuration (`vimrc`)

This is not just a `vimrc`: it's a curated setup that turns Vim into a modern, fast editor for quick
edits in the terminal, with plugins, custom key bindings and smart defaults.

Key highlights include:
- **Plugin Management**: [vim-plug](https://github.com/junegunn/vim-plug) installs itself and every plugin
  on first launch, and installs any newly added plugin on the next start.
- **Modern Themes**: `vim-code-dark` (VS Code's Dark Modern colours, italic comments), with `onedark.vim`
  also available.
- **Enhanced Navigation**: NERDTree for file exploration and Undotree for visualizing undo history.
- **Smart Editing**: auto-closing brackets (`vim-autoclose`), automatic `end` insertion (`vim-endwise`),
  Tab completion (`supertab`) and sensible defaults (`vim-sensible`).
- **Git Integration**: the current git branch and full file path in the `lightline` status bar (`vim-gitbranch`).
- **Rainbow Parentheses**: colour-coded nested brackets for better readability.
- **Floating Terminal**: a 90% × 90% terminal inside Vim (`vim-floaterm`).

### `Vim Custom Key Bindings and Toggles`

#### General Key Bindings
- **Toggle NERDTree**: `Ctrl-n` opens or closes the file explorer. It closes after you open a file, and
  the working directory follows its root.
- **Undo Tree**: `Ctrl-b` toggles the Undo Tree, which visualizes the undo history.
- **Floating Terminal**: `` Ctrl-` `` toggles the floating terminal, `Ctrl-d` kills it.
- **Indent Guides**: `Ctrl-i` toggles indent guides. In a terminal `Ctrl-i` is the same key as Tab, so this
  replaces Vim's "jump forward" (`Ctrl-o` still jumps back).
- **Line Numbers**: `Ctrl-l` toggles absolute + relative line numbers.
- **Tab Navigation**: `Shift-←` / `Shift-→` switch to the previous / next tab.

#### Other Features
- **Search Behavior**: case-insensitive unless you type uppercase (`smartcase`), incremental with highlighted
  matches, and the highlight clears automatically when you enter insert mode.
- **Auto Indentation**: smart indentation with `tabstop=2`, `shiftwidth=2` and `expandtab` (spaces, not tabs).
- **Scroll Behavior**: `scrolloff=2` / `sidescrolloff=2` keep 2 lines/columns of context around the cursor.
- **Long Lines**: no wrapping (`nowrap`); matching brackets are highlighted (`showmatch`).
- **File Explorer Behavior**: Vim quits automatically if NERDTree is the last window left.
- **Undo History**: 1000 undo levels and 1000 command-history entries.

#### Rendering and Display
- **Cursor Line**: highlights the current line for better focus.
- **UTF-8 Encoding**: proper rendering of special characters.
- **256 Colours + dark background**: for the theme and status bar.

#### Miscellaneous
- **Backup, Swap and Undo Files**: stored in `/tmp//` so your project folders stay clean. Undo history
  therefore persists across Vim sessions but not across reboots.
- **Visual Bell**: no error sounds.

#### Toggle Summary
| Key Binding | Action |
| ----------- | ------------------------------------- |
| `Ctrl-n` | Toggle NERDTree |
| `Ctrl-b` | Toggle Undo Tree |
| `` Ctrl-` `` | Toggle Floating Terminal |
| `Ctrl-d` | Kill Floating Terminal |
| `Ctrl-i` | Toggle Indent Guides |
| `Ctrl-l` | Toggle Absolute/Relative Line Numbers |
| `Shift-←` | Switch to Previous Tab |
| `Shift-→` | Switch to Next Tab |

Plugin maintenance from the shell: `vpi` install, `vpu` update, `vpc` clean, `vps` status, `vpr` reinstall.

---

## 🎨 VS Code Configuration

A curated VS Code setup that balances productivity, looks and performance: editor settings, custom
key bindings and an extensions list.

**Editor & UI Settings (`settings.json`)**:
- **Clean Interface**: no minimap, no welcome page, no terminal on startup, no extension recommendations
- **Typography**: font size 12, line height 20, ligatures on, phase-blinking cursor
- **Auto-formatting**: format on save, paste and type; tab size 4; word wrap on
- **File Management**: trim trailing whitespace, trim final newlines, ensure one final newline
- **Terminal Integration**: persistent sessions, automatic GPU acceleration, font size 12, no exit alerts
- **Smooth UX**: sticky scroll, smooth scrolling, inline suggestions, breadcrumbs, fewer confirmation dialogs
- **AI assistants**: GitHub Copilot next-edit suggestions; Claude Code opens in the panel

**Custom Keybindings (`keybindings.json`)**:

| Key | Action |
| --- | --- |
| `Cmd+1` … `Cmd+9` | Jump to the first / numbered / last editor tab |
| `Cmd+←` / `Cmd+→` | Previous / next editor tab (or terminal, when the terminal has focus) |
| `Cmd+T` | New terminal |
| `Cmd+M` | Maximize / restore the terminal panel |
| `Cmd+/` | Split terminal |
| `Cmd+,` / `Cmd+.` | Previous / next split terminal pane |
| `Cmd+0` | Reset zoom (`Cmd+=` / `Cmd+-` zoom in / out) |
| `Shift+Enter` | Newline in terminal apps (e.g. Claude Code) instead of submit |

The file also documents VS Code's default sidebar shortcuts (`Cmd+B`, `Cmd+Shift+E/F/D/X`, `Ctrl+Shift+G`).

**Extensions (`extensions.txt`)**: Python (+ Pylance, debugger, environments), Go, rust-analyzer,
Ruby LSP, Bash IDE, Docker + Containers, Kubernetes, Terraform, YAML, XML, Markdown All in One, Code
Spell Checker, Code Runner, Claude Code.

---

## 🧰 Languages

Everything is installed by Homebrew from the [Brewfile](Brewfile), and zshrc already sets the PATH and
environment for each language. Each section has the `brew install` line if you want just that one.

Check everything at once:

```sh
rustc --version; go version; python --version; java -version; ruby -v; node -v; bun -v; php -v; composer -V
```

### 🦀 Rust (rustup)

```sh
brew install rustup                 # keg-only: not linked into $HOMEBREW_PREFIX/bin
exec zsh                            # reload so zshrc puts opt/rustup/bin on PATH
rustup default stable               # download the stable toolchain into ~/.rustup
rustup component add rust-analyzer  # clippy and rustfmt come with the default profile
```

- **zshrc sets**: `RUSTUP_HOME=~/.rustup`, `CARGO_HOME=~/.cargo`, and PATH
  `$HOMEBREW_PREFIX/opt/rustup/bin` (rustup, cargo, rustc) then `~/.cargo/bin` (`cargo install` tools)
- **Verify**: `rustup show`, `cargo --version`, `which cargo` → `…/opt/rustup/bin/cargo`
- **Update**: `brew upgrade rustup` (rustup itself), `rustup update` (toolchains)
- **Moving from the curl installer** (`sh.rustup.rs`): brew's rustup reuses the toolchains in `~/.rustup`,
  so nothing needs downloading again. Then remove the old copy:
  ```sh
  find ~/.cargo/bin -lname rustup -delete && rm -f ~/.cargo/bin/rustup ~/.cargo/env ~/.cargo/env.fish
  ```
  and delete the `. "$HOME/.cargo/env"` line from `~/.zshenv` (and `~/.profile`, if there).
  Don't run `rustup self uninstall`: it deletes `~/.rustup`, which brew's rustup uses too.

### 🐹 Go

```sh
brew install go
```

- **zshrc sets**: `GOPATH=~/go`, `GOBIN=~/go/bin` (on PATH, so `go install` tools are found)
- **Verify**: `go version`, `go env GOPATH GOBIN`
- **Tools**: `go install golang.org/x/tools/gopls@latest` (the VS Code Go extension offers to install the rest)
- **Update**: `brew upgrade go`

### 🐍 Python

```sh
brew install python
```

- **zshrc sets**: PATH `$HOMEBREW_PREFIX/opt/python/libexec/bin`, so plain `python` and `pip` point to
  Homebrew's `python3` / `pip3` instead of the macOS ones
- **Verify**: `python --version`, `which python pip`
- **Packages**: Homebrew's Python is "externally managed", so a global `pip install` is refused on purpose.
  Use a virtualenv per project:
  ```sh
  python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
  ```
  For standalone CLI tools use `brew install <tool>`, or `brew install pipx` then `pipx install <tool>`.
- **Update**: `brew upgrade python`. A new minor version (e.g. 3.15 → 3.16) means recreating venvs.

### ☕ Java (Amazon Corretto 21)

```sh
brew install --cask corretto@21     # asks for your password (installs a system JDK)
```

- **Installs to**: `/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk`
- **zshrc sets**: `JAVA_HOME` to that JDK and puts `$JAVA_HOME/bin` on PATH (only if it exists)
- **Verify**: `java -version` → `Corretto-21…`, `/usr/libexec/java_home -V`
- **Another version**: `brew install --cask corretto@17`, then in `~/.zshrc.local`:
  ```sh
  export JAVA_HOME=$(/usr/libexec/java_home -v 17); path=($JAVA_HOME/bin $path)
  ```
- **Update**: `brew upgrade --cask corretto@21`

### 💎 Ruby

```sh
brew install ruby                   # left unlinked: macOS's own /usr/bin/ruby stays untouched
```

- **zshrc sets**: PATH `$HOMEBREW_PREFIX/opt/ruby/bin` and the newest
  `$HOMEBREW_PREFIX/lib/ruby/gems/<version>/bin` (where `gem install` puts executables)
- **Verify**: `which ruby` → `…/opt/ruby/bin/ruby`, `ruby -v`, `gem env home`
- **Gems**: `gem install bundler`, then `bundle install` per project
- **Update**: `brew upgrade ruby`. Gems are per Ruby version, so after a version bump run `bundle install` again.

### 🟩 Node.js

```sh
brew install node                   # includes npm and npx
```

- **zshrc sets**: nothing extra; `node`, `npm` and global packages live in `$HOMEBREW_PREFIX/bin`
- **Verify**: `node -v`, `npm -v`
- **Global packages**: `npm install -g <pkg>`
- **Update**: `brew upgrade node` (always the current release)

### 🥟 Bun

```sh
brew install bun
```

- **zshrc sets**: PATH `~/.bun/bin`, where `bun add -g <pkg>` installs tools
- **Verify**: `bun -v`
- **Update**: `brew upgrade bun`

### 🐘 PHP + Composer

```sh
brew install composer               # pulls in php as a dependency
```

- **zshrc sets**: PATH `~/.composer/vendor/bin`, where `composer global require <pkg>` installs tools
- **Verify**: `php -v`, `composer -V`
- **Update**: `brew upgrade composer php`

---

## 📦 What `install.sh` does

1. Installs **Homebrew** if it's missing (this also installs the Xcode Command Line Tools).
2. Runs `brew bundle` on the [Brewfile](Brewfile):
   - **core**: zsh plugins, GNU coreutils/sed/awk/tar, jq, yq, gh, wget, tree, xz, iTerm2, VS Code
   - **languages**: python, go, node, bun, ruby, rustup, composer (+ php), Amazon Corretto 21
   - **DevOps / cloud**: Docker Desktop, kubectl, helm, kind, minikube, AWS CLI, Google Cloud CLI,
     Azure CLI, Terraform, Vault
   - **dev utilities**: bash, shellcheck, shfmt, hyperfine
3. **Copies** the configs into place. Identical files are skipped; files that differ are moved to
   `~/.dotfiles-backup/<timestamp>/` first.

   | Repo | Copied to |
   | --- | --- |
   | `zsh/zshrc` | `~/.zshrc` |
   | `vim/vimrc` | `~/.vimrc` |
   | `vscode-settings/settings.json`, `keybindings.json` | `~/Library/Application Support/Code/User/` |

4. Creates `~/.zshrc.local` from [`zsh/zshrc.local.example`](zsh/zshrc.local.example) (only if it doesn't exist).
5. Installs **vim-plug** and all vim plugins.
6. Installs the **VS Code extensions** listed in `vscode-settings/extensions.txt`.

The scripts use the stock macOS `/bin/bash` (3.2), so they work before Homebrew exists.

---

## 🔄 Make it yours

Fork the repo, then keep your fork in sync with your Mac:

| Direction | Command | What it does |
| --- | --- | --- |
| repo → Mac | `./install.sh` | Copies repo files to the Mac (backs up anything different) |
| Mac → repo | `./sync.sh` | Copies your live files into the repo, then shows `git status` |

Edit your configs where they live (`ze` opens `~/.zshrc`, `ve` opens `~/.vimrc`, or use VS Code's
settings UI). When you're happy:

```sh
./sync.sh        # also refreshes extensions.txt, reports Brewfile drift, scans for secrets
git diff         # review
git commit -am "Update dotfiles" && git push
```

`sync.sh` never commits for you, and never overwrites a file with empty output. The tracked files are
listed once, in `file_pairs` in [lib.sh](lib.sh); add a line there to track another file.

### 🔐 Secrets and per-machine settings: `~/.zshrc.local`

`~/.zshrc` sources `~/.zshrc.local` after the PATH settings and before the plugins. It's ignored by git
(`*.local`) and created with `chmod 600`. Put tokens, API keys and machine-specific overrides there,
never in `zshrc`:

```sh
export GITHUB_TOKEN='...'
export JAVA_HOME=$(/usr/libexec/java_home -v 17); path=($JAVA_HOME/bin $path)
```

---

## 🖥️ Terminal: iTerm2

The Brewfile installs [iTerm2](https://iterm2.com). Everything here also works in macOS Terminal. For the
git prompt glyph (`⎇`) and VS Code ligatures, use a font that has them, e.g. JetBrains Mono:
`brew install --cask font-jetbrains-mono`.

## ♻️ Undo / uninstall

Every file `install.sh` replaced is in `~/.dotfiles-backup/<timestamp>/`; copy it back to restore. For
Homebrew packages, `brew bundle cleanup --file=Brewfile` lists what's not in the Brewfile, and
`brew uninstall <name>` removes one.

## 📄 License

[MIT](LICENSE)
