#!/bin/sh
read -p "Enter Deepseek API key: " key
echo "export DEEPSEEK_API_KEY=\"$key\"" >>~/.zshenv && source ~/.zshenv
yay -S --noconfirm chatbox-bin
