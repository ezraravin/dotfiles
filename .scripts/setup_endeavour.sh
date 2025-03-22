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
  else
    echo "❌ Installation failed. Error details from setup.log:"
    cat setup.log
  fi
  rm -f setup.log
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

##############################################
### System Configuration
##############################################
configure_system() {
  echo "⚙️ Configuring System Settings..."

  # Enable Bluetooth
  echo "  ↳ Enabling Bluetooth..."
  sudo systemctl start bluetooth
  sudo systemctl enable bluetooth
}

##############################################
### Package Management Setup
##############################################
setup_package_management() {
  echo "📦 Setting Up Package Management..."

  # Install Yay (AUR helper)
  if ! command_exists yay; then
    echo "  ↳ Installing Yay..."
    sudo pacman -S --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd .. && rm -rf yay
  else
    echo "  ↳ Yay already installed."
  fi

  # Update system
  echo "  ↳ Updating system..."
  sudo pacman -Syu --noconfirm
}

##############################################
### Development Environment Setup
##############################################
setup_development_environment() {
  echo "👨💻 Setting Up Development Environment..."

  # Install PHP, Composer, Laravel
  echo "  ↳ Installing PHP, Composer, Laravel..."
  /bin/bash -c "$(curl -fsSL https://php.new/install/linux)"

  # Install Node.js, Bun, and Yarn
  echo "  ↳ Installing npm, Node.js, Bun, pnpm, yarn..."
  install_if_missing node 'sudo pacman -S --noconfirm npm nodejs pnpm yarn'
  install_if_missing bun 'curl -fsSL https://bun.sh/install | bash'

  # Install Python
  echo "  ↳ Installing Python..."
  install_if_missing python 'sudo pacman -S --noconfirm python'
}

##############################################
### Mobile Development Setup
##############################################

setup_mobile_development() {
  echo "📱 Setting Up Mobile Development..."

  # Install Flutter
  echo "  ↳ Installing Flutter..."
  install_if_missing flutter 'yay -S --noconfirm flutter'

  # Install Android Studio and SDK
  echo "  ↳ Installing Android Studio and SDK..."
  install_if_missing android-studio 'yay -S --noconfirm android-studio android-sdk android-sdk-build-tools android-sdk-cmdline-tools-latest'

  # Add sdkmanager to PATH
  export PATH="$HOME/Android/Sdk/cmdline-tools/latest/bin:$PATH"

  # Verify sdkmanager is installed
  if ! command_exists sdkmanager; then
    echo "❌ sdkmanager not found. Please ensure Android SDK is installed correctly."
    exit 1
  fi

  # Set up Android licenses
  echo "  ↳ Accepting Android licenses..."
  if ! yes | sdkmanager --licenses; then
    echo "❌ Failed to accept Android licenses. Please check the logs."
    exit 1
  fi

  # Install JDK
  echo "  ↳ Installing JDK..."
  sudo pacman -S --noconfirm jdk8-openjdk jdk17-openjdk
  sudo archlinux-java set java-17-openjdk
}

##############################################
### Application Installation
##############################################
install_applications() {
  echo "📦 Installing Applications..."

  # Install Brave Browser (official method)
  echo "  ↳ Installing Brave Browser..."
  install_if_missing brave 'curl -fsS https://dl.brave.com/install.sh | sh'

  # Install Ollama
  echo "  ↳ Installing Ollama..."
  install_if_missing ollama 'curl -fsSL https://ollama.com/install.sh | sh'

  # Install NVIDIA Drivers
  echo "  ↳ Installing NVIDIA Drivers..."
  install_if_missing nvidia-settings 'sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings'
}

##############################################
### Shell Environment Setup
##############################################
setup_shell_environment() {
  echo "🐚 Configuring Shell Environment..."

  # Install Zsh and Oh My Zsh
  echo "  ↳ Installing Zsh and Oh My Zsh..."
  install_if_missing zsh 'sudo pacman -S --noconfirm zsh'

  echo "  ↳ Changed shell to ZSH"
  sudo chsh -s $(which zsh) $USER

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Install Zsh plugins
  echo "  ↳ Installing Zsh plugins..."
  sudo pacman -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions

  # Install Zoxide
  echo "  ↳ Installing Zoxide..."
  install_if_missing zoxide 'curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh'

  # Install Oh My Posh
  echo "  ↳ Installing Oh My Posh..."
  install_if_missing oh-my-posh 'curl -s https://ohmyposh.dev/install.sh | bash -s'
}

##############################################
### Git & Dotfiles Configuration
##############################################
configure_git_and_dotfiles() {
  echo "🔧 Configuring Git & Dotfiles..."

  # Configure Git
  echo "  ↳ Configuring Git..."
  git config --global user.email "ezraravin@proton.me"
  git config --global user.name "Rave's Endeavour"
  git config --global init.defaultBranch main

  # Clone and apply dotfiles
  echo "  ↳ Cloning and applying dotfiles..."
  if [[ ! -d "$HOME/dotfiles" ]]; then
    git clone git@gitlab.com:ezraravinmateus/dotfiles.git "$HOME/dotfiles"
    rsync -a "$HOME/dotfiles/." "$HOME/"
    rm -rf "$HOME/dotfiles"
  fi
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

  configure_system
  install_applications
  setup_shell_environment
  setup_package_management
  configure_git_and_dotfiles
  setup_development_environment
  setup_mobile_development

  echo "✅ Setup complete! Some changes may require a restart."
  echo "🔍 Review installation log: setup.log"
}

# Start the main process
main
