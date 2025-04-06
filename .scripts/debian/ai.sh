#!/bin/bash
sudo apt install -y curl git
curl -fsSL https://ollama.com/install.sh | sh

ollama pull deepseek-r1:1.5b
ollama pull deepseek-r1

# This one below is working, change the connection for ollama API to http://localhost:11434

# Open Web UI
docker run -d --network=host -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

# OPEN WEB UI with NVIDIA
```bash
docker run -d --network=host --gpus all -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```

# Bolt AI Coder
git clone -b stable https://github.com/stackblitz-labs/bolt.diy.git
cd bolt.diy && pnpm install && pnpm run dev --open --host
