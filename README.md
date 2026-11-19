# dotfiles

zsh, powerlevel10k, tmux, neovim and alacritty config for macOS.

Live config is symlinked into this repo, so editing a file here changes the machine immediately. Commit and push to share it; `git pull` on other machines to receive it.

| Repo path         | Linked to             |
| ----------------- | --------------------- |
| `zsh/.zshrc`      | `~/.zshrc`            |
| `p10k/.p10k.zsh`  | `~/.p10k.zsh`         |
| `tmux/.tmux.conf` | `~/.tmux.conf`        |
| `nvim/`           | `~/.config/nvim`      |
| `alacritty/`      | `~/.config/alacritty` |

## Shared vs machine-specific

The repo is public and holds only what every machine shares. Anything that differs per machine, and every secret, goes in a gitignored local file:

| File                        | Template                          | Holds                                                         |
| --------------------------- | --------------------------------- | ------------------------------------------------------------- |
| `zsh/local.zsh`             | `zsh/local.example.zsh`           | languages (nvm, bun, ...), tools, Docker, work env, tokens    |
| `nvim/lua/rpn/local.lua`    | `nvim/lua/rpn/local.example.lua`  | Obsidian vaults                                               |

Installers (nvm, bun, Docker Desktop, opencode, ...) append to `~/.zshrc`, which is a symlink to the shared file. After installing a tool, move its lines from `zsh/.zshrc` into `zsh/local.zsh` before committing; `git diff zsh/.zshrc` shows them.

`.zshrc` sources `zsh/local.zsh` last, so it can override shared settings. It must not print output (p10k instant prompt warns). Shell setup that only applies when a tool is installed can stay shared if it is guarded, e.g. `[ -s "$X" ] && source "$X"`.

## Set up a new machine

These steps are written so you can hand them to Claude Code: "set up this machine from the dotfiles README".

1. Prerequisites (Homebrew):

   ```sh
   brew install git gh neovim tmux ripgrep fd lazygit tree-sitter-cli
   brew install --cask alacritty font-meslo-lg-nerd-font
   PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
   . ~/.nvm/nvm.sh && nvm install 22 && nvm alias default 22
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
   ZSH_CUSTOM=~/.oh-my-zsh/custom
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
   git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

   Skip anything already installed.

2. Clone and link:

   ```sh
   git clone git@github.com:phunguyen19/dotfiles.git ~/workspaces/personal/dotfiles
   ~/workspaces/personal/dotfiles/install.sh
   ```

   `install.sh` moves anything already at a target to `~/.dotfiles-backup/<timestamp>/`, then symlinks. Re-running is a no-op.

3. Create the local files from their templates and fill in what this machine needs:

   ```sh
   cd ~/workspaces/personal/dotfiles
   cp zsh/local.example.zsh zsh/local.zsh
   cp nvim/lua/rpn/local.example.lua nvim/lua/rpn/local.lua
   ```

   If the backup holds an old `~/.zshrc`, move its machine-specific lines (language managers, tool PATHs, Docker, work aliases, tokens) into `zsh/local.zsh`. Do not copy them into the shared `zsh/.zshrc`.

4. Install tmux plugins: start tmux, press `prefix + I`. Open `nvim` once to let lazy.nvim and Mason install.

5. Verify (see [Verify](#verify)).

## Migrate a machine that used the old mysetup-* repos

Before this repo, config lived in `mysetup-{neovim,zsh,tmux,p10k,alacritty}` (now archived on GitHub; older clones may point at `rpn3319/mysetup-*`). To migrate a machine:

1. Find legacy clones:

   ```sh
   find ~ -maxdepth 5 -name .git -type d -not -path "$HOME/Library/*" 2>/dev/null \
     | while read -r g; do d="${g%/.git}"; git -C "$d" remote get-url origin 2>/dev/null | grep -q 'mysetup-' && echo "$d"; done
   ```

   Usually `~/.config/nvim` and `~/.config/alacritty`. zsh, tmux and p10k were often plain copies (`~/.zshrc`, `~/.tmux.conf`, `~/.p10k.zsh`) with no clone.

2. For each clone, check for work that exists only on this machine:

   ```sh
   git -C <dir> status --short
   git -C <dir> fetch -q && git -C <dir> log --oneline origin/main..HEAD
   ```

   If either prints anything, stop and decide with the owner: port the change into this repo, or save it with `git -C <dir> diff > ~/<name>-uncommitted.patch` and drop it. Also compare loose copies (`~/.zshrc`, `~/.tmux.conf`) against the repo with `diff`.

3. Run steps 1–3 of [Set up a new machine](#set-up-a-new-machine). `install.sh` moves the legacy directories and files into `~/.dotfiles-backup/<timestamp>/`.

4. Remove git from the backed-up legacy clones, so nothing on the machine still tracks the old repos:

   ```sh
   B=$(ls -d ~/.dotfiles-backup/* | tail -1)
   rm -rf "$B/.config/nvim/.git" "$B/.config/alacritty/.git"
   ```

   Repeat for any other legacy clone found in step 1 that `install.sh` did not move (then delete that clone, after step 2's check).

5. Verify. Once the machine works, delete the backup: `rm -rf ~/.dotfiles-backup`. This is permanent; check first that nothing in it is still needed (old `.zshrc` lines, nvim `.env`, patches).

## Verify

```sh
ls -la ~/.zshrc ~/.p10k.zsh ~/.tmux.conf ~/.config/nvim ~/.config/alacritty   # all symlinks into this repo
zsh -n ~/.zshrc && zsh -i -c exit                                            # no errors
tmux source-file ~/.tmux.conf
nvim --headless +qa
git -C ~/workspaces/personal/dotfiles status --short                         # local files must not appear
test/install.test.sh
```

## Test

`test/install.test.sh` runs `install.sh` against a temporary `$HOME` and checks the links, the backup and that a second run changes nothing.
