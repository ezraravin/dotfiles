#!/bin/bash
sudo dnf update && sudo dnf install -y git wget flex bison gperf python3 cmake ninja-build ccache dfu-util libusbx

# CLONE REPOSITORY FOR ESP IDF
git clone --recursive https://github.com/espressif/esp-idf.git ~/esp/esp-idf
cd ~/esp/esp-idf

# USE ESPRESSIF DOWNLOAD SERVER FOR GITHUB ASSETS FOR FASTER DOWNLOAD
export IDF_GITHUB_ASSETS="dl.espressif.com/github_assets"

# INSTALL SCRIPT
./install.sh all

# EXPORT PATH TO SET UP ENVIRONMENT VARIABLES SO THAT YOU CAN CALL "idf-py build" FOR COMPILING WITHIN ZSH
. ./export.sh


