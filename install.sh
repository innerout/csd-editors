#!/bin/bash

if [ "x$(id -u)" != x0 ]; then
    echo "You might have to run it as root user."
    echo "Please run it again with 'sudo'."
    echo
    exit
fi

apt install emacs unzip bear fuse clang gdb python3-pip npm ripgrep fd-find
npm install -g yarn

# We need this since debian use older versions that are not compatible with our configuration
wget https://github.com/neovim/neovim/releases/download/v0.6.1/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage /usr/bin/nvim
chmod 755 /usr/bin/nvim
ln -s /usr/bin/nvim /bin/nvim
