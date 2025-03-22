# MAKE KEYGEN
```bash
ssh-keygen -t ed25519 -C "Rave's PC"
```

# CONFIG GIT
```bash
git config --global user.email "ezraravin@proton.me" && git config --global user.name "Rave's Endeavour"
```

# INSTALL YAY
```bash
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --version
yay -Syu
cd ..
rm -rf yay
```

# CLONE DOTFILES
```bash
mkdir .config
git clone git@gitlab.com:ezraravinmateus/dotfiles
cd dotfiles
mv .config/* ~/.config && sudo rm -rf .config
mv ./* ~/ && mv ./.* ~/ && cd ../ && rm -rf dotfiles
```

# INSTALL COMPOSER, PHP, LARAVEL
```bash
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
```

# INSTALL BRAVE
```bash
curl -fsS https://dl.brave.com/install.sh | sh
```

# INSTALL OLLAMA
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

# Install NVIDIA
```bash
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
```

# Start Bluetooth Session & Enable Bluetooth By Default
```bash
sudo systemctl start bluetooth
sudo systemctl enable bluetooth
```
# Install Hyprland
```bash
sudo pacman -S --noconfirm hyprland zsh neovim tmux eza waybar obs-studio cava fastfetch yazi lazygit zoxide zsh-syntax-highlighting zsh-autosuggestions yarn fzf eza yazi lazygit
```

# MARP CLI
```bash
yay -S --noconfirm marp-cli spotify spotify-adblock flutter whatsapp-for-linux arduino-ide xampp
```

# ZOXIDE
```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

# INSTALL BUN
```bash
curl -fsSL https://bun.sh/install | bash
```

# INSTALL OH MY POSH
```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

# INSTALL TPM
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

# INSTALL OH MY ZSH
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# CHANGE SHELL TO ZSH
```bash
chsh -s $(which zsh)
```