#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# {{{ Source scripts in /etc/X11/xinit/xinitrc.d/
#
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
# }}}

# {{{ Environment settings
#
errorlog="$HOME/.xerrors"
gnupglog="~/.gnupg/gpg-agent.info"
tone="$HOME/dotfiles/tones/gudrun_gut-thelandKRZ.ogg"
eserver="/tmp/emacs${UID}/server"
background="$HOME/dotfiles/backgrounds/taos_mesa-gorge_storm.jpg"
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
$HOME/bin/esd &                                                               # start emacs dameon
if disper -l | grep DFP-1; then                                               # configure lcd displays
  $HOME/bin/lcd on
else
  $HOME/bin/lcd off
fi
# gtk-redshift -l 40.4167:-3.7003 -t 6000:4500 -m vidmode &                   # start redshift
/usr/bin/xscreensaver -no-splash &                                            # start xscreensaver
ogg123 -q "${tone}" &                                                         # play a startup sound
mpd $HOME/.mpd/mpd.conf                                                       # start mpd daemon
dropboxd &                                                                    # start dropbx daemon
urxvtcd -title term -q -f -o &                                                # start urxvt daemon
# urxvt -e screen -l -UDRS term &                                             # resume last screen session or start new
[ -f ~/.pomodoro_session ] && rm ~/.pomodoro_session                          # clear pomodoro timer

# GnuPG agent can't handle ecdsa, use keychain with x11-ssh-askpass
keychain $HOME/.ssh/id_ecdsa $HOME/.ssh/id_rsa
[ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh 2>/dev/null
[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
# }}}


# {{{ Start xmonad
#
cd $HOME  # make X always open new terms in ~/
xmonad
# }}}
