#!/bin/bash
sudo apt get -y curl
curl -fsSL https://ollama.com/install.sh | sh
ollama pull deepseek-r1:1.5b
curl -fsSL https://get.casaos.io | sudo bash
