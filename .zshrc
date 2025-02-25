# ======================
# Environment Variables
# ======================

# Homebrew Path
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS-specific configurations
    export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux-specific configurations
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Android SDK
export ANDROID_HOME="$HOMEBREW_PREFIX/share/android-commandlinetools"
export PATH="$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# PHP (Herd Lite)
export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="$HOME/.config/herd-lite/bin:$PATH"

# Ruby (Mac only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"
fi

# Prettier
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc"

# Deepseek
export MODEL="deepseek-r1:1.5b"

# ======================
# Shell Configuration
# ======================

# Oh My Zsh Theme
ZSH_THEME="robbyrussell"

# Source Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# ======================
# Tool Initializations
# ======================

# Homebrew
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# Zoxide
eval "$(zoxide init zsh)"

# Oh My Posh
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"

# Pandoc & Basictex
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/usr/libexec/path_helper)"
fi

# Zsh Autosuggestions
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Zsh Syntax Highlighting
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# FZF
source <(fzf --zsh)

# ======================
# Aliases
# ======================

# General
alias v="nvim"
alias c="clear"
alias q="exit"
alias sz="source ~/.zshrc"
alias lg="lazygit"
alias yz="yazi"
alias ff="fastfetch"
alias cv="cava"
alias bt="btop"
alias tm="tmux"

# File Listing
alias ls="eza --icons"
alias lst="eza --icons --tree"
alias lsl="eza -l"

# Navigation
alias cd="z"
alias f='nvim $(fzf --preview="bat --color=always {}")'

# Development
alias get_idf='. $HOME/esp/esp-idf/export.sh'
alias xampp="sudo /opt/lampp/lampp start"

# Configuratin
alias nvc="cd ~/.config/nvim && nvim && cd"
alias zshrc="cd ~/ && nvim .zshrc"

# ======================
# TMUX (Auto-start)
# ======================

if [ -z "$TMUX" ]; then
    tmux
fi
