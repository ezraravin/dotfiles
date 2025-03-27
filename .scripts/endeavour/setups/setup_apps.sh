#!/bin/bash
# setup_apps.sh - Desktop Applications Setup
# Description:
#   Installs essential desktop applications:
#   - Brave (privacy-focused browser)
#   - VLC (media player)
#   - OBS Studio (streaming/recording)
# Notes:
#   All packages installed from AUR via yay

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_apps() {
  print_header "🖥️ Application Installation"

  # Application list with descriptions
  local apps=(
    "brave-bin"  # Brave web browser, use install script
    "vlc"        # Versatile media player, use pacman
    "obs-studio" # Screen recording/streaming, use pacman
  )

  # Installation process
  print_section "📦 Installing Applications"
  for app in "${apps[@]}"; do
    install_or_skip "$app" "yay -S --noconfirm $app" "$app"
  done

  print_success "Applications installed"
  echo -e "${YELLOW}Note: Launch applications from your desktop menu${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_apps
