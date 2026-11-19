# dotfiles

zsh, powerlevel10k, tmux, neovim and alacritty config.

## Install

```sh
git clone git@github.com:phunguyen19/dotfiles.git ~/workspaces/personal/dotfiles
~/workspaces/personal/dotfiles/install.sh
```

`install.sh` symlinks each config into place. Anything already there is moved to `~/.dotfiles-backup/<timestamp>/`. Re-running is a no-op.

| Repo path            | Linked to             |
| -------------------- | --------------------- |
| `zsh/.zshrc`         | `~/.zshrc`            |
| `p10k/.p10k.zsh`     | `~/.p10k.zsh`         |
| `tmux/.tmux.conf`    | `~/.tmux.conf`        |
| `nvim/`              | `~/.config/nvim`      |
| `alacritty/`         | `~/.config/alacritty` |

tmux plugins are installed by TPM into `~/.tmux/plugins` and are not tracked.
nvim reads machine-specific settings from `nvim/lua/rpn/local.lua` (gitignored, see `local.example.lua`).

## Test

```sh
test/install.test.sh
```
