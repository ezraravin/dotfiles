##############################################
### Mobile Development Setup
##############################################

setup_mobile_development() {
  print_header "📱 Setting Up Mobile Development..."

  # Install Flutter
  install_or_skip "flutter" 'yay -S --noconfirm flutter' "Installing Flutter"

  # Install Android Studio and SDK
  install_or_skip "android-studio" 'yay -S --noconfirm android-studio android-sdk android-sdk-build-tools android-sdk-cmdline-tools-latest' "Installing Android Studio and SDK"

  # Set the Android SDK path
  export ANDROID_HOME=/opt/android-sdk
  export PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

  # Install JDK 8 and JDK 17
  print_header "Installing JDK 8 and JDK 17..."
  install_or_skip "jdk8" 'sudo pacman -S --noconfirm jdk8-openjdk' "Installing JDK 8"
  install_or_skip "jdk17" 'sudo pacman -S --noconfirm jdk17-openjdk' "Installing JDK 17"

  # Temporarily switch to JDK 8 for Android SDK tools
  print_header "Temporarily switching to JDK 8 for Android SDK tools..."
  sudo archlinux-java set java-8-openjdk
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
  print_success "Temporarily using JDK 8."

  # Install platform-tools
  print_section "Installing platform-tools..."
  install_or_skip "platform-tools" 'yes | sdkmanager "platform-tools"' "Installing platform-tools"
  print_success "Platform-tools installed successfully."

  # Find and install the latest build-tools
  print_section "Finding the latest build-tools version..."
  LATEST_BUILD_TOOLS=$(sdkmanager --list | grep "build-tools;" | awk '{print $1}' | sort -V | tail -n 1)

  if [ -z "$LATEST_BUILD_TOOLS" ]; then
    print_error "No build-tools found."
  else
    print_section "Installing $LATEST_BUILD_TOOLS..."
    install_or_skip "build-tools" "yes | sdkmanager \"$LATEST_BUILD_TOOLS\"" "Installing build-tools"
    print_success "Build-tools $LATEST_BUILD_TOOLS installed successfully."
    echo -e "${BLUE}Installed build-tools:${NC}"
    sdkmanager --list_installed | grep "build-tools;"
  fi

  # Find and install the latest Android platform
  print_section "Finding the latest Android platform..."
  LATEST_PLATFORM=$(sdkmanager --list | grep "platforms;android" | awk '{print $1}' | sort -V | tail -n 1)

  if [ -z "$LATEST_PLATFORM" ]; then
    print_error "No Android platforms found."
  else
    print_section "Installing latest Android platform: $LATEST_PLATFORM..."
    install_or_skip "platform" "yes | sdkmanager \"$LATEST_PLATFORM\"" "Installing Android platform"
    print_success "Android platform $LATEST_PLATFORM installed successfully."
  fi

  # Verify installed components
  print_section "Verifying installed components..."
  sdkmanager --list_installed
  print_success "Installed components verified."

  # Accept Android licenses
  print_section "Accepting Android licenses..."
  install_or_skip "android-licenses" 'yes | flutter doctor --android-licenses' "Accepting Android licenses"
  print_success "Android licenses accepted."

  # Switch back to JDK 17
  print_header "Switching back to JDK 17..."
  sudo archlinux-java set java-17-openjdk
  export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
  print_success "JDK 17 is now the default Java version."

  print_header "Android SDK setup complete!"
}
