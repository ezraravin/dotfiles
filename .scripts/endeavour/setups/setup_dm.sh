#!/bin/bash
# setup_dm.sh - SDDM Display Manager installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

install_sddm() {
  print_header "🖥️ Installing SDDM Display Manager"

  # Install SDDM and required components
  local sddm_packages=(
    sddm
    sddm-kcm
    qt5-quickcontrols2
    qt5-graphicaleffects
  )

  for pkg in "${sddm_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Install SDDM themes
  print_section "🌄 Installing SDDM Themes"
  install_or_skip "sddm-themes" "sudo pacman -S --noconfirm sddm-themes" "SDDM Themes"

  # Enable SDDM service
  print_section "⚙️ Configuring SDDM Service"
  if sudo systemctl enable sddm --now; then
    print_success "SDDM service enabled and started"
  else
    print_error "Failed to enable SDDM service"
    return 1
  fi

  # Set default theme (optional - uncomment and modify if needed)
  # print_section "🎨 Setting Default Theme"
  # sudo sed -i 's/^Current=.*/Current=sugar-candy/' /etc/sddm.conf
  # print_success "Set default theme to sugar-candy"
}

main() {
  install_sddm

  print_success "SDDM installation complete"
  echo "Note: You can change themes later from System Settings > Startup and Shutdown > Login Screen"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
