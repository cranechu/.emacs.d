#!/bin/bash

sudo dnf install -y redhat-rpm-config
sudo dnf install -y python3-devel
sudo dnf install -y emacs-nox
sudo dnf install -y gnome-tweak-tool fio nvme-cli util-linux-user
sudo dnf install -y zsh
sudo dnf update -y

# migrate installed packages
# sudo dnf repoquery --qf '%{name}' --userinstalled | grep -v -- '-debuginfo$' | grep -v '^\(kernel-modules\|kernel\|kernel-core\|kernel-devel\)$' > installed.lst
< installed.lst xargs sudo dnf -y install

# migrate gnome setting
# dconf dump / > gnome.dconf.bak
dconf load / < gnome.dconf.bak

# zsh
rm -rf ~/.oh-my-zsh
echo "now we are installing oh-my-zsh. exit after completed. press any key to continue..." && read
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp .zshrc ~/

echo "remember to find gnome extensions in gnome.dconf.back, and install them. "
echo "done."
