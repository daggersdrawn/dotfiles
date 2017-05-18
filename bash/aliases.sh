# alias editing
alias ea='ec $HOME/dotfiles/'  # because i edit my bash_profile a lot with new things
alias reload='. $HOME/.profile'  # same as previous, after editing you have to source it for the new stuff to work

if $_islinux; then
  alias x='startx'
  alias sex='startx'
  alias xdefaults='xrdb -merge ~/.Xdefaults'
  alias invert='xcalib -invert -alter'
  alias reboot='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart'
  alias shutdown='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop'
  alias suspend='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend'
  alias hibernate='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate'
  alias dsleep='xset dpms force off'
  alias mempurge='sync && sudo /sbin/sysctl vm.drop_caches=3 && sudo swapoff -a && sudo swapon -a'
  alias skype='xhost +local: && sudo -u skype /usr/bin/skype'
  alias bat='acpi -b'
else
  alias rquicksilver="sudo umount -Af && killall Quicksilver && open /Applications/Quicksilver.app"
  alias killdash="defaults write com.apple.dashboard mcx-disabled -boolean YES; killall Dock;"
  alias startdash="defaults write com.apple.dashboard mcx-disabled -boolean NO; killall Dock;"
  alias o="open ."
  alias o.="open ."
  alias firefox="open -a firefox"
fi

# system
alias path='echo -e "${PATH//:/\n}"'
alias c='clear;echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."' # shortcut to clear your terminal
alias myip='curl --silent http://tnx.nl/ip'
alias ping='ping -c 5'  # Pings with 5 packets, not unlimited.
alias mtr='sudo mtr --show-ips'  # Pings with 5 packets, not unlimited.
alias conncount='netstat -an | grep -c EST'
man_utf8() {
  for i in {{0..9},{A..F}}{{0..9},{A..F}}{{0..9},{A..F}}{{0..9},{A..F}}; do
    printf '$i \u$i\n';
  done|less;
}  #  All UTF-8. req. bash4
alias units='units -t'  # terse mode
alias htop='sudo htop'
alias tm='sudo htop -o vsize'  # memory
alias tu='sudo htop -o cpu'  # cpu
alias df='df -h'  # Disk free, in gigabytes, not bytes
alias du='du -h -c'  # Calculate total disk usage for a folder
alias ps?='ps ax | grep'

# xmonad
[[ -f '$HOME/.xmonad/xmonad.hs' ]] && alias checkmonad='(cd ~/.xmonad && ghci -ilib xmonad.hs)'

# files
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdd='cd -' # Go to last used directory
alias l='ls -NAF'
alias la='ls -NaliF'
alias ls='ls -Nh --group-directories-first --color=auto'
alias ll='ls -NlFh'
alias grep='GREP_COLOR="1;33;40" LANG=C grep --color=auto'
alias egrep='egrep --color=auto'  # Always highlight egrep search term
alias diff='LC_ALL=C TZ=GMT0 colordiff -Naur'  # normalise diffs for distribution and use color
alias shred='shred --iterations=200 --zero --remove'
alias delds='find . -name .DS_Store -exec rm -v {} \;'
alias delorig='find . -name \*.orig  -exec rm -v {} \;'
alias delpyc='find . \( -name "*.pyc" -o -name "*.pyo" \) -exec rm -v {} \;'
alias delemacs='find . \( -name "\#*\#" -o -name ".\#*" \) -exec rm -v {} \;'
alias delinit='find . -name \__init__.py  -exec rm -v {} \;'

# emacs
function e {
  if [ '$1' == '' ]; then
    emacsclient --tty  .
  else
    emacsclient --tty $1
  fi
}  # open, in current shell, using the emacs daemon.

function et {
  if [ '$1' == '' ]; then
    emacs --no-window-system --quick .
  else
    emacs --no-window-system --quick $1
  fi
}  # open quickly, in the current shell, using no cofing or daemon.

function ec {
  if [ '$1' == '' ]; then
    emacsclient --no-wait .
  else
    emacsclient --no-wait $1
  fi
}  # open, in the current frame, using the emacs daemon. TODO: open a new frame if not already open

function en {
  if [ '$1' == '' ]; then
    emacsclient --no-wait --create-frame .
  else
    emacsclient --no-wait --create-frame $1
  fi
}  # open, in a new frame, using the emacs dameon.

# ed
alias ed='ed -p "ed> "'  # http://blog.sanctum.geek.nz/actually-using-ed/

# zile
alias z='zile'

# sublime
alias s.='subl .'

# tmuxinator
alias mux='tmuxinator'

# python
alias emailserver='python -m smtpd -n -c DebuggingServer localhost:1025'
alias linecountpy='find . -name "*.py" -exec wc {} +'

# scheme
alias scheme="rlwrap -r -c -f ~/dotfiles/mit_scheme_bindings.txt scheme"

# django
alias rr='reset; python manage.py runserver_plus 0.0.0.0:8000'
alias lssitepackages='ls -Nhal `python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`'
alias cdsitepackages='cd `python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`'

# postgres
alias restart_pg='rm /usr/local/var/postgres/postmaster.pid pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'

# lynx
alias lynx='lynx -force_html -width=$COLUMNS'  # best settings for viewing HTML

# pentadactyl
function fbwhitelist() {
  sed -ie '$s/$/,'$1'/' $HOME/.pentadactylrc
}

# irssi on remote machine
alias irc='ssh -t irc screen -raAd'

# mount and eject discs
if [[ -b '/dev/sr0' ]]; then
  alias eject='eject -T /dev/sr0'
  alias mountdvd='sudo mount -t iso9660 -o ro /dev/sr0 /media/dvd/'
fi

# mp3 > ogg works but not as an alias. lossless > lossless is bad anywayPP.
alias mp32ogg='find . -iname "*.mp3" | while read song; do mpg321 ${song} -w - | oggenc -q 9 -o ${song%.mp3}.ogg -; done'

# mpc
if _have mpc; then
  alias addall='mpc --no-status clear && mpc listall | mpc --no-status add && mpc play'
  alias n='mpc next'
  alias p='mpc prev'
  alias tog='mpc toggle'  # pause/unpause mpd
fi

# ossvol
if _have ossvol; then
  alias u='ossvol -i 3'
  alias d='ossvol -d 3'
  alias m='ossvol -t'
fi

combinepdf() {
  _have gs || return 1
  [[ $# -ge 2 ]] || return 1
  local out='$1'; shift
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile='$out' '$@'
}  # combine pdfs into one using ghostscript

thumbit() {
  _have mogrify || return 1
  for pic in '$@'; do
    case '$pic' in
      *.jpg) thumb='${pic/.jpg/-thumb.jpg}' ;;
      *.jpeg) thumb='${pic/.jpeg/-thumb.jpeg}' ;;
      *.png) thumb='${pic/.png/-thumb.png}' ;;
      *.bmp) thumb='${pic/.bmp/-thumb.bmp}' ;;
    esac
    [[ -z '$thumb' ]] && return 1
    cp '$pic' '$thumb' && mogrify -resize 10% '$thumb'
  done
}  # make a thumb

hbrip() {
  _have HandBrakeCLI || return 1
  [[ -n '$1' ]] || return 1
  local name='$1' out drop='$HOME/Movies'; shift
  [[ -d '$drop' ]] || mkdir -p '$drop'
  out='$drop/$name.mp4'
  echo 'rip /dev/sr0 --> $out'
  HandBrakeCLI -Z iPad '$@' -i /dev/sr0 -o '$out' 2>/dev/null
  echo
}  # rip a dvd with handbrake

hbconvert() {
  _have HandBrakeCLI || return 1
  [[ -n '$1' ]] || return 1
  local in='$1' out drop='$HOME/Movies/converted'; shift
  [[ -d '$drop' ]] || mkdir -p '$drop'
  out='$drop/$(basename "${in%.*}").mp4'
  echo 'convert $in --> $out'
  HandBrakeCLI -Z iPad '$@' -i '$in' -o '$out' 2>/dev/null
  echo
}  # convert media to ipad format with handbrake

google() {
  open "https://www.google.com/search?q= $1"
}  # go to google for anything
