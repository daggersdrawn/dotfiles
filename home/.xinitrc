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
errorlog="$HOME/.xerrors"
gnupglog="~/.gnupg/gpg-agent.info"
eserver="/tmp/emacs${UID}/server"
tone="$HOME/dotfiles/tones/gudrun_gut-thelandKRZ.ogg"
fonts_dir=/usr/share/fonts/local
BACKGROUND="$HOME/dotfiles/backgrounds/taos_mesa-gorge_storm.jpg"
# }}}

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# {{{ Log settings
#
# Always start X11 with a clean log file
if (cp /dev/null "${errorlog}"); then
  chmod 600 "${errorlog}"
  exec >"${errorlog}" 2>&1
fi
# }}}

# {{{ Keyboard settings
#
# Compose combinations are defined in /usr/share/X11/locale/en_US.UTF-8/Compose
setxkbmap -option compose:ralt    # https://wiki.archlinux.org/index.php/Accents_on_US_keyboards
xset r rate 200 40                # Set keyboard delay and repeat rate
# }}}

# {{{ Pointer settings
xsetroot -cursor_name left_ptr    # Pointer apperance: xcb does not support Xcursor yet
xset m 30/10 4                    # Pointer control, acceleration and threshold
unclutter &                       # Hide cursor when not in use
# }}}

# {{{ Autostart settings
#
xset b 0                                                        # Turn terminal bell off
xscreensaver -no-splash &                                       # Start xscreensaver
redshift-gtk -l 39.952583:-75.165222 -t 6000:4500 -m vidmode &  # Start redshift
urxvtcd -title term -q -f -o &                                  # Start urxvt daemon
blueman-applet &                                                # Start bluetooth
udiskie &                                                       # Start USB auto-mounting
dunst &                                                         # Start notification manager
syncthingtray qt-widgets-gui --single-instance --wait &         # Start syncthingtray
git-dude ~/.git-dude &                                          # Start git-dude
urxvtc -e screen -l -UDRS term &                                # Resume last screen session or start new
[ -f ~/.pomodoro_session ] && rm ~/.pomodoro_session            # Clear pomodoro timer
gst123 -q "${tone}" &                                           # Play a startup sound
# }}}

# {{{ Start leftwm
#
xrdb -merge ~/.Xresources
cd $HOME                          # Make X always open new terms in ~/
exec leftwm                       # Start window manager
# }}}
