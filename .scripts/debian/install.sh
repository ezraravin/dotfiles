#!/bin/bash
# 🚀 Debian 12 Setup Script

# 🔒 Sudo Keepalive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# 🔧 Utility Functions
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# 🛠️ CORE SETUP
echo "🌟 Core Tools Installation"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
sudo apt install -y golang cmake unzip git curl bat ripgrep nautilus btop blueman kitty xwayland

# 🖥️ TERMINAL TOOLS
echo "📟 Fastfetch & Eza"
git clone https://github.com/fastfetch-cli/fastfetch.git
cd fastfetch && mkdir build && cd build
cmake .. && make && sudo make install
cd ~ && rm -rf fastfetch/
cargo install eza

# 🔐 GIT & SSH SETUP
echo "🔑 Git Configuration"
read -p "Use SSH for Git? [y/N]: " ssh_choice
if [[ "$ssh_choice" =~ ^[Yy]$ ]]; then
  read -p "Name for SSH key: " key_name
  ssh-keygen -t ed25519 -C "$key_name" -N "" -f ~/.ssh/id_ed25519
  cat ~/.ssh/id_ed25519.pub
  read -p "Press Enter after adding key to Git account..."
  GIT_CLONE_PREFIX="git@gitlab.com:"
else
  GIT_CLONE_PREFIX="https://gitlab.com/"
fi

# 🏠 DOTFILES
echo "🏡 Dotfiles Setup"
[ ! -d ~/dotfiles ] && git clone $GIT_CLONE_PREFIX/ezraravinmateus/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles

# 🖥️ WINDOW MANAGERS
echo "🌌 Sway & Display"
sudo apt install -y sway waybar wofi grim slurp wl-clipboard sddm
sudo systemctl enable sddm

# 🎮 GPU DRIVERS
echo "🖥️ GPU Setup"
if lspci | grep -i "VGA.*AMD"; then
  sudo apt install -y mesa-vulkan-drivers libvulkan1 ilvulkan-uts
elif lspci | grep -i "VGA.*Intel"; then
  sudo apt install -y mesa-vulkan-drivers libvulkan1
fi

# 💻 DEVELOPMENT
echo "👨💻 Dev Environment"
sudo apt install -y nodejs npm python3 python3-pip yarnpkg yarn docker.io docker-compose visidata
sudo npm install -g pnpm
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
curl -fsSL https://bun.sh/install | bash

# 🐚 SHELL SETUP
echo "🐚 Zsh & Tools"
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions tmux zoxide fzf imagemagick ffmpeg
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl -fsSL "https://ohmyposh.dev/install.sh" | bash -s

# 📺 TMUX
echo "🖥️ Tmux Setup"
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
if [ -f ~/.tmux.conf ]; then
  tmux start-server
  tmux new-session -d
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
  tmux kill-server
fi

# ✏️ EDITORS
echo "📝 Neovim Installation"
sudo apt install -y ninja-build gettext cmake unzip curl
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=Release && sudo make install && cd .. && rm -rf neovim

# 🔠 FONTS
echo "🔤 Font Setup"
sudo mkdir -p /usr/local/share/fonts
sudo wget -P /usr/local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
sudo unzip /usr/local/share/fonts/JetBrainsMono.zip -d /usr/local/share/fonts/JetBrainsMonoNF
sudo rm /usr/local/share/fonts/JetBrainsMono.zip
sudo fc-cache -fv

# 🚀 FINAL SETUP
echo "🎯 Final Touches"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo chsh -s $(which zsh) $USER
curl -fsSL "https://gitlab.com/ezraravinmateus/dotfiles/-/raw/HEAD/.zshrc" >~/.zshrc

# 🔄 REBOOT
echo "🎉 Setup complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
