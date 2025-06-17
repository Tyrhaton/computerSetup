#!/bin/bash

cd ~/Downloads
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
zcat < install-tl-unx.tar.gz | tar xf -
cd install-tl-2*
sudo perl ./install-tl --no-interaction
echo 'export PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"' >> ~/.zshrc
source ~/.zshrc