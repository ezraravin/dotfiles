#!/bin/bash
# setup_gpu.sh - GPU Driver Configuration
# Description:
#   Auto-detects GPU hardware and installs appropriate drivers:
#   - NVIDIA (LTS/DKMS options)
#   - AMD (Open-source)
#   - Intel (Integrated graphics)
#   - Optimus hybrid setups

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

detect_gpu() {
  print_header "🔍 GPU Hardware Detection"
  # ... (keep existing detection logic)
}

install_nvidia_driver() {
  # ... (keep existing NVIDIA installation)
}

install_amd_driver() {
  # ... (keep existing AMD installation)
}

setup_optimus() {
  # ... (keep existing Optimus setup)
}

main() {
  # ... (keep existing main flow)
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
