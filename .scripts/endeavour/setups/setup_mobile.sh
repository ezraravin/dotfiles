#!/bin/bash
# setup_mobile.sh - Mobile Development Setup
# Description:
#   Installs Flutter and Android development environment:
#   - Flutter SDK
#   - Android Studio
#   - Android SDK tools
#   - Java JDKs
#   - Automatic license acceptance

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_mobile() {
  print_header "📱 Mobile Development Setup"

  local packages=(
    flutter                # Cross-platform SDK
    android-studio         # Official IDE
    android-sdk            # Core tools
    android-platform-tools # ADB/fastboot
    jdk17-openjdk          # Current Java version
    jdk8-openjdk           # Legacy Android support
  )

  # Install main packages via yay (AUR)
  for pkg in "${packages[@]}"; do
    install_or_skip "$pkg" "yay -S --noconfirm $pkg" "$pkg"
  done

  # Android environment configuration
  print_section "⚙️ Android SDK Setup"
  export ANDROID_HOME=/opt/android-sdk
  export PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

  # License acceptance
  print_section "📝 Accepting Licenses"
  yes | sdkmanager --licenses
  yes | flutter doctor --android-licenses

  print_success "Mobile development ready"
  echo -e "${YELLOW}Run 'flutter doctor' for verification${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_mobile
