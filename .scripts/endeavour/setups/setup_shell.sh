#!/bin/bash
# ==============================================
# Shell Environment Configuration Script
#
# Description:
#   Configures a complete Zsh environment with:
#   - Modern shell tools and utilities
#   - Enhanced command line experience
#   - Productivity plugins and themes
# ==============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_shell() {
  print_header "🐚 Shell Environment Configuration"

  # ======================
  # Core Shell Packages
  # ======================
  print_section "📦 Installing Core Shell Components"
  install_or_skip "zsh" "sudo pacman -S --noconfirm zsh" "Z shell"
  install_or_skip "zsh-syntax-highlighting" "sudo pacman -S --noconfirm zsh-syntax-highlighting" "Zsh syntax highlighting"
  install_or_skip "zsh-autosuggestions" "sudo pacman -S --noconfirm zsh-autosuggestions" "Zsh autosuggestions"
  install_or_skip "zsh-completions" "sudo pacman -S --noconfirm zsh-completions" "Zsh completions"

  # ======================
  # Productivity Tools
  # ======================
  print_section "🛠️ Installing Productivity Tools"
  install_or_skip "zoxide" "sudo pacman -S --noconfirm zoxide" "Zoxide directory navigator"
  install_or_skip "fzf" "sudo pacman -S --noconfirm fzf" "Fuzzy finder"
  install_or_skip "thefuck" "sudo pacman -S --noconfirm thefuck" "Command correction tool"

  # ======================
  # Oh My Posh Installation
  # ======================
  print_section "🎨 Installing Oh My Posh"
  install_or_skip "oh-my-posh" "curl -s https://ohmyposh.dev/install.sh | bash -s" "Oh My Posh prompt" "oh-my-posh"

  # ======================
  # Oh My Zsh Setup
  # ======================
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print_section "✨ Installing Oh My Zsh Framework"
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
      print_success "Oh My Zsh installed"
    else
      print_error "Failed to install Oh My Zsh"
    fi
  else
    print_warning "Oh My Zsh already installed - skipping"
  fi

  # ======================
  # Default Shell Configuration
  # ======================
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    print_section "🔧 Setting Zsh as Default Shell"
    if chsh -s "$(which zsh)"; then
      print_success "Default shell changed to Zsh"
    else
      print_error "Failed to change default shell"
    fi
  else
    print_warning "Zsh is already the default shell"
  fi

  # ======================
  # Completion Message
  # ======================
  print_success "Shell environment configured successfully"
  echo -e "${YELLOW}Recommended next steps:"
  echo "1. Add 'eval \"\$(oh-my-posh init zsh)\"' to your .zshrc"
  echo "2. Run 'oh-my-posh font install' for icons"
  echo "3. Initialize zoxide with 'eval \"\$(zoxide init zsh)\"'"
  echo "4. Configure fzf keybindings in your .zshrc${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_shell
