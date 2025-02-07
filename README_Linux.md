# MAKE KEYGEN

```bash
ssh-keygen -t ed25519 -C "ezraravin.m@gmail.com"
```

# SET DIALOUT FOR SERIAL ACCESS

```bash
sudo usermod -a -G dialout $USER
```

# ENABLE DRM KERNEL MODE SETTING

```bash
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia-drm.conf
```

# INSTALL WAYBAR, HYPRLAND, HYPRPAPER, GOOGLE CHROME, KITTY, KDENLIVE, OBS, ZSH, WL CLIPBOARD, DEV TOOLS, CAVA, VA API SUPPORT, SNAP

```bash
sudo dnf install -y waybar hyprland hyprpaper google-chrome-stable kitty kdenlive obs-studio zsh wl-clipboard development-tools cava libva-nvidia-driver snapd
```

# CONFIGURE SNAP

```bash
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install core
```

# CHANGE SHELL TO ZSH

```bash
chsh -s $(which zsh)
```

# INSTALL OH MY ZSH

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# INSTALL HOMEBREW

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gcc
```

# INSTALL SPOTIFY

```bash
flatpak install -y flathub com.spotify.Client
```

# INSTALL FLUTTER SDK

```bash
sudo snap install flutter --classic
```

# INSTALL GEAR LEVER

```bash
flatpak install flathub it.mijorus.gearlever
```

# INSTALL JETBRAINS NERD FONT

```bash
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && sudo unzip JetBrainsMono.zip -d /usr/share/fonts/truetype/ && sudo rm -rf JetBrainsMono.zip
```

# INSTALL FASTFETCH, BAT, FZF, EZA, YAZI, MARP, LAZYGIT, ZOXIDE, ZSH-SYNTAX-HIGHLIGHTING, ZSH-AUTOSUGGESTIONS, NEOVIM, TMUX, BUN, YARN OH MY POSH, PHP, COMPOSER

```bash
brew install fastfetch bat fzf eza yazi marp-cli lazygit zoxide zsh-syntax-highlighting zsh-autosuggestions neovim tmux oven-sh/bun/bun yarn jandedobbeleer/oh-my-posh/oh-my-posh php composer
```

# REMOVE BLOATWARE

```bash
sudo dnf remove -y rhythmbox ptyxis mediawriter totem yelp firefox libreoffice-impress libreoffice-calc libreoffice-writer snapshot snapshot gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-calculatr gnome-boxes gnome-characters gnome-tour gnome-text-editor gnome-software gnome-abrt gnome-calculator
```

# INSTALL TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

# UPDATE & UPGRADE

```bash
sudo dnf update --refresh && sudo dnf upgrade --refresh
sudo dnf install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf makecache && sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
sudo reboot
```
