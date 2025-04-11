#!/bin/bash
# 🚀 Debian 12 Setup Script

# 🔒 Sudo Keepalive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# 🦭 Podman & Podman Compose
sudo apt install -y podman pipx cmake git curl wget bat ripgrep zsh zsh-syntax-highlighting zsh-autosuggestions zoxide fzf ninja-build gettext
sh -c "$(curl -sSL https://raw.githubusercontent.com/containers/podman-compose/main/scripts/download_and_build_podman-compose.sh)"
podman-compose --version
systemctl enable --now podman.socket

# 🛠️ CORE SETUP
echo "🌟 Core Tools Installation"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
cargo install eza

# ✏️ EDITORS
echo "📝 Neovim Installation"
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=Release && sudo make install && cd .. && rm -rf neovim

# 🚀 FINAL SETUP
echo "🎯 Final Touches"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo chsh -s $(which zsh) $USER

echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>.zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>.zshrc

# 🔄 REBOOT
echo "🎉 Setup complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
