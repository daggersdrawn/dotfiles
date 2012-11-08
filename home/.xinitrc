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
usermodmap="${HOME}/.Xmodmap"
sysmodmap="/etc/X11/xinit/.Xmodmap"
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
# configure lcd displays, set color profiles, and set a background image
if disper -l | egrep 'DFP-1|VGA1'; then
  $HOME/bin/lcd on
else
  $HOME/bin/lcd off
fi
gtk-redshift -l 40.4167:-3.7003 -t 6000:4500 -m vidmode &                   # start redshift
# }}}


# {{{ Resource and keymap settings
# }}}


# {{{ Keyboard settings
# Merge keymaps
[[ -r "${sysmodmap}" ]]     && xmodmap "${sysmodmap}"
[[ -r "${usermodmap}" ]]    && xmodmap "${usermodmap}"
# The kbd script detects different keyboards, makes their keys uniform, and handles usb hotplugging.
if [ -f "$HOME/bin/kbd" ]; then
    $HOME/bin/kbd
fi
setxkbmap -option compose:ralt  # https://wiki.archlinux.org/index.php/Accents_on_US_keyboards
setxkbmap -option ctrl:nocaps
xset r rate 200 30
# azerty  colemak  dvorak  fgGIod  include  olpc  qwerty  qwertz
#setxkbmap -layout colemak
#setxkbmap -layout us-acentos
# }}}


# {{{ Pointer settings
xsetroot -cursor_name left_ptr    # Pointer apperance: xcb does not support Xcursor yet
xset m 30/10 4                    # Pointer control, acceleration and threshold
unclutter &                       # Hide cursor when not in use
xset +fp "${fonts_dir}"           # Use custom fonts on dzen toolbar
xset fp rehash                    # Use custom fonts on dzen toolbar
# }}}


# {{{ Autostart settings
#
$HOME/bin/esd &                                                               # start emacs dameon
/usr/bin/xscreensaver -no-splash &                                            # start xscreensaver
mpd $HOME/.mpd/mpd.conf                                                       # start mpd daemon
dropboxd &                                                                    # start dropbx daemon
urxvtcd -title term -q -f -o &                                                # start urxvt daemon
# urxvt -e screen -l -UDRS term &                                             # resume last screen session or start new
[ -f ~/.pomodoro_session ] && rm ~/.pomodoro_session                          # clear pomodoro timer
# Use keychain with x11-ssh-askpass, because GnuPG agent does not support ecdsa.
keychain $HOME/.ssh/id_ecdsa $HOME/.ssh/id_rsa
[ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh 2>/dev/null
[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
ogg123 -q "${tone}" &                                                         # play a startup sound
# }}}


# {{{ Start xmonad
#
cd $HOME  # make X always open new terms in ~/
xmonad
# }}}
