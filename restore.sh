sudo dnf install -y redhat-rpm-config
sudo dnf install -y python3-devel
sudo dnf install -y emacs-nox
sudo dnf install -y gnome-tweak-tool fio nvme-cli util-linux-user
sudo dnf update -y

#dconf dump /org/gnome/ > gnome.dconf.bak
dconf load /org/gnome/ < gnome.dconf.bak

sudo dnf install -y zsh
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp .zshrc ~/

