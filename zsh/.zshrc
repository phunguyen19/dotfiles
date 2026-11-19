# Enable Powerlevel11k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

# Extra completion paths; must be set before oh-my-zsh runs compinit
[ -d "$HOME/.daml/zsh" ] && fpath=("$HOME/.daml/zsh" $fpath)
[ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-completions" ] && fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-completions" $fpath)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Usage: copy_project /path/to/source/ /path/to/destination/
alias copy_project='rsync -av --progress --exclude={".git","node_modules","build","dist"}'


# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Alias copy project
copyprojectfunc() {
  local EXCLUDES=(
    .git
    node_modules
    build
    dist
    vendor
    target
    __pycache__
    .venv
    venv
    bin
    pkg
  )
  local RSYNC_EXCLUDE=()
  for e in "${EXCLUDES[@]}"; do
    RSYNC_EXCLUDE+=(--exclude="$e")
  done

  # file-patterns to skip
  RSYNC_EXCLUDE+=(--exclude='*.pyc' --exclude='*.pyo' --exclude='*.o' --exclude='*.so' --exclude='*.exe')

  rsync -av --progress "${RSYNC_EXCLUDE[@]}" "$@"
}
alias copyproject=copyprojectfunc

# Git update function
gitupdatefunc() {
  if [ -z "$1" ]; then
    echo "Usage: gitupdate <branch>"
    return 1
  fi
  git checkout "$1" && git fetch --all && git pull
}
alias gitupdate=gitupdatefunc

# Git Worktree Checkout
gwco() {
    if [ -z "$1" ]; then
        echo "Usage: git worktree checkout <worktree-name-or-path>"
        echo "Available worktrees:"
        command git worktree list
        return 1
    fi
    
    # Check if argument is a full path
    if [ -d "$1" ]; then
        cd "$1"
        echo "Switched to worktree: $1"
        return 0
    fi
    
    # Try to find worktree by partial name or basename match
    local target="$1"
    local worktree_path
    
    # First try exact basename match
    worktree_path=$(command git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2- | while read -r path; do
        if [[ "$(basename "$path")" == "$target" ]]; then
            echo "$path"
            break
        fi
    done)
    
    # If no exact match, try partial match
    if [ -z "$worktree_path" ]; then
        worktree_path=$(command git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2- | grep -F "$target" | head -n1)
    fi
    
    if [ -n "$worktree_path" ] && [ -d "$worktree_path" ]; then
        cd "$worktree_path"
        echo "Switched to worktree: $worktree_path"
    else
        echo "Error: Worktree '$1' not found"
        echo "Available worktrees:"
        command git worktree list
        return 1
    fi
}

# Git command wrapper
git() {
    if [[ "$1" == "worktree" && "$2" == "checkout" ]]; then
        shift 2
        gwco "$@"
    else
        command git "$@"
    fi
}

# Tab completion for gwco
_gwco() {
    local -a worktrees
    worktrees=(${(f)"$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2-)"})
    
    local -a worktree_descriptions
    for worktree in $worktrees; do
        if [ -d "$worktree" ]; then
            local branch=$(command git -C "$worktree" branch --show-current 2>/dev/null)
            if [ -n "$branch" ]; then
                worktree_descriptions+=("$worktree:$branch")
            else
                worktree_descriptions+=("$worktree")
            fi
        fi
    done
    
    _describe 'worktree' worktree_descriptions
}

compdef _gwco gwco

# Git worktree completion extension
_git-worktree() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        '1: :->command' \
        '*::arg:->args'

    case $state in
    command)
        local -a subcommands
        subcommands=(
            'add:Create a new worktree'
            'list:List worktrees'
            'lock:Lock a worktree'
            'move:Move a worktree'
            'prune:Prune worktree information'
            'remove:Remove a worktree'
            'repair:Repair worktree administrative files'
            'unlock:Unlock a worktree'
            'checkout:Switch to a worktree directory'
        )
        _describe -t commands 'git worktree subcommand' subcommands
        ;;
    args)
        case $line[1] in
        checkout|remove)
            local -a worktrees
            worktrees=(${(f)"$(command git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2-)"})
            _describe 'worktree' worktrees
            ;;
        *)
            _files
            ;;
        esac
        ;;
    esac
}

export PATH="$HOME/.local/bin:$PATH"

alias gitsync="git pull && git add . && git commit -m 'sync' && git push"

# Machine-specific setup, gitignored; see local.example.zsh
local_zsh="${${(%):-%x}:A:h}/local.zsh"
[ -r "$local_zsh" ] && source "$local_zsh"
unset local_zsh
