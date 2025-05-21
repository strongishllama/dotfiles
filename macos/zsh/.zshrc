# Initalize oh-my-posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.toml)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx

# Load completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
export PATH=/opt/homebrew/bin:$PATH

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24) ]]; then
  compinit -C
else
  compinit
fi

zinit cdreplay -q

# Keybindings
bindkey '^f' autosuggest-accept
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Set cursor to bar mode.
echo -ne '\e[6 q'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# tmux
export XDG_CONFIG_HOME="$HOME/.config"

# SSH
export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"

# direnv
eval "$(direnv hook zsh)"

# gcloud
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# golang
export PATH="$HOME/go/bin:$PATH"
export GOBIN="$HOME/bin"

# docker
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# Aliases
alias ls='ls --color'
alias bat="bat --paging=never"
alias n="nvim"
alias rm="echo \"use 'trash' to trash it, or the full path '/bin/rm' if you want to permanently delete it\""
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias tf="terraform"

alias gbd="bash \"$HOME/scripts/git-branch-delete.sh\""
alias gsmdb="bash \"$HOME/scripts/git-switch-main-delete-branch.sh\""
alias gs="bash \"$HOME/scripts/git-switch.sh\""
alias gprune="git fetch --prune && git tag -l | xargs git tag -d && git fetch --tags"
alias gstu="git status --untracked-files"
alias ghpr="gh pr create --draft --assignee @me"
alias glmr="bash \"$HOME/scripts/glab-mr-create.sh\""

# Paths
export PATH="$(brew --prefix)/opt/postgresql@13/bin:$PATH"
export PATH="$HOME/bin:$PATH"

eval $(thefuck --alias)
eval "$(direnv hook zsh)"
eval "$(fzf --zsh)"
eval "$(/opt/homebrew/bin/mise activate zsh)"
eval "$(zoxide init --cmd cd zsh)"

