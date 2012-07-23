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
errorlog="~/.xerrors"
gnupglog="~/.gnupg/gpg-agent.info"
tone="~/dotfiles/tones/gudrun_gut-thelandKRZ.ogg"
eserver="/tmp/emacs${UID}/server"
background="~/dotfiles/backgrounds/taos_mesa-gorge_storm.jpg"
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
if [ -f "~/bin/kbd" ]; then
    ~/bin/kbd                 # Keyboards are configured in the kbd script
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
# gtk-redshift -l 40.4167:-3.7003 -t 6000:4500 -m vidmode &                   # Start redshift
urxvt -T Terminal &
emacs --title org &
chromium --app=https://mail.google.com &
chromium --app=https://www.google.com/calendar/render?pli=1 &
chromium --app=https://plus.google.com &
chromium --app=https://soundcloud.com &
# urxvt -e screen -l -UDRS term &                                             # resume last screen session or start new

# GnuPG agent can't handle ecdsa, use keychain with x11-ssh-askpass
keychain ~/.ssh/id_ecdsa ~/.ssh/id_rsa
[ -f ~/.keychain/$HOSTNAME-sh ] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null
[ -f ~/.keychain/$HOSTNAME-sh-gpg ] && . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
# }}}


# {{{ Start xmonad
#
xmonad
# }}}
