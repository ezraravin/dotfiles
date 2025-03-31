#!/bin/sh
# read -p "Enter Deepseek API key: " key
# echo "export DEEPSEEK_API_KEY=\"$key\"" >>~/.zshenv && source ~/.zshenv
curl -fsSL https://ollama.com/install.sh | sh
ollama pull deepseek-r1:1.5b

docker run -d -p 3000:8080 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
