# Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/) for macOS development environment.

## Overview

This repository contains configuration files for:

- **Neovim** - LazyVim-based editor configuration
- **Zsh** - Oh My Zsh with custom plugins
- **Ghostty** - Terminal emulator
- **AeroSpace** - Tiling window manager
- **mise** - Version manager for Go, Node, Python


## Prerequisites

- macOS
- Homebrew
- Oh My Zsh
## Installation

### 1. Install Xcode Command Line Tools

```bash
xcode-select --install
```

### 2. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 4. Install chezmoi

```bash
brew install chezmoi
```

### 5. Initialize chezmoi

```bash
chezmoi init https://github.com/azharaiz/dotfiles.git
chezmoi apply
```

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

### Reload Shell

```bash
source ~/.zshrc
```

Or use the custom function:

```bash
srz
```

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
├── dot_config/
│   ├── nvim/                 # LazyVim configuration
│   │   ├── init.lua
│   │   ├── lua/
│   │   │   ├── config/
│   │   │   └── plugins/
│   │   └── stylua.toml
│   ├── aerospace/            # Window manager config
│   ├── ghostty/              # Terminal config
│   ├── mise/                 # Version manager config
│   └── ohmyzsh/              # Custom Oh My Zsh files
├── dot_zshrc                 # Zsh configuration
├── dot_zprofile              # Zsh profile
└── AGENTS.md                 # Guide for coding agents
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
:nvimg :messages
```

## Resources

- [chezmoi documentation](https://www.chezmoi.io/)
- [LazyVim documentation](https://lazyvim.github.io/)
- [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide)
- [mise documentation](https://mise.jdx.dev/)