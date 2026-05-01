#!/bin/sh
# Installs gopass before chezmoi reads source state (templates).
# Triggered by hooks.read-source-state.pre in chezmoi config.

type gopass >/dev/null 2>&1 && exit 0

case "$(uname -s)" in
Darwin)
  if ! type brew >/dev/null 2>&1; then
    echo "ERROR: Homebrew not found. Install it first." >&2
    exit 1
  fi
  brew install gopass
  ;;
*)
  echo "ERROR: Unsupported OS for automatic gopass install." >&2
  exit 1
  ;;
esac
