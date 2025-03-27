#!/bin/bash
# setup_gpu_driver.sh - GPU driver installation for all scenarios

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

detect_gpu() {
  print_header "🔍 Detecting GPU Hardware"

  if lspci | grep -i "VGA.*NVIDIA" >/dev/null; then
    echo "NVIDIA"
  elif lspci | grep -i "VGA.*AMD" >/dev/null || lspci | grep -i "VGA.*ATI" >/dev/null; then
    echo "AMD"
  elif lspci | grep -i "VGA.*Intel" >/dev/null; then
    if lspci | grep -i "3D.*NVIDIA" >/dev/null; then
      echo "Optimus" # Intel + NVIDIA hybrid
    else
      echo "Intel" # Just Intel integrated
    fi
  else
    echo "None"
  fi
}

install_nvidia() {
  print_section "🟢 Installing NVIDIA Drivers"

  local nvidia_packages=(
    nvidia-dkms
    nvidia-utils
    lib32-nvidia-utils
    nvidia-settings
    vulkan-icd-loader
    lib32-vulkan-icd-loader
  )

  for pkg in "${nvidia_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Handle mkinitcpio regeneration
  sudo mkinitcpio -P
}

install_amd() {
  print_section "🔴 Installing AMD Drivers"

  local amd_packages=(
    mesa
    vulkan-radeon
    lib32-vulkan-radeon
    vulkan-icd-loader
    lib32-vulkan-icd-loader
  )

  for pkg in "${amd_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done
}

install_optimus() {
  print_section "🟡 Setting up Optimus (Intel + NVIDIA Hybrid)"

  install_nvidia
  install_or_skip "optimus-manager" "yay -S --noconfirm optimus-manager" "Optimus Manager"
  install_or_skip "bbswitch" "sudo pacman -S --noconfirm bbswitch" "BBSwitch"
}

install_intel() {
  print_section "🔵 Installing Intel Drivers"

  local intel_packages=(
    mesa
    vulkan-intel
    lib32-vulkan-intel
  )

  for pkg in "${intel_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done
}

main() {
  local gpu_type=$(detect_gpu)

  case $gpu_type in
    "NVIDIA")
      install_nvidia
      ;;
    "AMD")
      install_amd
      ;;
    "Optimus")
      install_optimus
      ;;
    "Intel")
      install_intel
      ;;
    *)
      print_warning "No dedicated GPU detected. Using default modesetting driver."
      ;;
  esac

  print_success "GPU setup completed for $gpu_type"
  [[ "$gpu_type" =~ (NVIDIA|Optimus) ]] && echo "Note: Reboot required for changes to take effect"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
