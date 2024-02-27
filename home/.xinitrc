#!/bin/sh

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    # shellcheck disable=SC1090
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

ERRORLOG="$HOME/.xerrors"
if (cp /dev/null "$ERRORLOG"); then
  chmod 600 "$ERRORLOG"
  exec > "$ERRORLOG" 2>&1
fi

setxkbmap -option compose:ralt  # https://wiki.archlinux.org/index.php/Accents_on_US_keyboards
xbindkeys &                     # Bind multimedia keys in ~/.xbindkeysrc
xset r rate 200 40              # Set keyboard delay and repeat rate.
xset m 30/10 4                  # Pointer control, acceleration, and threshold.
xset b 0                        # Turn terminal bell off.
xrdb -merge ~/.Xresources       # Load resource file, and merge with the current settings.

exec leftwm
