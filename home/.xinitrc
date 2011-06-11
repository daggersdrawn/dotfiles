#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# {{{ Environment settings
errorlog="${HOME}/.xerrors"
gnupglog="${HOME}/.gnupg/gpg-agent.info"
# }}}


# {{{ Log settings
#
# Always start X11 with a clean log file
if (cp /dev/null "${errorlog}"); then
  chmod 600 "${errorlog}"
  exec >"${errorlog}" 2>&1
fi
# }}}

# {{{ Input settings
#
# Swap ctrl and caps
setxkbmap -option ctrl:swapcaps

# Swap alt and super
setxkbmap -device 12 -option altwin:swap_lalt_lwin

# Numlock on TODO: only on full keyboard, not laptop keyboard
# numlockx &

# Keyboard control, repeat delay and repeat rate
xset r rate 200 30

# Pointer control, acceleration and threshold
xset m 30/10 4

# Pointer appearance
#   - xcb does not support Xcursor yet
xsetroot -cursor_name left_ptr

# Use custom fonts on dzen toolbar
xset +fp /usr/share/fonts/local
xset fp rehash

# Disable the touchpad while typing
#syndaemon -k -i 2 -d &
# }}}

# {{{ Autostart settings
#
# Set background
#/usr/bin/nitrogen --restore &
feh --bg-scale /home/rizumu/dotfiles/backgrounds/taos_mesa-gorge_storm.jpg &

# Set up an icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true \
  --width 10  --height 12 --transparent true --alpha 0 --tint 0x2F2F2F &

# Start redshift
gtk-redshift -l 40.4167:-3.7003 -t 6000:4500 -m vidmode &

# Start xscreensaver
/usr/bin/xscreensaver -no-splash &

# Play a startup sound
ogg123 -q "${HOME}/dotfiles/tones/gudrun_gut-thelandKRZ.ogg" &

# Start mpd as normal user
mpd ~/.mpd/mpd.conf

# Start dropbox
dropboxd &

# Start the GNU Emacs daemon
[[ ! -r "/tmp/emacs${UID}/server" ]] && emacs -u rizumu --daemon --eval "(server-start)" &

# Start the GnuPG agent and enable OpenSSH agent emulation
if (pgrep -u "${USER}" gpg-agent); then
  eval `cat ${gnupglog}`
  eval `cut -d= -f1 ${gnupglog} | xargs echo export`
else
  eval `gpg-agent --enable-ssh-support --daemon`
fi

# Open urxvt (rxvt-unicode) in daemon-client mode on the first tag
#   - resume the old screen session or start a new one
#urxvt -e screen -l -UDRS term &
urxvtcd -title term &

# }}}

# Choose the session at login time by pressing F1
DEFAULT_SESSION=xmonad

case $1 in
qtile)
  exec ck-launch-session qtile
  ;;
xfce4)
  exec ck-launch-session startxfce4
  ;;
xmonad)
  exec ck-launch-session xmonad
  ;;
*)
  exec ck-launch-session $DEFAULT_SESSION
  ;;
esac

