# AGENTS.md - Chezmoi Dotfiles Repository

This document provides guidance for agentic coding agents working in this chezmoi-managed dotfiles repository.

## Repository Overview

This is a chezmoi-managed dotfiles repository containing configuration files for various development tools. The source files are stored here and deployed to the home directory via chezmoi.

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
- Use 2 spaces for indentation
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

## Key Configuration Locations

| Source Path | Destination |
|-------------|-------------|
| `dot_config/nvim/` | `~/.config/nvim/` |
| `dot_zshrc` | `~/.zshrc` |
| `dot_zprofile` | `~/.zprofile` |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `dot_config/aerospace/aerospace.toml` | `~/.config/aerospace/aerospace.toml` |

## Testing Configuration Changes

After modifying configuration files:

1. Apply changes: `chezmoi apply`
2. Reload the affected application
3. For Neovim: restart or run `:Lazy sync`
4. For zsh: run `source ~/.zshrc` or `srz` function

## Notes

- This repository manages dotfiles for macOS
- Configuration assumes Homebrew is installed
- Neovim configuration is based on LazyVim
- Window management uses AeroSpace
- Terminal is Ghostty
- Version management uses mise