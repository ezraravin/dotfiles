#!/bin/bash
# setup_shell.sh - Shell Configuration
# Description:
#   Configures Zsh environment with:
#   - Oh My Zsh framework
#   - Syntax highlighting
#   - Auto-suggestions
#   - Zoxide for smart directory navigation
#   - Oh My Posh theming

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_shell() {
  print_header "🐚 Shell Environment Setup"

  local packages=(
    zsh                     # Z shell
    zsh-syntax-highlighting # Command highlighting
    zsh-autosuggestions     # Predictive typing
    zsh-completions         # Additional completions
    zoxide                  # Smart cd replacement
    oh-my-posh-bin          # Prompt theming
  )

  # Install packages
  for pkg in "${packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Oh My Zsh installation
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print_section "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Set default shell
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    print_section "Setting Default Shell"
    chsh -s "$(which zsh)"
  fi

  print_success "Shell configuration complete"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_shell
