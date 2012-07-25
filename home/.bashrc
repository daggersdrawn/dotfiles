#
# ~/.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

if [ -f "$HOME/dotfiles/bash/main.sh" ]; then
    . "$HOME/dotfiles/bash/main.sh"
fi

if type "fortune" &> /dev/null && type "cowsay" &> /dev/null && type "ponysay" &> /dev/null; then
  rem=$(($RANDOM%4))
  [[ $rem == 0 ]] && fortune -a | fmt -80 -s | cowsay -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n
  [[ $rem == 1 ]] && fortune -a | fmt -80 -s | cowsay -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n
  [[ $rem == 2 ]] && fortune | ponysay
  [[ $rem == 3 ]] && fortune | ponythink
fi
