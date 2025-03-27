#!/bin/bash
# setup_apps.sh - Desktop Applications Setup
# Description:
#   Installs essential desktop applications including:
#   - Brave (via official install script)
#   - Media tools (VLC, OBS Studio)
#   - Music/Communication (Spotify, WhatsApp)
#   - Creative tools (DaVinci Resolve, Penpot)
#   - Spotify adblocker

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_apps() {
  print_header "🖥️ Desktop Applications Setup"

  print_section "🌐 Browsers & Communication"
  install_or_skip "brave-browser" "curl -fsS https://dl.brave.com/install.sh | sh" "Brave Browser"
  install_or_skip "whatsapp-for-linux" "yay -S --noconfirm whatsapp-for-linux-bin" "WhatsApp Desktop"

  print_section "🎵 Music & Audio"
  install_or_skip "spotify" "yay -S --noconfirm spotify" "Spotify"
  install_or_skip "spotify-adblock" "yay -S --noconfirm spotify-adblock-git" "Spotify Adblock"

  print_section "🎬 Media & Production"
  install_or_skip "vlc" "sudo pacman -S --noconfirm vlc" "VLC Media Player"
  install_or_skip "obs-studio" "sudo pacman -S --noconfirm obs-studio" "OBS Studio"
  install_or_skip "davinci-resolve" "yay -S --noconfirm davinci-resolve-studio" "DaVinci Resolve Studio"

  print_section "🎨 Design & Creativity"
  install_or_skip "penpot-desktop" "yay -S --noconfirm penpot-desktop-bin" "Penpot Designer"

  print_success "All applications processed"
  echo -e "${YELLOW}Note: Some applications may require additional setup:"
  echo -e "- Spotify Adblock: Follow post-install instructions"
  echo -e "- DaVinci Resolve: May need proprietary drivers"
  echo -e "- Penpot: First launch may take longer${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_apps
