# Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/) for macOS development environment.

## Overview

This repository contains configuration files for:

- **Neovim** - LazyVim-based editor configuration
- **Zsh** - Oh My Zsh with custom plugins
- **Ghostty** - Terminal emulator
- **AeroSpace** - Tiling window manager
- **Tmux** - Terminal multiplexer with TPM
- **Neru** - Keyboard/mouse navigation utility
- **mise** - Version manager for Go, Node, Python


## Prerequisites

- macOS
- Xcode Command Line Tools

## Installation

### 1. Install Xcode Command Line Tools

```bash
xcode-select --install
```

### 2. Install chezmoi

```bash
/bin/bash -c "$(curl -fsSL https://www.chezmoi.io/get)" -- init --apply https://github.com/azharaiz/dotfiles.git
```

This will automatically:
- Install Homebrew (if missing)
- Install gopass (password manager for template secrets)
- Install Oh My Zsh
- Install all Homebrew packages, casks, and Mac App Store apps
- Clone tmux plugin manager (TPM)

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

### Tmux

Press `prefix + I` inside tmux to install TPM plugins.

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
├── .install-prerequisites.sh     # Pre-hook: installs Homebrew + gopass
├── run_onchange_before_install-packages.sh.tmpl  # Hook: brew bundle
├── run_once_after_install-deps.sh  # Hook: installs Oh My Zsh + TPM
├── dot_gitconfig.tmpl            # Git config (gopass secrets)
├── dot_zshrc                     # Zsh configuration
├── dot_zprofile                  # Zsh profile
├── dot_config/
│   ├── nvim/                     # LazyVim configuration
│   │   ├── init.lua
│   │   ├── lua/
│   │   │   ├── config/
│   │   │   └── plugins/
│   │   └── stylua.toml
│   ├── tmux/                     # Tmux + TPM config
│   ├── neru/                     # Keyboard/mouse navigation
│   ├── aerospace/                # Window manager config
│   ├── ghostty/                  # Terminal config
│   ├── mise/                     # Version manager config
│   └── ohmyzsh/                  # Custom Oh My Zsh files
├── AGENTS.md                     # Guide for coding agents
└── README.md
```

## Tools & Versions

Managed by mise (see `dot_config/mise/config.toml`):

| Tool | Version |
|------|---------|
| Go | 1.24.13 |
| Node | 24.14.0 |
| Python | 3.14.3 |

## Key Bindings

### AeroSpace

| Key | Action |
|-----|--------|
| `Alt + h/j/k/l` | Focus left/down/up/right |
| `Alt + Shift + h/j/k/l` | Move window left/down/up/right |
| `Alt + a/s/d/f/g/z/x/c/v` | Switch to workspace |
| `Alt + Shift + a/s/d/f/g/z/x/c/v` | Move window to workspace |
| `Alt + Tab` | Switch between workspaces |
| `Alt + Shift + Tab` | Move workspace to monitor |

### Ghostty

| Key | Action |
|-----|--------|
| `Ctrl + Z` | Close surface |

## Custom Zsh Functions

| Function | Description |
|----------|-------------|
| `srz` | Reload zsh configuration |
| `mkcdir` | Create directory and cd into it |
| `zr` | Fuzzy jump to recent zoxide directory |
| `zp` | Fuzzy jump to projects directory |
| `zw` | Fuzzy jump to works directory |
| `zs` | Fuzzy jump to sandbox directory |

## Shell Aliases

| Alias | Command |
|-------|---------|
| `v` | `nvim` |
| `p` | `pi` |
| `o` | `opencode` |
| `c` | `claude` |

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
- [mise documentation](https://mise.jdx.dev/)
- [tmux documentation](https://github.com/tmux/tmux/wiki)
- [TPM - Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)