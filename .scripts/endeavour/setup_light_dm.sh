sudo pacman -S lightdm lightdm-gtk-greeter lightdm-webkit2-greeter
sudo systemctl enable lightdm
sudo systemctl set-default graphical.target
