#!/bin/bash
# setup_mobile.sh - Mobile Development

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_mobile() {
  print_header "📱 Mobile Development"

  # Flutter and Android
  local packages=(
    flutter
    android-studio
    android-sdk
    android-platform-tools
    jdk17-openjdk
    jdk8-openjdk
  )

  for pkg in "${packages[@]}"; do
    install_or_skip "$pkg" "yay -S --noconfirm $pkg" "$pkg"
  done

  # Android config
  export ANDROID_HOME=/opt/android-sdk
  yes | sdkmanager --licenses
  flutter doctor --android-licenses

  print_success "Mobile dev setup complete"
  echo "Run 'flutter doctor' for verification"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_mobile
