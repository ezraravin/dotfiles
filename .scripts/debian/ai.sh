#!/bin/bash
sudo apt install -y curl
curl -fsSL https://ollama.com/install.sh | sh
curl -fsSL https://get.casaos.io | sudo bash
ollama pull deepseek-r1:1.5b
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
