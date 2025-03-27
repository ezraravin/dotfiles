#!/bin/bash
# setup_arduino.sh - Arduino Setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_arduino() {
  print_header "🛠️ Arduino Setup"

  install_or_skip "arduino-ide" "yay -S --noconfirm arduino-ide" "Arduino IDE"

  # udev rules
  sudo usermod -a -G uucp,tty $USER
  sudo curl -o /etc/udev/rules.d/60-arduino.rules \
    https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules
  sudo udevadm control --reload

  print_success "Arduino ready"
  echo "Launch with: arduino-ide"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_arduino
