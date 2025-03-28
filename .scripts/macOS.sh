##############################################
### Application Installation
##############################################
install_applications() {
  echo "📦 Installing Applications..."

  # JetBrains Nerd Font Mono
  brew install --cask font-jetbrains-mono-nerd-font
}

##############################################
### Shell Environment Setup
##############################################
setup_shell_environment() {
  echo "🐚 Configuring Shell Environment..."

  # PDF Support for Markdown to PDF
  brew install basictex pandoc

}
