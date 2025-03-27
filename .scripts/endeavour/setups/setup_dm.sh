#!/bin/bash
# setup_dm.sh - Display Manager Configuration
# Description:
#   Installs and configures SDDM display manager with:
#   - Core SDDM packages
#   - Optional themes
#   - Qt dependencies
#   - Automatic service activation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

install_sddm() {
  print_header "🖥️ SDDM Display Manager Setup"

  # Core SDDM packages with dependencies
  local sddm_packages=(
    sddm               # Display manager
    qt5-quickcontrols2 # Qt5 components
    qt5-graphicaleffects
  )

  # Install main packages
  for pkg in "${sddm_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Optional theming support
  print_section "🎨 Installing SDDM Themes"
  install_or_skip "sddm-themes" "sudo pacman -S --noconfirm sddm-themes" "SDDM Themes"

  # Service configuration
  print_section "⚙️ Enabling SDDM Service"
  if sudo systemctl enable --now sddm; then
    print_success "SDDM service activated"
  else
    print_error "Failed to enable SDDM"
    return 1
  fi

  # Post-install notes
  print_success "SDDM installation complete"
  echo -e "${YELLOW}Note: Change themes via System Settings > Startup and Shutdown > Login Screen${NC}"
}

main() {
  install_sddm
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
