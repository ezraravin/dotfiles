# ======================
# Environment Variables
# ======================

# Homebrew
if [[ "$(uname)" == "Darwin" && -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  export PATH=$HOME/.gem/bin:$PATH
else
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Local Bin Path
export PATH=$PATH:$HOME/.local/bin

# Neovim as Default Editor
export EDITOR="nvim"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# PHP (Herd Lite)
export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="$HOME/.config/herd-lite/bin:$PATH"

# Prettier
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc"

# Chrome
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# RUST
export PATH="$HOME/.cargo/bin:$PATH"

# GO
export PATH="$HOME/go/bin:$PATH"

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
alias tm="tmux"

# Applications
alias lg="lazygit"    # Git TUI
alias ld="lazydocker" # Docker TUI
alias yz="yazi"       # File Viewer
alias ff="fastfetch"  # Fastfetch
alias cv="cava"       # Music Equalizer
alias bt="btop"       # Performance Monitor
alias pdf="fancy-cat" # PDF Viewer

# File Listing
alias ls="eza --icons"
alias lst="eza --icons --tree"
alias lsl="eza -l"

# Navigation
alias cd="z"
alias f='nvim $(fzf --preview="bat --color=always {}")'

# Development
alias xampp="sudo /opt/lampp/lampp start"
alias py="python"
alias py3="python3"
alias fk="fuck"

# Configuration
alias nvc="cd ~/.config/nvim && nvim && cd"
alias zc="cd ~/ && nvim .zshrc"
alias scr="cd ~/.limo/ && nvim && cd"
alias hc="cd ~/.config/hypr && nvim && cd"
alias wc="cd ~/.config/waybar && nvim && cd"
alias hctl="hyprctl"

# WARP
alias wcc="warp-cli connect"
alias wcd="warp-cli disconnect"

# Run Fastfetch After TMUX
fastfetch

# ======================
# Ensure Zsh is running
# ======================

if [ -z "$ZSH" ]; then
  exec zsh
fi

# ======================
# TMUX (Auto-start)
# ======================

if [ -z "$TMUX" ]; then
  tmux
fi

# bun
export PATH="$HOME/.bun/bin:$PATH"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/rave/.dart-cli-completion/zsh-config.zsh ]] && . /home/rave/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# bun completions
[ -s "/home/rave/.bun/_bun" ] && source "/home/rave/.bun/_bun"
