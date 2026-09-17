# AGENTS.md - Chezmoi Dotfiles Repository

Guidance for coding agents working in this macOS chezmoi source repository.

## Repository Scope

Chezmoi source files in this repository are rendered or copied into the user's home directory. Edit source files here, never deployed files under `~/.config` or `~/.zshrc`.

Managed configuration includes:

- AeroSpace window and workspace management
- Ghostty terminal configuration
- Herdr agent workspace UI and Neovim integration
- Kanata keyboard remapping and Kanata Tray presets
- mise runtime versions
- Neru keyboard and mouse navigation
- LazyVim-based Neovim configuration
- Oh My Zsh plugins and helper functions
- skhd Hyper-key application shortcuts
- Machine-specific Git configuration

Tmux is not part of the user-facing toolset. The `christoomey/vim-tmux-navigator` plugin is intentionally retained because `vim-herdr-navigation` uses it for navigation between Neovim splits and Herdr panes.

## Bootstrap and Secrets

Initial setup is intentionally staged:

1. Run `chezmoi init --apply --skip-secrets` so Homebrew, gopass, packages, and non-secret dotfiles can be installed without an initialized password store.
2. Clone the gopass store with the YubiKey connected.
3. Verify `gitconfig/user/email`; on a `normal` machine also verify `gitconfig/user/signingKey`.
4. Run `chezmoi apply` to render the complete Git configuration.

The `.chezmoi.toml.tmpl` prompt stores one of two `machineType` values:

| Type | Git behavior |
| --- | --- |
| `normal` | Uses `gpg`, resolves the signing key from gopass, and signs commits and tags |
| `server` | Omits the signing key and explicitly disables commit and tag signing |

Both machine types resolve the Git email from `gitconfig/user/email` in gopass.

## Hooks and Dependency Management

`chezmoi apply` uses this order:

1. `hooks.read-source-state.pre` runs `.install-prerequisites.sh`.
2. The prerequisite hook installs Homebrew and the gopass CLI if missing. It does not initialize or clone the password store.
3. `run_onchange_before_install-packages.sh.tmpl` renders a Brewfile from `.chezmoidata/packages.yaml` and runs `brew bundle`.
4. Managed files are applied.
5. `run_once_after_install-deps.sh` installs Oh My Zsh when absent.

The package hook resolves Homebrew from `/opt/homebrew/bin/brew` or `/usr/local/bin/brew`; environment changes made inside the prerequisite hook cannot propagate to chezmoi.

### Adding Dependencies

Edit `.chezmoidata/packages.yaml`; do not add ad hoc `brew install` calls.

| Dependency type | YAML section | Example |
| --- | --- | --- |
| Homebrew tap | `packages.darwin.taps` | `- "y3owk1n/tap"` |
| CLI/formula | `packages.darwin.brews` | `- "ripgrep"` |
| GUI application | `packages.darwin.casks` | `- "ghostty"` |
| Mac App Store application | `packages.darwin.mas` | `- { id: 937984704, name: "Amphetamine" }` |

Exceptions and current gaps:

- gopass is installed by `.install-prerequisites.sh` because templates need it before package application.
- The repository manages `skhd` and `kanata-tray` configuration, but their binaries are not provisioned by `.chezmoidata/packages.yaml`.

## Key Paths

| Source path | Destination or role |
| --- | --- |
| `.chezmoi.toml.tmpl` | Generates chezmoi config, machine type, and pre-hook |
| `.chezmoidata/packages.yaml` | Homebrew, cask, tap, and Mac App Store manifest |
| `.install-prerequisites.sh` | Installs Homebrew and gopass CLI |
| `run_onchange_before_install-packages.sh.tmpl` | Generates and applies Brewfile |
| `run_once_after_install-deps.sh` | Installs Oh My Zsh |
| `dot_gitconfig.tmpl` | `~/.gitconfig`, with machine-specific signing |
| `dot_zshrc` | `~/.zshrc` |
| `dot_zprofile` | `~/.zprofile` |
| `dot_config/aerospace/` | `~/.config/aerospace/` |
| `dot_config/ghostty/` | `~/.config/ghostty/` |
| `dot_config/herdr/` | `~/.config/herdr/` |
| `dot_config/kanata/` | `~/.config/kanata/` |
| `dot_config/kanata-tray/` | `~/.config/kanata-tray/` |
| `dot_config/mise/` | `~/.config/mise/` |
| `dot_config/neru/` | `~/.config/neru/` |
| `dot_config/nvim/` | `~/.config/nvim/` |
| `dot_config/ohmyzsh/` | `~/.config/ohmyzsh/` |
| `dot_config/skhd/` | `~/.config/skhd/` |

`.chezmoiignore` excludes `README.md`, `AGENTS.md`, `dot_config/nvim/lazy-lock.json`, and the Kanata Tray last-run state from deployment.

## Current Tool Configuration

### mise

`dot_config/mise/config.toml` manages:

| Tool | Version |
| --- | --- |
| Bun | `latest` |
| Go | `1.24.13` |
| Java | `17.0.2` |
| Node.js | `24.14.0` |
| Pi | `latest` |
| Python | `3.14.3` |
| Rust | `latest` |

### Zsh

Active Oh My Zsh plugins:

- `aliases`
- `git`
- `mise`
- `zoxide`
- `gpg-agent`

Aliases in `dot_zshrc`:

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

Custom functions:

- `srz` reloads `~/.zshrc`.
- `mkcdir` creates a directory and enters it.
- `zr`, `zp`, `zw`, and `zs` query zoxide through fzf.

### Neovim

- LazyVim version 8 configuration.
- Language extras: Docker, Git, Go, JSON, Markdown, Tailwind, Terraform, TOML, TypeScript, and YAML.
- Formatting/linting extras: Prettier and ESLint.
- `herdr-nvim` uses `<leader>h`.
- `vim-herdr-navigation` is loaded from `dot_config/nvim/lua/config/keymaps.lua`.
- `herdr-navigator.lua` and `vim-tmux-navigator` are required for Herdr navigation and must not be removed as stale tmux configuration.
- Bufferline and Flash are disabled.
- Sidekick is currently disabled; its tmux multiplexer override has been removed.
- `lazy-lock.json` is tracked in the source repository but ignored by chezmoi deployment.

### Keyboard and Navigation

- Holding Space in Kanata produces Hyper (`Ctrl + Alt + Cmd + Shift`).
- skhd maps Hyper shortcuts to Ghostty, Firefox, Slack, and Google Chrome.
- Neru entry bindings use `Primary+Shift+Space/G/C/S`.
- Herdr and Neovim share `Ctrl+h/j/k/l` navigation through `vim-herdr-navigation`.
- AeroSpace owns `Alt` workspace, focus, move, resize, and service-mode bindings.

## Editing Conventions

### Chezmoi

- Use chezmoi source names: `dot_<name>`, `dot_config/<path>`, `private_<name>`, and `*.tmpl`.
- Go-template files must remain valid both before and after rendering.
- Keep secret lookups out of the initial `--skip-secrets` bootstrap path.
- Migrate all machine-type branches together; do not leave implicit signing behavior.

### Lua

- Format with the repository's `stylua.toml`: 2-space indentation and 120-column width.
- Plugin files under `lua/plugins/` return Lazy.nvim specs.
- Prefer `opts` over custom `config` functions when the plugin supports it.
- Keep Herdr navigation loading in `lua/config/keymaps.lua`; LazyVim overwrites the relevant mappings during `VeryLazy`.

### Shell

- Use 4-space indentation in shell functions and scripts.
- Use `set -euo pipefail` for Bash hooks.
- Hooks must be idempotent.
- Do not assume PATH changes in one hook propagate to another process.

### TOML and YAML

- Use 2-space indentation for new TOML.
- Use double-quoted TOML strings unless the existing file consistently uses another style.
- Use 2-space YAML indentation and `- ` list items.

## Commands and Verification

### Chezmoi

```bash
chezmoi diff
chezmoi apply
chezmoi doctor
chezmoi managed --path-style=source-relative
chezmoi update
```

Hooks run while chezmoi reads source state, including during some dry-run operations. Do not run repository-wide apply commands merely to validate a template.

### Targeted checks

```bash
# Shell syntax
sh -n .install-prerequisites.sh
bash -n run_once_after_install-deps.sh
zsh -n dot_zshrc

# Rendered package-hook syntax
chezmoi execute-template --file run_onchange_before_install-packages.sh.tmpl | bash -n

# JSON
jq empty dot_config/nvim/lazy-lock.json

# Lua plugin spec
nvim --headless -u NONE \
  -c "lua assert(type(dofile('dot_config/nvim/lua/plugins/herdr-navigator.lua')) == 'table')" \
  -c qa
```

For configuration changes, verify the actual affected application or command. Do not expose gopass output in logs.