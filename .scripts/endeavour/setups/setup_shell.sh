#!/bin/bash
# setup_shell.sh - Shell Environment Setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_shell() {
  print_header "🐚 Shell Environment"

  # Install Zsh and plugins
  local packages=(
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    zoxide
    oh-my-posh-bin
  )

  for pkg in "${packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Oh My Zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Set default shell
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)"
  fi

  print_success "Shell setup complete"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_shell
