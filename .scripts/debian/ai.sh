#!/bin/bash
sudo apt install -y curl
curl -fsSL https://ollama.com/install.sh | sh
curl -fsSL https://get.casaos.io | sudo bash
ollama pull deepseek-r1:1.5b
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main

# This one below is working, change the connection for ollama API to localhost:11434
docker run -d --network=host -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
