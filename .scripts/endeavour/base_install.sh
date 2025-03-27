#!/bin/bash
# base_install.sh - Comprehensive System Installation and Configuration Script

##############################################
### Configuration Functions
##############################################

configure_dotfiles() {
  echo "🎛️ Dotfiles Configuration"
  local dotfiles_dir="$HOME/dotfiles"
  local clone_url="${GIT_CLONE_PREFIX:-https://gitlab.com/}ezraravinmateus/dotfiles.git"

  if [[ -d "$dotfiles_dir" ]]; then
    echo "Warning: Dotfiles already exist at $dotfiles_dir"
    return 0
  fi

  echo "Cloning Dotfiles Repository"
  if git clone "$clone_url" "$dotfiles_dir"; then
    rsync -av "$dotfiles_dir/" "$HOME/" &&
      rm -rf "$dotfiles_dir" &&
      echo "Dotfiles successfully synchronized to home directory" ||
      echo "Error: Failed to apply dotfiles"
  else
    echo "Error: Failed to clone dotfiles repository"
    return 1
  fi
}

configure_git() {
  echo "🔧 Git Configuration"

  # Check for existing configuration
  if git config --global --get user.email &>/dev/null &&
    git config --global --get user.name &>/dev/null &&
    git config --global --get init.defaultBranch &>/dev/null; then
    echo "Warning: Git configuration already exists - skipping setup"
    return 0
  fi

  # Interactive configuration
  echo "User Identity Setup"
  read -rp "Enter Git email (for commits): " GIT_EMAIL
  read -rp "Enter Git name (for commits): " GIT_NAME
  read -rp "Enter default branch name [main]: " GIT_BRANCH
  GIT_BRANCH=${GIT_BRANCH:-main} # Default to 'main' if empty

  # Apply configuration
  git config --global user.email "$GIT_EMAIL" &&
    git config --global user.name "$GIT_NAME" &&
    git config --global init.defaultBranch "$GIT_BRANCH" &&
    echo "Git configuration saved" ||
    echo "Error: Failed to configure Git settings"
}

configure_system() {
  echo "⚙️ System Configuration"

  # Bluetooth Service
  echo "Bluetooth Service Setup"
  if sudo systemctl enable --now bluetooth; then
    echo "Bluetooth service activated"
  else
    echo "Error: Failed to configure Bluetooth"
  fi

  # Time Synchronization
  echo "Network Time Protocol (NTP)"
  if sudo timedatectl set-ntp true; then
    echo "Time synchronization enabled"
  else
    echo "Warning: NTP configuration failed (network time may be inaccurate)"
  fi

  # Firewall Configuration
  echo "Firewall Setup"
  if ! sudo pacman -Qs firewalld >/dev/null; then
    if sudo pacman -S --noconfirm firewalld && sudo systemctl enable --now firewalld; then
      echo "Firewall service enabled"
    else
      echo "Warning: Firewall setup incomplete (manual configuration needed)"
    fi
  else
    echo "Warning: Firewalld already installed - skipping configuration"
  fi
}

##############################################
### Utility Functions
##############################################

cleanup() {
  local exit_status=$?
  if [ $exit_status -eq 0 ]; then
    if [ -z "${REBOOT_CHOICE+x}" ]; then
      echo "Installation successful. Setup.log preserved."
    else
      [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]] &&
        echo "System will reboot to apply changes." ||
        echo "Setup.log preserved. Reboot recommended."
    fi
  else
    echo "Error: Installation failed. Last 20 lines from setup.log:"
    tail -n 20 setup.log
    echo "Warning: Check setup.log for detailed error information"
  fi
}

run_script() {
  local script_name=$1
  local script_path="$SCRIPT_DIR/$script_name"

  if [[ -f "$script_path" && -x "$script_path" ]]; then
    echo "Running $script_name"
    if "$script_path"; then
      return 0
    else
      echo "Error: $script_name failed with exit code $?"
      return 1
    fi
  else
    echo "Error: Script not found or not executable: $script_name"
    return 1
  fi
}

execute_install_phase() {
  local phase_name=$1
  shift
  local scripts=("$@")

  echo "Starting $phase_name Phase"
  for script in "${scripts[@]}"; do
    if ! run_script "$script"; then
      echo "Warning: Continuing despite $script failure"
      sleep 2 # Pause to ensure user sees the warning
    fi
  done
}

##############################################
### Main Installation Flow
##############################################

main() {
  # Keep sudo session alive throughout installation
  echo "Maintaining Sudo Session"
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Initial System Configuration
  echo "System Configuration Phase"
  configure_dotfiles
  configure_git
  configure_system

  # Installation Complete
  echo "Installation Complete!"
  read -rp "Reboot now to apply all changes? (y/n): " REBOOT_CHOICE
  if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
    sudo reboot
  else
    echo "Changes may require restart. Log saved to setup.log"
  fi
}

# Execute only if run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  trap cleanup EXIT
  main "$@"
fi
