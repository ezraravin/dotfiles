#!/bin/bash
# setup_mobile.sh - Comprehensive Mobile Dev Setup (Android/Flutter)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

# -------------------------
# Android SDK Management
# -------------------------
manage_android_sdk() {
  print_header "⚙️ Configuring Android SDK"

  export ANDROID_HOME=/opt/android-sdk
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

  # Install critical components
  local components=(
    "platform-tools"
    "platforms;android-34"
    "build-tools;34.0.0"
    "emulator"
    "patcher;v4"
  )

  for component in "${components[@]}"; do
    if ! sdkmanager --list_installed | grep -q "$component"; then
      print_section "Installing $component..."
      yes | sdkmanager "$component" &&
        print_success "Installed $component" ||
        print_error "Failed to install $component"
    else
      print_warning "$component already installed"
    fi
  done
}

# -------------------------
# Java Environment Setup
# -------------------------
setup_java() {
  print_header "☕ Java Environment Setup"

  # Install JDKs
  local jdks=(
    jdk17-openjdk
    jdk8-openjdk
  )

  for jdk in "${jdks[@]}"; do
    install_or_skip "$jdk" "sudo pacman -S --noconfirm $jdk" "$jdk"
  done

  # Configure Java versions
  print_section "Configuring Java versions..."
  sudo archlinux-java set java-17-openjdk
  export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
}

# -------------------------
# Flutter Post-Install
# -------------------------
setup_flutter() {
  print_header "📱 Flutter Environment"

  # Add Flutter to PATH if not already present
  if ! grep -q "flutter/bin" ~/.zshrc; then
    echo 'export PATH="$PATH:$HOME/flutter/bin"' >>~/.zshrc
  fi

  # Enable Linux desktop support
  flutter config --enable-linux-desktop

  # Run doctor
  print_section "Running Flutter Doctor..."
  flutter doctor -v
}

# -------------------------
# Main Installation Flow
# -------------------------
main() {
  print_header "🚀 Starting Mobile Dev Setup"

  # 1. Install core packages
  print_section "📦 Installing Core Packages"
  local packages=(
    flutter
    android-studio
    android-sdk
    android-sdk-build-tools
    android-sdk-platform-tools
    android-emulator
  )

  for pkg in "${packages[@]}"; do
    install_or_skip "$pkg" "yay -S --noconfirm $pkg" "$pkg"
  done

  # 2. Setup environment
  setup_java
  manage_android_sdk

  # 3. Accept licenses
  print_section "📝 Accepting Android Licenses"
  yes | sdkmanager --licenses
  yes | flutter doctor --android-licenses

  # 4. Flutter setup
  setup_flutter

  print_success "Mobile development setup complete!"
  echo -e "${YELLOW}Next steps:"
  echo "1. Launch Android Studio to complete setup"
  echo "2. Create a virtual device in AVD Manager"
  echo "3. Run 'flutter create my_app' to test"
  echo "4. Source your shell: source ~/.zshrc${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
