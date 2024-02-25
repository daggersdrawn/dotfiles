#
# ~/.bashrc
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# https://github.com/akinomyoga/ble.sh
if [ -f "/usr/share/blesh/ble.sh" ]; then
  . /usr/share/blesh/ble.sh --noattach
fi

if [ -f "$HOME/dotfiles/bash/main.sh" ]; then
  . "$HOME/dotfiles/bash/main.sh"
fi

if type "fortune" &> /dev/null && type "cowsay" &> /dev/null; then
  command fortune |
  $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n |
  lolcat -a -d 2 -s 90.0
fi

[[ ${BLE_VERSION-} ]] && ble-attach
