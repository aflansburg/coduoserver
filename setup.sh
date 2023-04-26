#!/bin/bash

# install deps
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install curl wget file tar bzip2 gzip unzip \
  bsdmainutils python3 util-linux ca-certificates \
  binutils bc jq tmux netcat lib32gcc1 lib32stdc++6 libstdc++5:i386

# purge any existing node install
sudo apt remove --purge nodejs npm
sudo apt clean
sudo apt autoclean
sudo apt install -f
sudo apt autoremove

# curl node 16 and install
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs

# install gamedig and update
npm install gamedig -g
npm update -g

# add user coduoserver
adduser --disabled-password --gecos "" coduoserver

su - coduoserver -c "
  sed -i '1c\\set sv_hostname \"hells_raiders\"' /home/coduoserver/serverfiles/uo/coduoserver.cfg
"
