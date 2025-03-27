install_ai() {
  # Install Ollama (if not already installed)
  install_or_skip "ollama" 'curl -fsSL https://ollama.com/install.sh | sh' "Installing Ollama"

  install_or_skip "chatbox" 'yay -S chatbox-bin' "Installing Chatbox"
  # Pull Ollama models after installation
  if command_exists ollama; then
    pull_ollama_models
  else
    print_error "Ollama not found. Skipping model pull."
  fi
}

