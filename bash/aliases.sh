#!/bin/sh

# dotfiles
alias edot='ec $HOME/dotfiles/'
alias reload='. $HOME/.bash_profile'

# system
if $_islinux; then
  alias x='startx'
  alias sex='startx'
  alias xresources='xrdb -merge ~/.Xresources'
  alias bat='acpi -b'
  alias invert='xcalib -invert -alter'
  alias dsleep='xset dpms force off'
  alias mempurge='sync && sudo /sbin/sysctl vm.drop_caches=3 && sudo swapoff -a && sudo swapon -a'
  alias reboot='sudo systemctl reboot'
  alias shutdown='sudo systemctl poweroff'
  alias suspend='systemctl suspend'
  alias hibernate='systemctl hibernate'
  alias yu='yay -Syyu --noconfirm && xset r rate 200 40'
  alias ys='yay -Ss'
  alias yd='yay -G'
  alias yp='yay -Gp'
  alias yc='aur-talk -lbi -w 80'
  alias yi='yay -S --noconfirm'
  alias yr='yay -Rns --noconfirm'
else
  alias o='open .'
  alias wolf='open -a librewolf'
fi
alias path='echo -e "${PATH//:/\n}"'
alias c='clear; echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."' # shortcut to clear your terminal
alias myip='curl --silent http://tnx.nl/ip'
alias ping='ping -c 5'  # Pings with 5 packets, not unlimited.
alias mtr='sudo mtr --show-ips'  # traceroute + ping
alias conncount='netstat -an | grep -c EST'  # Install netstat from net-tools.
alias units='units -t'  # terse mode
alias htop='sudo htop'
alias df='df -h'  # Disk free, in gigabytes, not bytes
alias du='du -h -c'  # Calculate total disk usage for a folder
# shellcheck disable=SC2139
alias ps?='ps ax | grep'

# files
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdd='cd -' # Go to last used directory
alias l='ls -NAF'
alias la='ls -NaliF'
alias ls='ls -Nh --group-directories-first --color=auto'
alias ll='ls -NlFh'
alias agh='ag --hidden'
alias grep='GREP_COLORS="mt=1;33;40" LANG=C grep --color=auto'
alias egrep='egrep --color=auto'  # Always highlight egrep search term
alias diff='LC_ALL=C TZ=GMT0 colordiff -Naur'  # normalise diffs for distribution and use color
alias shred='shred --iterations=200 --zero --remove'
alias delds='find . -name .DS_Store -exec rm -v {} \;'
alias delorig='find . -name \*.orig  -exec rm -v {} \;'
alias delpyc='find . \( -name "*.pyc" -o -name "*.pyo" \) -exec rm -v {} \;'
alias delemacs='find . \( -name "\#*\#" -o -name ".\#*" \) -exec rm -v {} \;'
alias delinit='find . -name \__init__.py  -exec rm -v {} \;'

# colorized cat
alias dog='/usr/bin/bat -pp'

# emacs
e() {
  if [ "$1" = "" ]; then
    emacsclient --tty  .
  else
    emacsclient --tty "$1"
  fi
}  # open, in current shell, using the emacs daemon.

et() {
  if [ "$1" = "" ]; then
    emacs --no-window-system --quick .
  else
    emacs --no-window-system --quick "$1"
  fi
}  # open quickly, in the current shell, using no config or daemon.

ec() {
  if [ "$1" = "" ]; then
    emacsclient --no-wait .
  else
    emacsclient --no-wait "$1"
  fi
}  # open, in the current frame, using the emacs daemon. TODO: open a new frame if not already open

en() {
  if [ "$1" = "" ]; then
    emacsclient --no-wait --create-frame .
  else
    emacsclient --no-wait --create-frame "$1"
  fi
}  # open, in a new frame, using the emacs dameon.

# ed
alias ed='ed -p "ed> "'  # http://blog.sanctum.geek.nz/actually-using-ed/

# zile
alias z='zile'

# tmuxinator
alias mux='tmuxinator'

# python
alias linecountpy='find . -name "*.py" -exec wc {} +'
alias lssitepackages='ls -Nhal $(python -c "import sysconfig; print(sysconfig.get_path(\"platlib\"))")'
alias cdsitepackages='cd $(python -c "import sysconfig; print(sysconfig.get_path(\"platlib\"))")'

# django
alias rr='reset; python manage.py runserver_plus 0.0.0.0:8000'

# scheme
alias scheme='rlwrap -r -c -f ~/dotfiles/mit_scheme_bindings.txt scheme'

# docker
alias docker='podman'

# mpc
alias addall='mpc --no-status clear && mpc listall | mpc --no-status add && mpc play'
alias n='mpc next'
alias p='mpc prev'
alias tog='mpc toggle'

# lynx
alias lynx='lynx -force_html -width=$COLUMNS'

# kagi
kagi() {
  librewolf "https://kagi.com/search?q=$1"
}  # kagi "warrior pup, descendent of wolf 'finnegan'"
