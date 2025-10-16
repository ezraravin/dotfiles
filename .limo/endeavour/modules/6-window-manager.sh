# Window Managers
echo "🌊 Hyprland & Sway Setup"
sudo pacman -S --noconfirm hyprland hyprpaper hypridle hyprsunset hyprlock waybar wofi grim slurp wl-clipboard libnotify
yay -S --noconfirm sway swaybg
sudo sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=lock/' /etc/systemd/logind.confa
sudo sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=lock/' /etc/systemd/logind.conf
sudo systemctl enable dbus
echo "✅ Hyprland installed"
echo "🌊 Sway & SwayFX Setup"
