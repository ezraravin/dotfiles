#!/bin/bash
# ==============================================
# Sway Wayland Compositor Setup Script
#
# Description:
#   Installs and configures Sway WM with essential
#   components for a complete Wayland environment
# ==============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_sway() {
  print_header "🌊 Sway Window Manager Setup"

  # ======================
  # Core Components
  # ======================
  local core_components=(
    sway             # Wayland compositor
    swaybg           # Wallpaper utility
    swaylock-effects # Enhanced screen locker
  )

  # ======================
  # Essential Utilities
  # ======================
  local utilities=(
    waybar       # Status bar
    wofi         # Application launcher
    grim         # Screenshot tool
    slurp        # Region selection
    wl-clipboard # Wayland clipboard
  )

  # ======================
  # Installation Process
  # ======================
  print_section "📦 Installing Core Components"
  for pkg in "${core_components[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  print_section "🔧 Installing Utilities"
  for pkg in "${utilities[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # ======================
  # Post-Install Notes
  # ======================
  print_success "Sway installation complete"
  echo -e "${YELLOW}Next steps:"
  echo "1. Configure your Sway environment:"
  echo "   - Main config: ~/.config/sway/config"
  echo "   - Waybar config: ~/.config/waybar/config"
  echo "2. Example configurations available at:"
  echo "   https://github.com/swaywm/sway/tree/master/config${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_sway
