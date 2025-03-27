#!/bin/bash
# setup_arduino.sh - Arduino IDE installation with automatic yay setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

install_yay() {
  print_header "📦 Installing yay (AUR Helper)"

  if command_exists yay; then
    print_warning "yay is already installed"
    return 0
  fi

  print_section "Installing dependencies"
  sudo pacman -S --needed --noconfirm base-devel git || {
    print_error "Failed to install prerequisites"
    return 1
  }

  print_section "Cloning yay repository"
  local temp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$temp_dir" || {
    print_error "Failed to clone yay repository"
    return 1
  }

  print_section "Building yay"
  (cd "$temp_dir" && makepkg -si --noconfirm) || {
    print_error "Failed to build yay"
    rm -rf "$temp_dir"
    return 1
  }

  rm -rf "$temp_dir"
  print_success "yay installed successfully"
}

install_arduino_ide() {
  print_header "🛠️ Installing Arduino IDE"

  install_or_skip "arduino-ide" "yay -S --noconfirm arduino-ide" "Arduino IDE" || {
    print_error "Arduino IDE installation failed"
    return 1
  }

  # Setup device permissions
  print_section "🔌 Configuring Arduino permissions"
  sudo usermod -a -G uucp,lock "$USER" || print_warning "Failed to add user to groups (may need manual setup)"

  if [[ ! -f /etc/udev/rules.d/00-arduino.rules ]]; then
    sudo curl -sSfLo /etc/udev/rules.d/00-arduino.rules \
      https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules &&
      sudo udevadm control --reload-rules &&
      sudo udevadm trigger
  fi

  if command_exists arduino-ide; then
    print_success "Arduino IDE ready to use!"
    echo -e "${GREEN}Launch with: ${NC}arduino-ide"
  else
    print_error "Arduino IDE installation verification failed"
    return 1
  fi
}

main() {
  # Install yay if missing
  if ! command_exists yay; then
    install_yay || {
      print_error "Aborting Arduino installation due to yay setup failure"
      return 1
    }
  fi

  install_arduino_ide
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
