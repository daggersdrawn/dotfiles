#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
# thanks to anrxc: http://git.sysphere.org/dotfiles/tree/xinitrc


# {{{ Environment settings
#
errorlog="$HOME/.xerrors"
gnupglog="~/.gnupg/gpg-agent.info"
eserver="/tmp/emacs${UID}/server"
tone="$HOME/dotfiles/tones/gudrun_gut-thelandKRZ.ogg"
fonts_dir=/usr/share/fonts/local
BACKGROUND="$HOME/dotfiles/backgrounds/taos_mesa-gorge_storm.jpg"
export BACKGROUND
# }}}


# {{{ Source scripts in /etc/X11/xinit/xinitrc.d/
#
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
# }}}


# {{{ Log settings
#
# Always start X11 with a clean log file
if (cp /dev/null "${errorlog}"); then
  chmod 600 "${errorlog}"
  exec >"${errorlog}" 2>&1
fi
# }}}


# {{{ Display settings
# configure lcd displays, set color profiles and set a background image
if disper -l | egrep 'eDP-1:'; then
  $HOME/bin/lcd on
else
  $HOME/bin/lcd off
fi
redshift-gtk -l 39.9522222:-75.1641667 -t 6000:4500 -m vidmode &  # start redshift
# }}}


# {{{ Keyboard settings
# the keymap is altered in ~/.Xmodmap and fn keys for audio in ~/.xbindkeysrc
# The kbd script detects specific keyboards, unifies layouts and sets key options.
if [ -f "$HOME/bin/kbd" ]; then
    $HOME/bin/kbd
fi
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
xset b 0                                                                      # turn terminal bell off
# }}}


# {{{ Pointer settings
# investigate dotfiles/home/.xbindkeys for logitech mx mouse
xsetroot -cursor_name left_ptr    # Pointer apperance: xcb does not support Xcursor yet
xset m 30/10 4                    # Pointer control, acceleration and threshold
unclutter &                       # Hide cursor when not in use
xset +fp "${fonts_dir}"           # Use custom fonts on dzen toolbar
xset fp rehash                    # Use custom fonts on dzen toolbar
# }}}


# {{{ Autostart settings
#
/usr/bin/xscreensaver -no-splash &                                            # start xscreensaver
#urxvtcd -title term -q -f -o &                                                # start urxvt daemon
urxvt -e screen -l -UDRS term &                                               # resume last screen session or start new
[ -f ~/.pomodoro_session ] && rm ~/.pomodoro_session                          # clear pomodoro timer
# Use keychain with x11-ssh-askpass, because GnuPG agent does not support ecdsa.
#keychain $HOME/.ssh/id_ecdsa $HOME/.ssh/id_rsa
#[ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh 2>/dev/null
#[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
blueman-applet &                                                              # start bluetooth
gst123 -q "${tone}" &                                                         # play a startup sound
udiskie &                                                                     # usb auto-mount
# }}}


# {{{ Start xmonad or leftwm
#
cd $HOME  # make X always open new terms in ~/
exec leftwm
#xmonad &> ~/.xerrors
# }}}
