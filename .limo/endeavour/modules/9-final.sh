# Final update
sudo pacman -Syu --noconfirm
sudo pacman -Sc --noconfirm
curl -fsSL "https://raw.githubusercontent.com/ezraravinmateus/dotfiles/refs/heads/main/.zshrc" >~/.zshrc
fc-cache -fv

# Reboot prompt
echo "🎉 Setup complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
