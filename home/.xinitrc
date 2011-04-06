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
  break
fi
# }}}


setxkbmap -option ctrl:swapcaps

# {{{ Input settings
# 
# Keyboard control, repeat delay and repeat rate
xset r rate 200 30

# Pointer control, acceleration and threshold
#xset m 30/10 4

# Pointer appearance
#   - xcb does not support Xcursor yet
xsetroot -cursor_name left_ptr

# Disable the touchpad while typing
#syndaemon -k -i 2 -d &
# }}}

# {{{ Autostart settings
#
# Start the GnuPG agent and enable OpenSSH agent emulation
#if (pgrep -u "${USER}" gpg-agent); then
#  eval `cat ${gnupglog}`
#  eval `cut -d= -f1 ${gnupglog} | xargs echo export`
#else
#  eval `gpg-agent --enable-ssh-support --daemon`
#fi

# Start the GNU Emacs daemon
#[[ ! -r "/tmp/emacs${UID}/server" ]] && emacs --daemon &

# Xwrits reminds you to take wrist breaks and avoid RSI
xwrits typetime=45 clock breakclock top ready-picture="${HOME}/.xwrits/ready.gif" \
  rest-picture="${HOME}/.xwrits/rest.gif" warning-picture="${HOME}/.xwrits/warning.gif" &

# Open a terminal emulator on the first tag
#   - resume the old screen session or start a new one
urxvt -e screen -l -UDRS term &

# Play a startup sound
#ogg123 -q "${HOME}/.local/share/gajim/sounds/voices/voice-system-activated.ogg" &
# }}}

exec awesome
# exec gnome-session
# exec startkde
# exec startxfce4
# exec qtile
# ...or the Window Manager of your choice
