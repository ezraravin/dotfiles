#!/bin/bash

# ANSI color codes for colorful output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print a header with a message
print_header() {
  echo -e "${GREEN}"
  echo "===================================================================="
  echo -e "$1"
  echo "===================================================================="
  echo -e "${NC}"
}

# Function to print a section with a message
print_section() {
  echo -e "${BLUE}"
  echo "--------------------------------------------------------------------"
  echo -e "$1"
  echo "--------------------------------------------------------------------"
  echo -e "${NC}"
}

# Function to print a success message
print_success() {
  echo -e "${GREEN}[SUCCESS] $1${NC}"
}

# Function to print a warning message
print_warning() {
  echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Function to print an error message
print_error() {
  echo -e "${RED}[ERROR] $1${NC}"
}

# Set the Android SDK path (update this if your SDK is installed elsewhere)
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Set JDK 17 as the default Java version
print_header "Setting JDK 17 as the default Java version..."
sudo archlinux-java set java-17-openjdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
print_success "JDK 17 is now the default Java version."

# Function to install platform-tools
install_platform_tools() {
  print_section "Installing platform-tools..."
  yes | sdkmanager "platform-tools"
  print_success "Platform-tools installed successfully."
}

# Function to install the latest build-tools
install_latest_build_tools() {
  print_section "Finding the latest build-tools version..."
  LATEST_BUILD_TOOLS=$(sdkmanager --list | grep "build-tools;" | awk '{print $1}' | sort -V | tail -n 1)

  if [ -z "$LATEST_BUILD_TOOLS" ]; then
    print_error "No build-tools found."
    exit 1
  fi

  print_section "Installing $LATEST_BUILD_TOOLS..."
  sdkmanager "$LATEST_BUILD_TOOLS"
  print_success "Build-tools $LATEST_BUILD_TOOLS installed successfully."

  echo -e "${BLUE}Installed build-tools:${NC}"
  sdkmanager --list_installed | grep "build-tools;"
}

# Function to install the latest Android platform
install_latest_android_platform() {
  print_section "Finding the latest Android platform..."
  LATEST_PLATFORM=$(sdkmanager --list | grep "platforms;android" | awk '{print $1}' | sort -V | tail -n 1)

  if [ -z "$LATEST_PLATFORM" ]; then
    print_error "No Android platforms found."
    exit 1
  fi

  print_section "Installing latest Android platform: $LATEST_PLATFORM..."
  yes | sdkmanager "$LATEST_PLATFORM"
  print_success "Android platform $LATEST_PLATFORM installed successfully."
}

# Function to verify installed components
verify_installed_components() {
  print_section "Verifying installed components..."
  sdkmanager --list_installed
  print_success "Installed components verified."
}

# Main script execution
print_header "Starting Android SDK setup..."
install_platform_tools
install_latest_build_tools
install_latest_android_platform
verify_installed_components

# Accept Android licenses
print_section "Accepting Android licenses..."
yes | flutter doctor --android-licenses
print_success "Android licenses accepted."

print_header "Android SDK setup complete!"
