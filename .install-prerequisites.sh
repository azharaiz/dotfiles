#!/bin/sh
# Installs Homebrew and the gopass CLI before chezmoi reads source state.
# Triggered by hooks.read-source-state.pre in chezmoi config.
# The password store is cloned separately after the initial --skip-secrets apply.
#
# Execution order:
#   1. Install Homebrew (if missing)
#   2. Install the gopass CLI (if missing)

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
        echo "Installing gopass CLI..."
        brew install gopass
        echo "Clone the gopass store before applying secret-backed templates."
    fi
    ;;
*)
    echo "ERROR: Unsupported OS for automatic prerequisite install." >&2
    exit 1
    ;;
esac
