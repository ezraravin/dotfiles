# Change $PATH
export PATH="$HOME/.local/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Auto Update OMZ
zstyle ':omz:update' mode auto

# Use Theme
ZSH_THEME="robbyrussell"

# Install Plugins
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Use Oh My ZSH when opening Terminal
source $ZSH/oh-my-zsh.sh

# Rename Aliases
alias v="nvim"
alias c="clear"
alias lg="lazygit"
alias q="exit"
alias sz="source ~/.zshrc"
alias yz="yazi"
alias ls="eza --icons"
alias lst="eza --icons --tree"
alias cd="z"

# BUN COMPLETIONS
[ -s "/home/ezra/.bun/_bun" ] && source "/home/ezra/.bun/_bun"

# BUN
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ZOXIDE
eval "$(zoxide init zsh)"

# OH MY POSH
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"

# RUST & CARGO
export PATH="$HOME/.cargo/bin:$PATH"

# PRETTIER
export PRETTIERD_DEFAULT_CONFIG=~/.prettierrc

eval export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";

export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";

export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";

fpath[1,0]="/home/linuxbrew/.linuxbrew/share/zsh/site-functions";

export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";

[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";

export INFOPATH="/home/linuxbrew/.linuxbrew/hare/info:${INFOPATH:-}";
