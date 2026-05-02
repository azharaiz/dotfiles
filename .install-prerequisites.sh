#!/bin/sh
# Installs Homebrew and gopass before chezmoi reads source state (templates).
# Triggered by hooks.read-source-state.pre in chezmoi config.
#
# Execution order:
#   1. Install Homebrew (if missing)
#   2. Install gopass (if missing) — needed for template secret decryption

case "$(uname -s)" in
Darwin)
    if ! type brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to PATH for this session (Apple Silicon vs Intel)
        if [ -f /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -f /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    if ! type gopass >/dev/null 2>&1; then
        echo "Installing gopass..."
        brew install gopass
    fi
    ;;
*)
    echo "ERROR: Unsupported OS for automatic prerequisite install." >&2
    exit 1
    ;;
esac
