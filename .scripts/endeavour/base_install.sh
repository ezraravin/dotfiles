#!/bin/bash
# base_install.sh - Main Installation Orchestrator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

# Enable error handling and verbose output
set -e
set -o pipefail
if command -v ts >/dev/null; then
  exec > >(ts '[%Y-%m-%d %H:%M:%S]' | tee -a setup.log)
else
  exec > >(while read -r line; do echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line"; done | tee -a setup.log)
fi

# Use parallel downloads (add to base_install.sh)
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

##############################################
### Cleanup Function
##############################################
cleanup() {
  local exit_status=$?
  if [ $exit_status -eq 0 ]; then
    if [ -z "${REBOOT_CHOICE+x}" ]; then
      print_success "Installation successful. Setup.log preserved."
    else
      [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]] &&
        print_success "System will reboot." ||
        print_success "Setup.log preserved."
    fi
  else
    print_error "Installation failed. Last 20 lines from setup.log:"
    tail -n 20 setup.log
  fi
}
trap cleanup EXIT

##############################################
### Script Execution Functions
##############################################

run_script() {
  local script_name=$1
  local script_path="$SCRIPT_DIR/$script_name"

  if [[ -f "$script_path" && -x "$script_path" ]]; then
    print_header "🏃 Running $script_name"
    "$script_path" || {
      print_error "$script_name failed"
      return 1
    }
  else
    print_error "Script not found/executable: $script_name"
    return 1
  fi
}

execute_install_phase() {
  local phase_name=$1
  shift
  local scripts=("$@")

  print_header "🚀 Starting $phase_name Phase"
  for script in "${scripts[@]}"; do
    run_script "$script" || {
      print_warning "Continuing despite $script failure"
      continue
    }
  done
}

##############################################
### Main Installation Flow
##############################################

main() {
  # Keep sudo alive
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Initial configuration
  execute_install_phase "./configs/configure_system.sh"
  execute_install_phase "./configs/configure_git.sh"
  execute_install_phase "./configs/configure_dotfiles.sh"

  # Core System Installation
  execute_install_phase "./setups/setup_shell.sh"
  execute_install_phase "./setups/setup_linux.sh"

  execute_install_phase "./setups/setup_dev_env.sh"
  execute_install_phase "./setups/setup_ai.sh"
  execute_install_phase "./setups/setup_apps.sh"
  execute_install_phase "./setups/setup_gpu.sh"

  # Finalization
  execute_install_phase "./configs/configure_dotfiles.sh"
  execute_install_phase "finalize_setup.sh"

  # Completion
  print_header "🎉 Installation Complete!"
  read -p "Reboot now? (y/n): " REBOOT_CHOICE
  [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]] && sudo reboot ||
    print_success "Changes may require restart"
}

# Execute only if run directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
