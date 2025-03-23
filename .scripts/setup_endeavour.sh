#!/bin/bash

# Enable error handling and verbose output
set -e
set -o pipefail
exec > >(tee -i setup.log) 2>&1

##############################################
### Cleanup Function
##############################################
cleanup() {
  exit_status=$?
  if [ $exit_status -eq 0 ]; then
    echo "✅ Installation successful. Setup.log has been deleted."
    rm -f setup.log
  else
    echo "❌ Installation failed. Error details from setup.log:"
  fi
}

trap cleanup EXIT

##############################################
### Helper Functions
##############################################

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install a package if it doesn't exist
install_if_missing() {
  local package=$1
  local install_command=$2

  if ! command_exists "$package"; then
    echo "  ↳ Installing $package..."
    eval "$install_command"
  else
    echo "  ↳ $package already installed."
  fi
}

# Function to execute a command and skip if it fails
run_or_skip() {
  local description=$1
  local command=$2

  echo "  ↳ $description..."
  if eval "$command"; then
    echo "  ✅ Success: $description"
  else
    echo "  ❌ Failed: $description. Skipping..."
  fi
}

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
  echo -e "\$1"
  echo "===================================================================="
  echo -e "${NC}"
}

# Function to print a section with a message
print_section() {
  echo -e "${BLUE}"
  echo "--------------------------------------------------------------------"
  echo -e "\$1"
  echo "--------------------------------------------------------------------"
  echo -e "${NC}"
}

# Function to print a success message
print_success() {
  echo -e "${GREEN}[SUCCESS] \$1${NC}"
}

# Function to print a warning message
print_warning() {
  echo -e "${YELLOW}[WARNING] \$1${NC}"
}

# Function to print an error message
print_error() {
  echo -e "${RED}[ERROR] \$1${NC}"
}

##############################################
### Git Configuration Function
##############################################
configure_git() {
  echo "🔧 Configuring Git..."

  # Check if Git is already configured
  if git config --global --get user.email &>/dev/null &&
    git config --global --get user.name &>/dev/null &&
    git config --global --get init.defaultBranch &>/dev/null; then
    echo "  ↳ Git is already configured. Skipping..."
    return
  fi

  # Prompt for Git configuration if not already set
  echo "🔧 Customizable Configuration"
  read -p "Enter your Git email: " GIT_EMAIL
  read -p "Enter your Git name: " GIT_NAME
  read -p "Enter your default Git branch (e.g., main): " GIT_BRANCH

  # Configure Git
  run_or_skip "Setting Git email" "git config --global user.email '$GIT_EMAIL'"
  run_or_skip "Setting Git name" "git config --global user.name '$GIT_NAME'"
  run_or_skip "Setting default Git branch" "git config --global init.defaultBranch '$GIT_BRANCH'"
}

##############################################
### Prompt for Sudo Password
##############################################
echo "🔐 Enter your sudo password to proceed:"
sudo -v

##############################################
### System Configuration
##############################################
configure_system() {
  echo "⚙️ Configuring System Settings..."

  # Enable Bluetooth
  run_or_skip "Enabling Bluetooth" 'sudo systemctl start bluetooth && sudo systemctl enable bluetooth'
}

##############################################
### Package Management Setup
##############################################
setup_package_management() {
  echo "📦 Setting Up Package Management..."

  # Install Yay (AUR helper)
  run_or_skip "Installing Yay" 'sudo pacman -S --noconfirm base-devel git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay'
}

##############################################
### Development Environment Setup
##############################################
setup_development_environment() {
  echo "👨💻 Setting Up Development Environment..."

  # Install PHP, Composer, Laravel
  run_or_skip "Installing PHP, Composer, Laravel" '/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"'

  # Install Node.js, Bun, and Yarn
  run_or_skip "Installing npm, Node.js, Bun, pnpm, yarn" 'sudo pacman -S --noconfirm npm nodejs pnpm yarn && curl -fsSL https://bun.sh/install | bash'

  # Install Python
  run_or_skip "Installing Python" 'sudo pacman -S --noconfirm python'
}

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

##############################################
### Application Installation
##############################################
install_applications() {
  echo "📦 Installing Applications..."

  # Install Brave Browser
  run_or_skip "Installing Brave Browser" 'curl -fsS https://dl.brave.com/install.sh | sh'

  # Install Ollama (if not already installed)
  if ! command_exists ollama; then
    run_or_skip "Installing Ollama" 'curl -fsSL https://ollama.com/install.sh | sh'
  else
    echo "  ↳ Ollama already installed. Skipping..."
  fi
}

##############################################
### Shell Environment Setup
##############################################
setup_shell_environment() {
  echo "🐚 Configuring Shell Environment..."

  # Install Zsh
  run_or_skip "Installing Zsh" 'sudo pacman -S --noconfirm zsh'

  # Install Oh My Zsh (if not already installed)
  if [[ ! -d ~/.oh-my-zsh ]]; then
    run_or_skip "Installing Oh My Zsh" 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
  else
    echo "  ↳ Oh My Zsh already installed. Skipping..."
  fi

  # Change default shell to Zsh
  run_or_skip "Changing default shell to Zsh" 'sudo chsh -s $(which zsh) $USER'

  # Install Zsh plugins
  run_or_skip "Installing Zsh plugins" 'sudo pacman -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions'

  # Install Zoxide
  run_or_skip "Installing Zoxide" 'curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh'

  # Install Oh My Posh
  run_or_skip "Installing Oh My Posh" 'curl -s https://ohmyposh.dev/install.sh | bash -s'

  # Install TPM (Tmux Plugin Manager)
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    run_or_skip "Installing TPM (Tmux Plugin Manager)" 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'
  else
    echo "  ↳ TPM already installed. Skipping..."
  fi

  # Automate Tmux Plugin Installation and Reload
  echo "  ↳ Setting up Tmux plugins and reloading configuration..."
  if command_exists tmux; then
    # Install plugins (ignore errors if some plugins are already installed)
    if tmux run-shell ~/.tmux/plugins/tpm/bin/install_plugins; then
      echo "  ✅ Tmux plugins installed successfully."
    else
      echo "  ⚠️ Some Tmux plugins were already installed. Continuing..."
    fi

    # Reload Tmux configuration
    if tmux source-file ~/.tmux.conf; then
      echo "  ✅ Tmux configuration reloaded successfully."
    else
      echo "  ❌ Failed to reload Tmux configuration. Skipping..."
    fi
  else
    echo "  ❌ Tmux not found. Skipping Tmux setup."
  fi
}

##############################################
### Git & Dotfiles Configuration
##############################################
configure_git_and_dotfiles() {
  echo "🔧 Configuring Git & Dotfiles..."

  # Configure Git
  configure_git

  # Clone and apply dotfiles
  run_or_skip "Cloning and applying dotfiles" 'git clone git@gitlab.com:ezraravinmateus/dotfiles.git "$HOME/dotfiles" && rsync -a "$HOME/dotfiles/." "$HOME/" && rm -rf "$HOME/dotfiles"'
}

##############################################
### Finalize System Setup
##############################################
finalize_system_setup() {
  echo "🔧 Finalizing System Setup..."

  # Install NVIDIA Drivers
  run_or_skip "Installing NVIDIA Drivers" 'sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings'

  # Update system
  run_or_skip "Updating system" 'sudo pacman -Syu --noconfirm'
}

##############################################
### Main Execution Flow
##############################################
main() {
  # Extend sudo timeout to 1 hour (3600 seconds)
  sudo -v
  while true; do
    sudo -n true
    sleep 300
    kill -0 "$$" || exit
  done 2>/dev/null &

  configure_git
  configure_system
  install_applications
  setup_shell_environment
  setup_package_management
  configure_git_and_dotfiles
  setup_development_environment
  setup_mobile_development

  # Finalize system setup (NVIDIA drivers and system update)
  finalize_system_setup

  echo "✅ Setup complete! Some changes may require a restart."
  echo "🔍 Review installation log: setup.log"
}

# Start the main
