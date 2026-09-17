# Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/) for macOS development environment.

## Overview

This repository manages configuration for:

- **Neovim** — LazyVim with Herdr navigation and custom plugin overrides
- **Zsh** — Oh My Zsh, custom functions, and tool aliases
- **Ghostty** — terminal appearance and key bindings
- **AeroSpace** — tiling window and workspace management
- **Neru** — keyboard-driven hints, mouse grids, and scrolling
- **Kanata and Kanata Tray** — keyboard layers, home-row modifiers, chords, and tray startup
- **skhd.zig** — Hyper-key application shortcuts
- **Herdr** — agent workspace UI and Neovim integration
- **mise** — Bun, Go, Java, Node.js, Pi, Python, and Rust versions
- **Git** — machine-specific signing for `normal` and `server` machines

## Prerequisites

- macOS
- Xcode Command Line Tools
- A YubiKey containing the GPG encryption key for the gopass store
- GitHub SSH access to the private gopass repository
- An active Mac App Store session for packages installed with `mas`

## Installation

### 1. Install Xcode Command Line Tools

```bash
xcode-select --install
```

### 2. Initialize chezmoi and apply non-secret configuration

```bash
/bin/bash -c "$(curl -fsSL https://www.chezmoi.io/get)" -- \
  init --apply --skip-secrets https://github.com/azharaiz/dotfiles.git
```

Choose `normal` for a workstation that signs commits and tags with the YubiKey, or `server` to disable Git signing.

This initial apply will:

- Install Homebrew if it is missing
- Install the gopass CLI without initializing its password store
- Install Oh My Zsh
- Install the configured Homebrew packages, casks, and Mac App Store apps
- Skip `dot_gitconfig.tmpl` until its gopass entries are available

### 3. Clone and verify the gopass store

Open a new terminal before continuing so the Homebrew and GPG environment applied in step 2 is loaded.
Connect the YubiKey, then clone the encrypted password store:

```bash
gopass clone --crypto gpgcli [gopass repo]
```

Verify the Git email entry can be decrypted:

```bash
gopass show --password gitconfig/user/email >/dev/null
```

On a `normal` machine, also verify the signing-key entry:

```bash
gopass show --password gitconfig/user/signingKey >/dev/null
```

These commands may require the YubiKey PIN or touch.

### 4. Apply the complete configuration

```bash
chezmoi apply
```

This final apply renders `dot_gitconfig.tmpl` with the gopass values. A `normal` machine enables commit and tag signing; a `server` disables both.

## Post-Installation

### Neovim

Launch neovim to install plugins:

```bash
nvim
```

Lazy.nvim will automatically install all plugins.

### mise

Install configured tool versions:

```bash
mise install
```

### Keyboard services

Homebrew installs `skhd.zig` and `kanata-tray` during the initial apply. Register and verify the skhd.zig service after installation:

```bash
skhd --start-service
skhd --status
```

Grant skhd Accessibility and Input Monitoring access when macOS prompts. The Kanata Tray preset expects its Kanata executable at `~/.local/bin/kanata-tray-kanata`; provision that executable separately before using preset autorun.

## Usage

### Editing Configuration Files

```bash
# Edit a source file
chezmoi edit ~/.config/nvim/lua/config/options.lua

# Or edit directly in the source directory
chezmoi cd
# Then use your editor
```

### Applying Changes

```bash
# Preview changes
chezmoi diff

# Apply changes
chezmoi apply
```

### Adding New Files

```bash
chezmoi add ~/.config/new-app/config
```

### Syncing with Remote

```bash
chezmoi update
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl            # Chezmoi config (prerequisites pre-hook)
├── .chezmoidata/
│   └── packages.yaml             # Homebrew dependency manifest
├── .chezmoiignore
├── .install-prerequisites.sh     # Pre-hook: installs Homebrew + gopass CLI
├── run_onchange_before_install-packages.sh.tmpl  # Hook: brew bundle
├── run_once_after_install-deps.sh  # Hook: installs Oh My Zsh
├── dot_gitconfig.tmpl            # Git config (gopass secrets)
├── dot_zshrc                     # Zsh configuration
├── dot_zprofile                  # Zsh profile
├── dot_config/
│   ├── aerospace/                # AeroSpace window manager
│   ├── ghostty/                  # Ghostty terminal
│   ├── herdr/                    # Herdr UI, keys, and plugins
│   ├── kanata/                   # Keyboard remapping
│   ├── kanata-tray/              # Kanata tray preset
│   ├── mise/                     # Runtime versions
│   ├── neru/                     # Keyboard and mouse navigation
│   ├── nvim/                     # LazyVim and Herdr navigation
│   ├── ohmyzsh/                  # Custom Oh My Zsh files
│   └── skhd/                     # skhd.zig Hyper-key shortcuts
├── AGENTS.md                     # Guide for coding agents
└── README.md
```

## Tools & Versions

Managed by mise in `dot_config/mise/config.toml`:

| Tool   | Version  |
| ------ | -------- |
| Bun    | `latest` |
| Go     | `1.24.13` |
| Java   | `17.0.2` |
| Node.js | `24.14.0` |
| Pi     | `latest` |
| Python | `3.14.3` |
| Rust   | `latest` |

## Key Bindings

### AeroSpace

| Key | Action |
| --- | --- |
| `Alt + /` | Cycle tiled layout orientation |
| `Alt + ,` | Cycle accordion layout orientation |
| `Alt + h/j/k/l` | Focus left/down/up/right |
| `Alt + Shift + h/j/k/l` | Move window left/down/up/right |
| `Alt + -/=` | Resize the focused window |
| `Alt + a/s/d/f/g/z/x/c/v/y/u/i/n/m/o/p` | Switch workspace |
| `Alt + Shift + a/s/d/f/g/z/x/c/v/y/u/i/n/m/o/p` | Move window to workspace |
| `Alt + Tab` | Switch to the previous workspace |
| `Alt + Shift + Tab` | Move workspace to the next monitor |
| `Alt + Shift + ;` | Enter service mode |

Workspaces `O` and `P` are assigned to the secondary monitor. Slack, Chrome, Postman, and DBeaver are automatically moved to `N`, `M`, `I`, and `U`.

### Neru

On macOS, `Primary` is the Command key.

| Key | Action |
| --- | --- |
| `Primary + Shift + Space` | Show accessibility-tree hints |
| `Primary + Shift + G` | Open mouse grid |
| `Primary + Shift + C` | Open recursive mouse grid |
| `Primary + Shift + S` | Enter scroll mode |

### Kanata

| Input | Action |
| --- | --- |
| Hold `Space` | Hyper modifier (`Ctrl + Alt + Cmd + Shift`) |
| Tap/Hold left Command | Tab / left navigation layer |
| Tap/Hold right Command | Backspace / right media and symbol layer |
| Hold `a/s/d/f` | Left `Ctrl/Alt/Cmd/Shift` |
| Hold `j/k/l/;` | Right `Shift/Cmd/Alt/Ctrl` |
| Chord `j+k` | Backspace |
| Chord `q+w` | Escape |
| Chord `f+j` | Enter |

### skhd.zig

These shortcuts use Kanata's Hyper modifier.

| Key | Action |
| --- | --- |
| `Hyper + Return` | Open Ghostty |
| `Hyper + l` | Open Firefox |
| `Hyper + a` | Open Slack |
| `Hyper + s` | Open Google Chrome |
| `Hyper + d` | Open Ghostty |

### Herdr and Neovim

| Key | Action |
| --- | --- |
| `Ctrl + h/j/k/l` | Navigate between Neovim splits and Herdr panes |
| `prefix + e` | Toggle the Neovim sidebar |
| `prefix + o` | Open a file from agent output |
| `prefix + a` / `prefix + Shift + a` | Focus next/previous agent |
| `prefix + Alt + 1..9` | Focus agent by number |
| `prefix + Shift + 1..9` | Switch Herdr workspace |
| `Shift + j/k` in navigate mode | Move between Herdr workspaces |

The `vim-tmux-navigator` Neovim plugin is intentionally retained as part of the `vim-herdr-navigation` integration; tmux itself is not part of the documented toolset.

### Ghostty

| Key | Action |
| --- | --- |
| `Ctrl + Z` | Close surface |

## Custom Zsh Functions

| Function | Description                           |
| -------- | ------------------------------------- |
| `srz`    | Reload zsh configuration              |
| `mkcdir` | Create directory and cd into it       |
| `zr`     | Fuzzy jump to recent zoxide directory |
| `zp`     | Fuzzy jump to projects directory      |
| `zw`     | Fuzzy jump to works directory         |
| `zs`     | Fuzzy jump to sandbox directory       |

## Shell Aliases

| Alias | Command |
| --- | --- |
| `v` | `nvim` |
| `p` | `omp` |
| `pw` | `omp --profile work` |
| `o` | `opencode` |
| `c` | `claude` |
| `lg` | `lazygit` |
| `h` | `herdr` |
| `hw` | `herdr session attach flip` |

## Troubleshooting

### Chezmoi Issues

```bash
# Check for problems
chezmoi doctor

# Verbose apply
chezmoi apply -v

# Dry run
chezmoi apply -n
```

### Gopass Issues

If chezmoi reports that the password store is not initialized, complete installation step 3 and rerun:

```bash
chezmoi apply
```

Inspect the store and YubiKey when decryption fails:

```bash
gopass mounts
gpg --card-status
```

### Neovim Issues

```bash
# Check health
nvim +checkhealth

# View messages
:messages
```

## Resources

- [chezmoi documentation](https://www.chezmoi.io/)
- [LazyVim documentation](https://lazyvim.github.io/)
- [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide)
- [Ghostty documentation](https://ghostty.org/docs)
- [Kanata](https://github.com/jtroo/kanata)
- [Neru](https://github.com/y3owk1n/neru)
- [skhd.zig](https://github.com/jackielii/skhd.zig)
- [mise documentation](https://mise.jdx.dev/)
