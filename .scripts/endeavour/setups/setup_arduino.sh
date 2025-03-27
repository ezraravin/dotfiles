#!/bin/bash
# setup_arduino.sh - Arduino Development Setup
# Description:
#   Installs and configures Arduino IDE with:
#   - Official IDE package
#   - Proper udev rules for device access
#   - User group permissions
# Notes:
#   Requires yay for AUR package
#   Physical device access needs logout after setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_arduino() {
  print_header "⚡ Arduino Development Setup"

  # IDE installation
  print_section "🛠️ Installing Arduino IDE"
  install_or_skip "arduino-ide" "yay -S --noconfirm arduino-ide" "Arduino IDE"

  # Device permissions
  print_section "🔌 Configuring Device Access"
  sudo usermod -a -G uucp,tty "$USER" &&
    sudo curl -o /etc/udev/rules.d/60-arduino.rules \
      https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules &&
    sudo udevadm control --reload

  print_success "Arduino environment ready"
  echo -e "${YELLOW}Next steps:"
  echo "1. Log out and back in for device permissions"
  echo "2. Launch IDE: arduino-ide"
  echo "3. Install board packages via Boards Manager${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_arduino
