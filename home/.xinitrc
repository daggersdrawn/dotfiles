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
#
errorlog="${HOME}/.xerrors"
gnupglog="${HOME}/.gnupg/gpg-agent.info"
tone="${HOME}/dotfiles/tones/gudrun_gut-thelandKRZ.ogg"
eserver="/tmp/emacs${UID}/server"
background="${HOME}/dotfiles/backgrounds/taos_mesa-gorge_storm.jpg"
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
if [ -f "$HOME/bin/kbd" ]; then
    $HOME/bin/kbd                 # Keyboards are configured in the kbd script
fi
xsetroot -cursor_name left_ptr    # Pointer apperance: xcb does not support Xcursor yet
xset m 30/10 4                    # Pointer control, acceleration and threshold
unclutter &                       # Hide cursor when not in use
xset +fp /usr/share/fonts/local   # Use custom fonts on dzen toolbar
xset fp rehash                    # Use custom fonts on dzen toolbar
# }}}


# {{{ Autostart settings
#
if disper -l | grep DFP-1; then
  ~/bin/lcd on
else
  ~/bin/lcd off
fi
/usr/bin/xscreensaver -no-splash &                                            # Start xscreensaver
ogg123 -q "${tone}" &                                                         # Play a startup sound
mpd ~/.mpd/mpd.conf                                                           # Start mpd daemon
dropboxd &                                                                    # Start dropbx daemon
[[ ! -r "${eserver}" ]] && emacs -u rizumu --daemon --eval "(server-start)" & # Start the GNU Emacs daemon
urxvtcd -title term -q -f -o &                                                # Start urxvt daemon
# gtk-redshift -l 40.4167:-3.7003 -t 6000:4500 -m vidmode &                     # Start redshift
# urxvt -e screen -l -UDRS term &                                               # resume last screen session or start new

# Start the GnuPG agent but don't enable OpenSSH agent emulation
gnupginf="${HOME}/.gnupg/gpg-agent.info"

if pgrep -u "${USER}" gpg-agent >/dev/null 2>&1; then
  eval `cat $gnupginf`
  eval `cut -d= -f1 $gnupginf | xargs echo export`
else
  eval `gpg-agent --daemon`
fi

# Start the SSH-Agent to replace broken GnuPG agent
if (pgrep -u "${USER}" ssh-agent); then
  eval `cat ${HOME}/.keychain/${HOSTNAME}-sh`
else
  eval `ssh-agent`
  (sleep 15 && keychain -q --timeout 480 --agents ssh id_rsa)&
fi
# }}}


# {{{ Choose the session at login time by pressing F1
#
DEFAULT_SESSION=xmonad
case $1 in
  qtile)
    exec ck-launch-session qtile ;;
  xfce4)
    exec ck-launch-session startxfce4 ;;
  xmonad)
    exec ck-launch-session xmonad ;;
  *)
    exec ck-launch-session $DEFAULT_SESSION ;;
esac
# }}}
