# ======================
# Environment Variables
# ======================

# Homebrew Path
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS-specific configurations
  # Homebrew
  export HOMEBREW_PREFIX="/opt/homebrew"
  # Ruby
  export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"
  # Homebrew
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  # Pandoc & Basictex
  eval "$(/usr/libexec/path_helper)"
  # Zsh Autosuggestions
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  # Zsh Syntax Highlighting
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux-specific configurations
  # export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  # Local Bin Path
  export PATH=$PATH:$HOME/.local/bin
  # Zsh Autosuggestions
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  # Zsh Syntax Highlighting
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # Chrome Executable
  export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
  # Android SDK
  export ANDROID_HOME=/opt/android-sdk
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
fi

# Neovim as Default Editor
export EDITOR="nvim"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Android SDK
# export ANDROID_HOME="$HOMEBREW_PREFIX/share/android-commandlinetools"
# export PATH="$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# PHP (Herd Lite)
export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="$HOME/.config/herd-lite/bin:$PATH"

# Prettier
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc"

# PNPM
export PNPM_HOME="/Users/ezra/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

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

# Zoxide
eval "$(zoxide init zsh)"

# Oh My Posh
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"

# The Fuck
eval $(thefuck --alias)

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
alias py="python"
alias py3="python3"
alias fk="fuck"

# Configuration
alias nvc="cd ~/.config/nvim && nvim . && cd"
alias zc="cd ~/ && nvim .zshrc"
alias scr="cd ~/.scripts/ && nvim . && cd"
alias hc="cd ~/.config/hypr && nvim . && cd"
alias hctl="hyprctl"

# Run Fastfetch After TMUX
fastfetch

# Run Fastfetch After TMUX
fastfetch

# ======================
# TMUX (Auto-start)
# ======================

if [ -z "$TMUX" ]; then
  tmux
fi

# ======================
# Ensure Zsh is running
# ======================

if [ -z "$ZSH" ]; then
  exec zsh
fi

# bun completions
[ -s "/home/rave/.bun/_bun" ] && source "/home/rave/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
