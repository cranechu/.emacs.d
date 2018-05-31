Restore System:

emacs:
init.el in this folder

zsh:
install zsh: https://github.com/robbyrussell/oh-my-zsh
cp .zshrc ~/

gnome:
dconf dump /org/gnome/ > gnome.dconf.bak
dconf load /org/gnome/ < gnome.dconf.bak
