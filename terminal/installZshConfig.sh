#!/bin/bash

# Update your software repositories.
sudo apt-get update
sudo apt-get upgrade

# Install Git.
sudo apt-get install -y git

# Install Vim.
sudo apt-get install -y vim

gh repo clone pixegami/terminal-profile

sed -i 's|^pip3 install --user powerline-status$|pip3 install --user powerline-status --break-system-packages|' ./install_powerline.sh

./install_powerline.sh
./install_terminal.sh
./install_profile.sh