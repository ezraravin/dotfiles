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
    print_success "Installation successful. Setup.log has been deleted."
    rm -f setup.log
  else
    print_error "Installation failed. Error details from setup.log:"
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

# Combined function to install a package if missing or skip if already installed
install_or_skip() {
  local package=$1
  local install_command=$2
  local description=$3

  if ! command_exists "$package"; then
    print_section "  ↳ $description..."
    echo "  ↳ Installing $package..."
    if eval "$install_command"; then
      print_success "$description"
    else
      print_error "$description"
    fi
  else
    echo "  ↳ $package already installed. Skipping..."
  fi
}

# Function to pull Ollama models
pull_ollama_models() {
  print_header "📥 Pulling Ollama Models..."

  # List of models to pull
  local models=("deepseek-r1" "qwen2.5" "qwen2.5-coder" "deepseek-coder-v2" "deepseek-llm" "deepseek-v2")

  for model in "${models[@]}"; do
    print_section "  ↳ Pulling $model..."
    if ollama pull "$model"; then
      print_success "Successfully pulled $model."
    else
      print_error "Failed to pull $model."
    fi
  done
}

# ANSI color codes for colorful output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print a header with a message
print_header() {
  local message=$1
  echo -e "${GREEN}"
  echo "===================================================================="
  echo -e "$message"
  echo "===================================================================="
  echo -e "${NC}"
}

# Function to print a section with a message
print_section() {
  local message=$1
  echo -e "${BLUE}"
  echo "--------------------------------------------------------------------"
  echo -e "$message"
  echo "--------------------------------------------------------------------"
  echo -e "${NC}"
}

# Function to print a success message
print_success() {
  local message=$1
  echo -e "${GREEN}✅ Success: $message${NC}."
}

# Function to print a warning message
print_warning() {
  local message=$1
  echo -e "${YELLOW}⚠️ Warning: $message${NC}."
}

# Function to print an error message
print_error() {
  local message=$1
  echo -e "${RED}❎ Error: $message${NC}"
}

##############################################
### Git Configuration Function
##############################################
configure_git() {
  print_header "🔧 Configuring Git..."

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
  install_or_skip "git" "git config --global user.email '$GIT_EMAIL'" "Setting Git email"
  install_or_skip "git" "git config --global user.name '$GIT_NAME'" "Setting Git name"
  install_or_skip "git" "git config --global init.defaultBranch '$GIT_BRANCH'" "Setting default Git branch"
}

##############################################
### Prompt for Sudo Password
##############################################
print_header "🔐 Enter your sudo password to proceed:"
sudo -v

##############################################
### System Configuration
##############################################
configure_system() {
  print_header "⚙️ Configuring System Settings..."

  # Enable Bluetooth
  install_or_skip "bluetooth" "sudo systemctl start bluetooth && sudo systemctl enable bluetooth" "Enabling Bluetooth"
}

##############################################
### Package Management Setup
##############################################
setup_package_management() {
  print_header "📦 Setting Up Package Management..."

  # Install Yay (AUR helper)
  install_or_skip "yay" "sudo pacman -S --noconfirm base-devel git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay" "Installing Yay"
}

##############################################
### Development Environment Setup
##############################################
setup_development_environment() {
  print_header "👨💻 Setting Up Development Environment..."

  # Install PHP, Composer, Laravel
  install_or_skip "php" '/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"' "Installing PHP, Composer, Laravel"

  # Install Node.js, Bun, and Yarn
  install_or_skip "npm" 'sudo pacman -S --noconfirm npm nodejs pnpm yarn && curl -fsSL https://bun.sh/install | bash' "Installing npm, Node.js, Bun, pnpm, yarn"

  # Install Python
  install_or_skip "python" 'sudo pacman -S --noconfirm python' "Installing Python"
}

##############################################
### Application Installation
##############################################
install_applications() {
  print_header "📦 Installing Applications..."

  # Install Brave Browser
  install_or_skip "brave" 'curl -fsS https://dl.brave.com/install.sh | sh' "Installing Brave Browser"
}

install_ai() {
  # Install Ollama (if not already installed)
  install_or_skip "ollama" 'curl -fsSL https://ollama.com/install.sh | sh' "Installing Ollama"

  # Pull Ollama models after installation
  if command_exists ollama; then
    pull_ollama_models
  else
    print_error "Ollama not found. Skipping model pull."
  fi
}

##############################################
### Shell Environment Setup
##############################################
setup_shell_environment() {
  print_header "🐚 Configuring Shell Environment..."

  # Install Zsh
  install_or_skip "zsh" 'sudo pacman -S --noconfirm zsh' "Installing Zsh"

  # Install Oh My Zsh (if not already installed)
  if [[ ! -d ~/.oh-my-zsh ]]; then
    install_or_skip "oh-my-zsh" 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' "Installing Oh My Zsh"
  else
    echo "  ↳ Oh My Zsh already installed. Skipping..."
  fi

  # Change default shell to Zsh
  install_or_skip "zsh" 'sudo chsh -s $(which zsh) $USER' "Changing default shell to Zsh"

  # Install Zsh plugins
  install_or_skip "zsh-syntax-highlighting" 'sudo pacman -S --noconfirm zsh-syntax-highlighting' "Installing Zsh syntax highlighting"
  install_or_skip "zsh-autosuggestions" 'sudo pacman -S --noconfirm zsh-autosuggestions' "Installing Zsh autosuggestions"

  # Install Zoxide
  install_or_skip "zoxide" 'curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh' "Installing Zoxide"

  # Install Oh My Posh
  install_or_skip "oh-my-posh" 'curl -s https://ohmyposh.dev/install.sh | bash -s' "Installing Oh My Posh"

  # Install TPM (Tmux Plugin Manager)
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    install_or_skip "tpm" 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm' "Installing TPM (Tmux Plugin Manager)"
  else
    echo "  ↳ TPM already installed. Skipping..."
  fi

  # Automate Tmux Plugin Installation and Reload
  echo "  ↳ Setting up Tmux plugins and reloading configuration..."
  if command_exists tmux; then
    # Install plugins (ignore errors if some plugins are already installed)
    if tmux run-shell ~/.tmux/plugins/tpm/bin/install_plugins; then
      print_success "Tmux plugins installed successfully."
    else
      print_warning "Some Tmux plugins were already installed. Continuing..."
    fi

    # Reload Tmux configuration
    if tmux source-file ~/.tmux.conf; then
      print_success "Tmux configuration reloaded successfully."
    else
      print_error "Failed to reload Tmux configuration. Skipping..."
    fi
  else
    print_error "Tmux not found. Skipping Tmux setup."
  fi
}

##############################################
### Git & Dotfiles Configuration
##############################################
configure_dotfiles() {
  print_header "🔧 Configuring Git & Dotfiles..."

  # Clone and apply dotfiles
  install_or_skip "dotfiles" 'git clone git@gitlab.com:ezraravinmateus/dotfiles.git "$HOME/dotfiles" && rsync -a "$HOME/dotfiles/." "$HOME/" && rm -rf "$HOME/dotfiles"' "Cloning and applying dotfiles"
}

##############################################
### Finalize System Setup
##############################################
finalize_system_setup() {
  print_header "🔧 Finalizing System Setup..."

  # Update system
  install_or_skip "system-update" 'sudo pacman -Syu --noconfirm' "Updating system"
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
  configure_dotfiles
  install_applications
  setup_shell_environment
  setup_package_management
  setup_development_environment
  finalize_system_setup
  sudo reboot

  print_success "Setup complete! Some changes may require a restart."
  echo "🔍 Review installation log: setup.log"
}

# Start the main
main
