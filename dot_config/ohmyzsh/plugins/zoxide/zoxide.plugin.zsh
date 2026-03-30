if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd ${ZOXIDE_CMD_OVERRIDE:-z} zsh)"
else
  echo '[oh-my-zsh] zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi

zr() {
  local dir
  dir=$(zoxide query -l -s | sort -k1 -r | awk '{print $2}' | head -50 | fzf)
  [ -n "$dir" ] && z "$dir"
}

zp() {
  local dir
  dir=$(zoxide query -l | grep -i projects | fzf)
  [ -n "$dir" ] && z "$dir"
}

zw() {
  local dir
  dir=$(zoxide query -l | grep -i works | fzf)
  [ -n "$dir" ] && z "$dir"
}

zs() {
  local dir
  dir=$(zoxide query -l | grep -i sandbox | fzf)
  [ -n "$dir" ] && z "$dir"
}
