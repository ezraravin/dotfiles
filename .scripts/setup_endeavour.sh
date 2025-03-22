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

  # Update system
  run_or_skip "Updating system" 'sudo pacman -Syu --noconfirm'
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
  echo "📱 Setting Up Mobile Development..."

  # Install Flutter
  run_or_skip "Installing Flutter" 'yay -S --noconfirm flutter'

  # Install Android Studio and SDK
  run_or_skip "Installing Android Studio and SDK" 'yay -S --noconfirm android-studio android-sdk android-sdk-build-tools android-sdk-cmdline-tools-latest'

  # Add sdkmanager to PATH
  export PATH="$HOME/Android/Sdk/cmdline-tools/latest/bin:$PATH"

  # Verify sdkmanager is installed
  if ! command_exists sdkmanager; then
    echo "❌ sdkmanager not found. Skipping Android license acceptance."
  else
    # Set up Android licenses
    run_or_skip "Accepting Android licenses" 'yes | sdkmanager --licenses'
  fi

  # Install JDK
  run_or_skip "Installing JDK" 'sudo pacman -S --noconfirm jdk8-openjdk jdk17-openjdk'
  run_or_skip "Setting default JDK to Java 17" 'sudo archlinux-java set java-17-openjdk'
}

##############################################
### Application Installation
##############################################
install_applications() {
  echo "📦 Installing Applications..."

  # Install Brave Browser
  run_or_skip "Installing Brave Browser" 'curl -fsS https://dl.brave.com/install.sh | sh'

  # Install Ollama
  run_or_skip "Installing Ollama" 'curl -fsSL https://ollama.com/install.sh | sh'

  # Install NVIDIA Drivers
  run_or_skip "Installing NVIDIA Drivers" 'sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings'
}

##############################################
### Shell Environment Setup
##############################################
setup_shell_environment() {
  echo "🐚 Configuring Shell Environment..."

  # Install Zsh and Oh My Zsh
  run_or_skip "Installing Zsh and Oh My Zsh" 'sudo pacman -S --noconfirm zsh && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

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
    tmux list-sessions | awk '{print $1}' | xargs -I {} tmux run-shell -t {} ~/.tmux/plugins/tpm/bin/install_plugins
    tmux list-sessions | awk '{print $1}' | xargs -I {} tmux source-file ~/.tmux.conf -t {}
    echo "  ✅ Tmux plugins installed and configuration reloaded."
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
