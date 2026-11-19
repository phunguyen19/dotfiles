#!/usr/bin/env bash
# Symlink live config into this repo. Safe to re-run.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

links=(
  "zsh/.zshrc:.zshrc"
  "p10k/.p10k.zsh:.p10k.zsh"
  "tmux/.tmux.conf:.tmux.conf"
  "nvim:.config/nvim"
  "alacritty:.config/alacritty"
)

for entry in "${links[@]}"; do
  src="$repo/${entry%%:*}"
  dst="$HOME/${entry##*:}"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok      $dst"
    continue
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$(dirname "$backup/${entry##*:}")"
    mv "$dst" "$backup/${entry##*:}"
    echo "backup  $dst -> $backup/${entry##*:}"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "link    $dst -> $src"
done
