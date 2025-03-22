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
```

# INSTALL JETBRAINS NERD FONT
```bash
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && sudo unzip JetBrainsMono.zip -d /usr/share/fonts/truetype/ && sudo rm -rf JetBrainsMono.zip
```

# INSTALL FASTFETCH, BAT, FZF, EZA, YAZI, MARP, LAZYGIT, ZOXIDE, ZSH-SYNTAX-HIGHLIGHTING, ZSH-AUTOSUGGESTIONS, NEOVIM, TMUX, BUN, YARN OH MY POSH, FFMPEG, WEBP

```bash
brew install bat ffmpeg webp
```