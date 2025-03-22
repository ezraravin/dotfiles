# Clone Project Files

```bash
mkdir Projects
git clone git@gitlab.com:ezraravinmateus/notes
mv notes Projects/Notes
```

# SET THEME TO DRACULA

```bash
sudo git clone https://github.com/dracula/gtk/ /usr/share/themes/Dracula
gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
```

# SET DIALOUT FOR SERIAL ACCESS

```bash
sudo usermod -a -G dialout $USER
```

# ENABLE DRM KERNEL MODE SETTING

```bash
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia-drm.conf
```

# INSTALL XAMPP

```bash
sudo dnf -y install libnsl libxcrypt-compat
wget https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run
chmod a+x xampp-linux-x64-*-installer.run
sudo ./xampp-linux-x64-*-installer.run
sudo rm xampp-linux-x64-*-installer.run
```


# INSTALL WAYBAR, HYPRLAND, HYPRPAPER, KITTY, KDENLIVE, OBS, ZSH, WL CLIPBOARD, DEV TOOLS, CAVA, VA API SUPPORT, SNAP, PAVUCONTROL, BLUEMAN, G++

```bash
sudo dnf install -y hyprpaper kdenlive wl-clipboard development-tools cava libva-nvidia-driver snapd vlc pavucontrol blueman g++
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

# INSTALL WHATSAPP

```bash
sudo snap install whatsapp-linux-app
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

# INSTALL FASTFETCH, BAT, FZF, EZA, YAZI, MARP, LAZYGIT, ZOXIDE, ZSH-SYNTAX-HIGHLIGHTING, ZSH-AUTOSUGGESTIONS, NEOVIM, TMUX, BUN, YARN OH MY POSH, FFMPEG, WEBP

```bash
brew install bat fzf eza yazi marp-cli lazygit zoxide ffmpeg webp
```
# REMOVE BLOATWARE

```bash
sudo dnf remove -y rhythmbox ptyxis mediawriter totem yelp firefox libreoffice-impress libreoffice-calc libreoffice-writer snapshot snapshot gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-calculatr gnome-boxes gnome-characters gnome-tour gnome-text-editor gnome-software gnome-abrt gnome-calculator
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
