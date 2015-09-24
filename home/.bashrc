#
# ~/.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

if [ -f "$HOME/dotfiles/bash/main.sh" ]; then
  . "$HOME/dotfiles/bash/main.sh"
fi

if type "fortune" &> /dev/null && type "cowsay" &> /dev/null; then
  command fortune -a | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

if [ -f "$HOME/.private" ]; then
  . "$HOME/.private"
fi

source /usr/local/etc/bash_completion.d/password-store

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
