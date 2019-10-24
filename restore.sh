#!/bin/bash

sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install -y google-chrome-stable
sudo dnf remove -y firefox

sudo dnf install -y redhat-rpm-config
sudo dnf install -y python3-devel
sudo dnf install -y emacs
sudo dnf install -y gnome-tweak-tool fio nvme-cli util-linux-user
sudo dnf install -y zsh git
sudo dnf update -y

# migrate gnome setting
# dconf dump / > gnome.dconf.bak
dconf load -f / < gnome.dconf.bak

# zsh
rm -rf ~/.oh-my-zsh
echo "now we are installing oh-my-zsh. exit after completed. press any key to continue..." && read
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp .zshrc ~/

# history-search-multi-word
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zdharma/history-search-multi-word.git
cd 

echo "remember to find gnome extensions in gnome.dconf.back, and install them. "
echo "done."
