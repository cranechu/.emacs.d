#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install exuberant-ctags curl zip -y
sudo apt install chrome-gnome-shell -y
sudo apt install gnome-shell-extensions -y
sudo apt install gnome-shell-extension-prefs -y
sudo apt install gnome-shell-extension-autohidetopbar -y
sudo apt install gnome-shell-extension-desktop-icons -y
sudo apt remove gnome-shell-extension-appindicator -y
sudo apt remove ghostscript firefox -y

sudo apt install -y python3-dev python-is-python3 python3-pip
sudo apt install -y emacs
sudo apt install -y gnome-tweak-tool
sudo apt install -y zsh git openssh-server nvme-cli

# enable SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# git config
git config --global user.email "cranechu@gmail.com"
git config --global user.name "Crane Chu"

# migrate gnome setting
# dconf dump / > gnome.dconf.bak
dconf load -f / < gnome.dconf.bak

# zsh
rm -rf ~/.oh-my-zsh
echo "now we are installing oh-my-zsh. exit after completion. press any key to continue..." && read
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp .zshrc ~/

# history-search-multi-word
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/robobenklein/zdharma-history-search-multi-word.git history-search-multi-word
cd 

# download chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
echo "double click to install chrome"

echo "done."
