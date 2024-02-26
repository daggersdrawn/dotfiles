#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# {{{ Source scripts in /etc/X11/xinit/xinitrc.d/
#
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
# }}}

# {{{ Environment settings
#
ERRORLOG=$HOME/.xerrors
TONE=$HOME/dotfiles/tones/gudrun_gut-thelandKRZ.ogg
# }}}

# {{{ Log settings
#
# Always start X11 with a clean log file
if (cp /dev/null $ERRORLOG); then
  chmod 600 $ERRORLOG
  exec > $ERRORLOG 2>&1
fi
# }}}

# {{{ Keyboard settings
#
# Compose combinations are defined in /usr/share/X11/locale/en_US.UTF-8/Compose
setxkbmap -option compose:ralt    # https://wiki.archlinux.org/index.php/Accents_on_US_keyboards
xset r rate 200 40                # Set keyboard delay and repeat rate
# }}}

# {{{ Pointer settings
#
xsetroot -cursor_name left_ptr    # Pointer apperance: xcb does not support Xcursor yet
xset m 30/10 4                    # Pointer control, acceleration and threshold
unclutter &                       # Hide cursor when not in use
# }}}

# {{{ Autostart settings
#
xset b 0                                                        # Turn terminal bell off
xscreensaver -no-splash &                                       # Start xscreensaver
redshift-gtk -l 39.952583:-75.165222 -t 6000:4500 -m vidmode &  # Start redshift
blueman-applet &                                                # Start bluetooth
udiskie &                                                       # Start USB auto-mounting
dunst &                                                         # Start notification manager
syncthingtray qt-widgets-gui --single-instance --wait &         # Start syncthingtray
git-dude ~/.git-dude &                                          # Start git-dude
[ -f ~/.pomodoro_session ] && rm ~/.pomodoro_session            # Clear pomodoro timer
mpv --really-quiet $TONE &                                      # Play a startup sound
# }}}

# {{{ Start leftwm
#
xrdb -merge ~/.Xresources
exec leftwm
# }}}
