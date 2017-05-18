#
# ~/.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

if [ -f "$HOME/dotfiles/bash/main.sh" ]; then
  . "$HOME/dotfiles/bash/main.sh"
fi

if type "fortune" &> /dev/null && type "cowsay" &> /dev/null; then
  command fortune -a | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n
fi

if [ -f "$HOME/.private" ]; then
  . "$HOME/.private"
fi
