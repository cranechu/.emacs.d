sudo dnf install redhat-rpm-config
sudo dnf install emacs-nox

sudo dnf install zsh
cp .zshrc ~/
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#dconf dump /org/gnome/ > gnome.dconf.bak
dconf load /org/gnome/ < gnome.dconf.bak

