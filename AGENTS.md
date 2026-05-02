# AGENTS.md - Chezmoi Dotfiles Repository

This document provides guidance for agentic coding agents working in this chezmoi-managed dotfiles repository.

## Repository Overview

This is a chezmoi-managed dotfiles repository containing configuration files for various development tools. The source files are stored here and deployed to the home directory via chezmoi.

## Hooks and Automated Dependency Management

This repository uses chezmoi hooks to automate dependency installation. Running `chezmoi apply` triggers these hooks automatically.

### Execution Order

1. **Pre-hook** (`.chezmoi.toml.tmpl` → `.install-prerequisites.sh`): Installs Homebrew if missing, then installs gopass if missing (needed for template secrets)
2. **run_onchange_before** (`run_onchange_before_install-packages.sh.tmpl`): Runs `brew bundle` when `.chezmoidata/packages.yaml` changes — installs all taps, brews, casks, and Mac App Store apps
3. Files are applied to destination
4. **run_once_after** (`run_once_after_install-deps.sh`): Installs Oh My Zsh and clones tmux plugin manager (TPM)

### Adding New Dependencies

Edit `.chezmoidata/packages.yaml` — do NOT install manually with `brew install`.

| Dependency Type | YAML Section | Example |
|-----------------|-------------|---------|
| CLI tools | `packages.darwin.brews` | `- "ripgrep"` |
| GUI applications | `packages.darwin.casks` | `- "ghostty"` |
| Homebrew taps | `packages.darwin.taps` | `- "y3owk1n/tap"` |
| Mac App Store apps | `packages.darwin.mas` | `- { id: 937984704, name: "Amphetamine" }` |

### Template Files (*.tmpl)

Files ending in `.tmpl` use Go template syntax. Some use gopass for secrets:

- `.chezmoi.toml.tmpl` — Chezmoi configuration, defines the pre-hook
- `dot_gitconfig.tmpl` — Git config, uses `{{ gopass "gitconfig/user/email" }}` for secrets
- `run_onchange_before_install-packages.sh.tmpl` — Generates Brewfile from packages.yaml data

## Build/Lint/Test Commands

### Chezmoi Commands

```bash
# Preview changes between source and destination
chezmoi diff

# Apply changes from source to destination
chezmoi apply

# Edit a source file (opens in $EDITOR)
chezmoi edit <file>

# Edit a specific file directly
chezmoi edit ~/.config/nvim/lua/config/options.lua

# Check for potential problems
chezmoi doctor

# View managed files
chezmoi managed

# Re-add modified files
chezmoi re-add

# Pull and apply changes
chezmoi update

# List all managed files with their source paths
chezmoi managed --path-style=source-relative

# See what hooks will run
chezmoi apply -n -v
```

### Neovim/LazyVim Commands

```bash
# Format Lua files using stylua (installed via Mason)
# From within Neovim:
:lua vim.lsp.buf.format()

# Or run stylua directly:
stylua <file.lua>

# LazyVim plugin management (from within Neovim)
:Lazy              " Open Lazy plugin manager
:Lazy sync         " Sync plugins
:Lazy clean        " Clean unused plugins
:Lazy check        " Check for updates
```

### Git Commands

```bash
# Standard git workflow for this repo
git status
git add -A && git commit -m "message"
git push
```

## Code Style Guidelines

### Lua (Neovim Configuration)

**Formatting (stylua.toml):**
- Indent type: Spaces
- Indent width:2 spaces
- Column width: 120 characters

**Imports:**
- Use `require()` for module imports
- LazyVim auto-loads plugins; explicitimports not always needed
- Order: standard libraries first, then plugins, then local modules

**Plugin Specifications:**
```lua
-- Plugin spec pattern
return {
  "author/plugin-name",
  event = "VeryLazy",          -- Use lazy-loading events
  dependencies = { "dep1", "dep2" },
  opts = {
    -- configuration options
  },
  config = function(_, opts)
    -- setup code
  end,
}
```

**Naming Conventions:**
- Use snake_case for variables and functions
- Use PascalCase for table keys that represent classes
- Plugin configs return a table/list of plugin specs

**Comments:**
- Use `--` for single-line comments
- Use `--[[ ]]` for multi-line comments
- Comment sections explaining purpose are encouraged

**Code Organization:**
```lua
-- Structurerecommended for plugin files:
-- 1. Guard clause/early return if needed
-- 2. Return table of plugin specifications
-- 3. Put longer configs in functions
```

### TOML Configuration Files

**Formatting:**
- Use 2 spaces for indentation
- Use `snake_case` for keys
- Use double quotes for string values
- Group related settings under sections

### Shell Scripts (Zsh)

**Formatting:**
- Use 4 spaces for indentation
- Use `snake_case` for function names
- Functions use `function_name() { }` syntax

**Example:**
```zsh
mkcdir() {
    mkdir -p -- "$1" && cd -P -- "$1"
}
```

### YAML Configuration Files

**Formatting:**
- Use 2 spaces for indentation
- Use `snake_case` for keys
- Use `- ` for list items with space after dash

## File Naming Conventions

### Chezmoi Source Files

Files in this repository use chezmoi's naming conventions:
- `dot_<name>` → `.<name>` in destination (e.g., `dot_zshrc` → `.zshrc`)
- `dot_config/<path>` → `.config/<path>` in destination
- `executable_<name>` → executable script in destination
- `private_<name>` → private file (600 permissions)
- `run_once_before_<name>` → runs once before files are applied (e.g., installing Oh My Zsh)
- `run_once_after_<name>` → runs once after files are applied (e.g., cloning TPM)
- `run_onchange_before_<name>` → runs before apply when content changes (e.g., package install)
- `*.tmpl` → Go template file, processed by chezmoi before applying
- `.chezmoidata/*.yaml` → data files available in templates as `.variable`

### Neovim Configuration Files

- `init.lua` - Main entry point
- `lua/config/` - Core configuration (options, keymaps, autocmds, lazy)
- `lua/plugins/` - Plugin specifications (each file returns a table)
- Plugin files are loaded automatically by Lazy.nvim

## Important Patterns

### Adding New Dotfiles

```bash
# Add a new file to chezmoi management
chezmoi add ~/.config/some-app/config

# The file will be created as:
# dot_config/some-app/config (forfiles in ~/.config/)
```

### Editing Configuration Files

```bash
# Always edit the SOURCE file, not the destination
chezmoi edit ~/.config/nvim/lua/config/options.lua

# Or edit directly in the source directory:
# ~/.local/share/chezmoi/dot_config/nvim/lua/config/options.lua
```

### Modifying LazyVim Settings

- Override options in `lua/config/options.lua`
- Add keymaps in `lua/config/keymaps.lua`
- Add autocmds in `lua/config/autocmds.lua`
- Add/modify plugins in `lua/plugins/*.lua`

### Plugin Management

Plugins are managed by Lazy.nvim:
- New plugins go in `lua/plugins/` directory
- Each file returns a table of plugin specs
- Use `{ import = "lazyvim.plugins.extras..." }` for LazyVim extras

## Error Handling

### Lua Error Handling

- Use `pcall()` for potentially failing operations
- LazyVim handles most plugin errors gracefully
- Check `:messages` in Neovim for error details

### Chezmoi Troubleshooting

```bash
# Check for issues
chezmoi doctor

# Verbose output
chezmoi apply -v

# Dry run to see what would change
chezmoi apply -n
```

## Development Tools

### Tools Managed by mise

The `dot_config/mise/config.toml` manages tool versions:
- go:1.24.13
- node:24.14.0
- python:3.14.3

### Oh My Zsh Plugins

Active plugins configured in `dot_zshrc`:
- `aliases` — alias management
- `git` — git aliases and functions
- `mise` — mise version manager integration
- `zoxide` — smart directory jumping
- `gpg-agent` — GPG agent management
- `tmux` — tmux integration

### Custom Zsh Functions

Defined in `dot_config/ohmyzsh/func.zsh` and `dot_config/ohmyzsh/plugins/zoxide/zoxide.plugin.zsh`:

| Function | Description |
|----------|-------------|
| `srz` | Reload zsh configuration |
| `mkcdir` | Create directory and cd into it |
| `zr` | Fuzzy jump to recent zoxide directory |
| `zp` | Fuzzy jump to projects directory |
| `zw` | Fuzzy jump to works directory |
| `zs` | Fuzzy jump to sandbox directory |

### Shell Aliases

Defined in `dot_zshrc`:

| Alias | Command |
|-------|---------|
| `v` | `nvim` |
| `p` | `pi` |
| `o` | `opencode` |
| `c` | `claude` |

## Key Configuration Locations

| Source Path | Destination | Description |
|-------------|-------------|-------------|
| `dot_config/nvim/` | `~/.config/nvim/` | Neovim (LazyVim) configuration |
| `dot_config/tmux/` | `~/.config/tmux/` | Tmux terminal multiplexer + TPM |
| `dot_config/neru/` | `~/.config/neru/` | Keyboard/mouse navigation utility |
| `dot_config/aerospace/` | `~/.config/aerospace/` | AeroSpace window manager |
| `dot_config/ghostty/` | `~/.config/ghostty/` | Ghostty terminal emulator |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | mise version manager |
| `dot_config/ohmyzsh/` | `~/.config/ohmyzsh/` | Custom Oh My Zsh plugins/functions |
| `dot_zshrc` | `~/.zshrc` | Zsh configuration |
| `dot_zprofile` | `~/.zprofile` | Zsh profile |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Git config (templated, uses gopass) |
| `.chezmoidata/packages.yaml` | (data only) | Homebrew dependency manifest |

## Testing Configuration Changes

After modifying configuration files:

1. Apply changes: `chezmoi apply`
2. Reload the affected application
3. For Neovim: restart or run `:Lazy sync`
4. For zsh: run `source ~/.zshrc` or `srz` function
5. For tmux: restart tmux or run `tmux source ~/.config/tmux/tmux.conf`

## Notes

- This repository manages dotfiles for macOS
- Homebrew is auto-installed by the pre-hook if missing
- Neovim configuration is based on LazyVim
- Window management uses AeroSpace
- Terminal is Ghostty
- Version management uses mise
- Tmux is configured with TPM (Tmux Plugin Manager)
- Neru provides keyboard/mouse navigation (from y3owk1n/tap)
- gopass is used for secrets in template files
- All Homebrew dependencies are managed via `.chezmoidata/packages.yaml`