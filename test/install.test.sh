#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
home="$(mktemp -d)"
trap 'rm -rf "$home"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

mkdir -p "$home/.config/nvim"
echo old > "$home/.zshrc"
echo old > "$home/.config/nvim/init.lua"

HOME="$home" "$repo/install.sh" >/dev/null

for pair in zsh/.zshrc:.zshrc p10k/.p10k.zsh:.p10k.zsh tmux/.tmux.conf:.tmux.conf \
            nvim:.config/nvim alacritty:.config/alacritty; do
  dst="$home/${pair##*:}"
  [[ -L "$dst" ]] || fail "$dst is not a symlink"
  [[ "$(readlink "$dst")" == "$repo/${pair%%:*}" ]] || fail "$dst points to $(readlink "$dst")"
done

backup="$(echo "$home"/.dotfiles-backup/*)"
[[ "$(cat "$backup/.zshrc")" == old ]] || fail ".zshrc not backed up"
[[ "$(cat "$backup/.config/nvim/init.lua")" == old ]] || fail "nvim dir not backed up"

out="$(HOME="$home" "$repo/install.sh")"
[[ "$out" != *backup* && "$out" != *link* ]] || fail "second run not a no-op: $out"

echo "PASS"
