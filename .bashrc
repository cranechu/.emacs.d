# .bashrc

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export EDITOR=emacs
export ALTERNATE_EDITOR=""

PS1='[\u@ \w] '

alias e='emacsclient -t'
alias l='ls'
alias chrome='google-chrome --no-sandbox &'
alias dual_screen='xrandr --output DP-1 --scale 1.5x1.5 --mode 1920x1080 --fb 5760x2160 --pos 1920x0'
alias jnb='jupyter notebook --allow-root'
