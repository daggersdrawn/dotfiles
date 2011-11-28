#
# ~/.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

if [ -f "$HOME/dotfiles/bash/main.sh" ]; then
    . "$HOME/dotfiles/bash/main.sh"
fi
