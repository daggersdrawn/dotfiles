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

# Keyboard control, repeat delay and repeat rate
xset r rate 200 30

# Pointer control, acceleration and threshold
xset m 30/10 4

# Pointer appearance
#   - xcb does not support Xcursor yet
xsetroot -cursor_name left_ptr

# Use custom fonts with dzen
xset +fp /usr/share/fonts/local
xset fp rehash

# Disable the touchpad while typing
#syndaemon -k -i 2 -d &
# }}}

# {{{ Autostart settings
#
# Start the GnuPG agent and enable OpenSSH agent emulation
if (pgrep -u "${USER}" gpg-agent); then
  eval `cat ${gnupglog}`
  eval `cut -d= -f1 ${gnupglog} | xargs echo export`
else
  eval `gpg-agent --enable-ssh-support --daemon`
fi

# Start the GNU Emacs daemon
[[ ! -r "/tmp/emacs${UID}/server" ]] && emacs -u rizumu --daemon --eval "(server-start)" &&

# Open a terminal emulator on the first tag
#   - resume the old screen session or start a new one
#urxvt -e screen -l -UDRS term &
urxvt -T Terminal &

# Play a startup sound
ogg123 -q "${HOME}/dotfiles/tones/gudrun_gut-thelandKRZ.ogg" &

# starts mpd as normal user
mpd ~/.mpd/mpd.conf

# xscreensaver
/usr/bin/xscreensaver -no-splash &

# start dropbox
dropboxd &

# start urxvt (rxvt-unicode) in daemon-client mode
urxvtcd

# launch the external 60 second clock, and launch the workspace status bar
FG='#a8a3f7'
BG='#3f3c6d'

while true ; do date ; sleep 60 ; done | dzen2 -e '' -x 400 -w $off -ta r -fg $FG -bg $BG -p &

# }}}

# exec ck-launch-session awesome
exec ck-launch-session xmonad
# exec ck-launch-session openbox
# exec ck-launch-session gnome-session
# exec ck-launch-session startkde
# exec ck-launch-session startxfce4
# exec ck-launch-session qtile
