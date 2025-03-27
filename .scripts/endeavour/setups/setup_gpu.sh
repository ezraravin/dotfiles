#!/bin/bash
# setup_gpu_driver.sh - Complete GPU Driver Installation Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

# -------------------------
# GPU Detection
# -------------------------
detect_gpu() {
  print_header "🔍 Detecting GPU Hardware"

  if lspci | grep -i "VGA.*NVIDIA" >/dev/null; then
    if lspci | grep -i "VGA.*Intel" >/dev/null; then
      echo "Optimus"
    else
      echo "NVIDIA"
    fi
  elif lspci | grep -i "VGA.*AMD" >/dev/null || lspci | grep -i "VGA.*ATI" >/dev/null; then
    echo "AMD"
  elif lspci | grep -i "VGA.*Intel" >/dev/null; then
    echo "Intel"
  else
    echo "None"
  fi
}

# -------------------------
# NVIDIA Driver Installation
# -------------------------
choose_nvidia_driver() {
  print_section "🔘 NVIDIA Driver Selection"
  echo "Which NVIDIA driver would you like to install?"
  echo "1) NVIDIA-LTS (Recommended for linux-lts kernel users)"
  echo "2) NVIDIA-DKMS (Recommended for regular/zen kernels)"
  echo "3) Skip NVIDIA installation"

  while true; do
    read -p "Your choice [1-3]: " choice
    case $choice in
      1)
        echo "lts"
        break
        ;;
      2)
        echo "dkms"
        break
        ;;
      3)
        echo "skip"
        break
        ;;
      *) print_error "Invalid option. Please choose 1-3" ;;
    esac
  done
}

install_nvidia_driver() {
  local driver_type=$1

  case $driver_type in
    "lts")
      print_section "🟢 Installing NVIDIA-LTS"
      install_or_skip "nvidia-lts" "sudo pacman -S --noconfirm nvidia-lts" "NVIDIA LTS Driver"
      ;;
    "dkms")
      print_section "🟡 Installing NVIDIA-DKMS"
      install_or_skip "nvidia-dkms" "sudo pacman -S --noconfirm nvidia-dkms dkms linux-headers" "NVIDIA DKMS Driver"
      ;;
    "skip")
      print_warning "Skipping NVIDIA driver installation"
      return 1
      ;;
  esac

  # Common NVIDIA packages
  local common_packages=(
    nvidia-utils
    lib32-nvidia-utils
    nvidia-settings
    vulkan-icd-loader
    lib32-vulkan-icd-loader
  )

  for pkg in "${common_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Regenerate initramfs
  if ! sudo mkinitcpio -P; then
    print_error "Failed to regenerate initramfs"
    return 1
  fi
}

# -------------------------
# AMD Driver Installation
# -------------------------
install_amd_driver() {
  print_header "🔴 Installing AMD Drivers"

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

  # Additional recommended for AMD
  install_or_skip "libva-mesa-driver" "sudo pacman -S --noconfirm libva-mesa-driver" "VA-API Drivers"
  install_or_skip "mesa-vdpau" "sudo pacman -S --noconfirm mesa-vdpau" "VDPAU Drivers"
}

# -------------------------
# Intel Driver Installation
# -------------------------
install_intel_driver() {
  print_header "🔵 Installing Intel Drivers"

  local intel_packages=(
    mesa
    vulkan-intel
    lib32-vulkan-intel
    intel-media-sdk
    libva-intel-driver
  )

  for pkg in "${intel_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done
}

# -------------------------
# Optimus Setup
# -------------------------
setup_optimus() {
  print_header "🟡 Configuring NVIDIA Optimus"

  local driver_type=$(choose_nvidia_driver)
  [[ "$driver_type" == "skip" ]] && return

  if ! install_nvidia_driver "$driver_type"; then
    print_error "Optimus setup aborted"
    return 1
  fi

  install_or_skip "optimus-manager" "yay -S --noconfirm optimus-manager optimus-manager-qt" "Optimus Manager"
  install_or_skip "bbswitch" "sudo pacman -S --noconfirm bbswitch" "BBSwitch"

  print_section "🛠 Optimus Configuration Notes"
  echo -e "${GREEN}After reboot, you can control GPU mode with:${NC}"
  echo "  optimus-manager --switch nvidia  # Dedicated NVIDIA"
  echo "  optimus-manager --switch hybrid  # Hybrid mode"
  echo "  optimus-manager --switch integrated  # Intel only"
}

# -------------------------
# Main Installation Flow
# -------------------------
main() {
  local gpu_type=$(detect_gpu)

  case $gpu_type in
    "NVIDIA")
      local driver_type=$(choose_nvidia_driver)
      [[ "$driver_type" != "skip" ]] && install_nvidia_driver "$driver_type"
      ;;
    "AMD")
      install_amd_driver
      ;;
    "Optimus")
      setup_optimus
      ;;
    "Intel")
      install_intel_driver
      ;;
    "None")
      print_warning "No dedicated GPU detected - using default modesetting driver"
      ;;
  esac

  if [[ "$gpu_type" =~ (NVIDIA|Optimus) ]]; then
    print_success "GPU setup complete!"
    echo -e "${YELLOW}➤ A reboot is required for NVIDIA changes to take effect${NC}"
  else
    print_success "GPU setup completed successfully"
  fi
}

# Only execute if run directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
