# is $1 installed?
_have() { which '$1' &>/dev/null; }

# Alias Editing
alias ea='ec $HOME/dotfiles/' # because i edit my bash_profile a lot with new things
alias reload='. $HOME/.profile' # same as previous, after editing you have to source it for the new stuff to work

# System
alias reboot='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart'
alias shutdown='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop'
alias suspend='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend'
alias hibernate='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate'
alias dsleep='xset dpms force off'

# Global
alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias c='clear;echo "Currently logged in on $(tty), as $(whoami) in directory $(pwd)."' # shortcut to clear your terminal
alias cdd='cd -'        # Go to last used directory
alias delds='find . \( -name ".DS_Store" \) -exec rm -v {} \;'
alias delorig='find . \( -name "*.orig" \) -exec rm -v {} \;'
alias df='df -h'         # Disk free, in gigabytes, not bytes
alias du='du -h -c'      # Calculate total disk usage for a folder
alias grep='grep --color=auto' # Always highlight grep search term
alias h='history'        # shortcut for history
alias ping='ping -c 5'   # Pings with 5 packets, not unlimited. Instead of ping try: mtr google.com
function take {
  mkdir $1
  cd $1
}  # mkdir and cd
alias cal='cal -3' # show 3 months by default
alias units='units -t' # terse mode
alias diff='LC_ALL=C TZ=GMT0 colordiff -Naur' # normalise diffs for distribution and use color
alias lynx='lynx -force_html -width=$COLUMNS' # best settings for viewing HTML
alias tog='mpc toggle' # pause/unpause mpd
alias conncount='netstat -an | grep -c EST'
man_utf8() {
  for i in {{0..9},{A..F}}{{0..9},{A..F}}{{0..9},{A..F}}{{0..9},{A..F}}; do
    printf '$i \u$i\n';
  done|less;
} # All UTF-8. req. bash4
alias skype='xhost +local: && sudo -u skype /usr/bin/skype'

# standard
alias l='ls -AF'
alias la='ls -aliF'
alias ls='ls -h --group-directories-first --color=auto'
alias ll='ls -lFh'
alias myip='curl --silent http://tnx.nl/ip'
alias path='echo -e "${PATH//:/\n}"'

# task
alias t='c && task ls'

function rep() {
  perl -e 's/'$1'/'$2'/g;' -pi $(find ./ -type f)
} # rep: find and replace in current directory

# I hate noise
set bell-style visible
alias bp='echo -e "\a"' # send a notification, ie. pacman -Syu && bp

# Grep
# GREP_COLOR=bright yellow on black bg.
# use GREP_COLOR=7 to highlight whitespace on black terminals
# LANG=C for speed. See also: http://www.pixelbeat.org/scripts/findrepo
alias ps?='ps ax | grep'
alias grep='GREP_COLOR="1;33;40" LANG=C grep --color=auto'

# Processes
alias tm='top -o vsize' #memory
alias tu='top -o cpu' #cpu

# X
alias x='startx'
alias sex='startx'

# yaourt (manually add --noconfirm to skip prompts)
alias yogurt='yaourt'
alias y='yaourt'               # yaourt alias
alias yi='yaourt -S'           # Install a package
alias yiu='yaourt -U'          # Install specific package not from the repositories but from a file
alias yid='yaourt -S --asdeps' # Install given package(s) as dependencies of another package
alias yu='yaourt -Syyu'        # Full system update
alias yua='yaourt -Syyu --aur' # Full system update including aur
alias ys='yaourt -Ss'          # Search for the package
alias yg='yaourt -G'           # Get (fetch) the package
alias yr='yaourt -Rns'         # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias yrk='yaourt -R'          # Remove the specified package(s), keeping its configuration(s) and required dependencies
alias yf='yaourt -Ql'          # List files for the package
alias yinfo='yaourt -Si'       # Display information about a given package in the repositories
alias ylinfo='yaourt -Qi'       # Display information about a given package in the local database
alias yl='yaourt -Qs'          # Search for package(s) in the local database
alias yo='yaourt -Qdt'         # List orphans
alias ymir='yaourt -Syy'       # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
alias rmorphans='yaourt -Rns $(yaourt -Qtdq)'

# Python
alias delpyc="find . \( -name '*.pyc' -o -name '*.pyo' \) -exec rm -v {} \;"
alias py='ipython'
alias emailserver='python -m smtpd -n -c DebuggingServer localhost:1025'

# Screen
alias s='screen'
alias sl='screen -ls'

# Git
function git_current_branch() {
  git symbolic-ref HEAD 2> /dev/null | cut -b 12-
}
alias gcb='git-cut-branch'
alias gcompare='hub compare'
alias gin='git-incoming'
alias fp='format-patch --stdout'
alias gla='git log --graph'
alias glb='git log --pretty=oneline --graph --all'
alias glc='git log --decorate --stat --graph --pretty=format:"%C(yellow)%h%Creset (%ar - %Cred%an%Creset), %s%n"'
alias gld='git log --pretty=oneline --abbrev-commit --max-count=15'
alias gout='git-outgoing'
alias gt='git-track'
alias gw='hub browse'
alias gg='git log -p -2 --pretty=format:"%h - %an, %ar : %s" --shortstat'
alias grb='git rebase --preserve-merges origin/$(git_current_branch)'
#alias gl='git fetch origin && grb'
function gbt() {
  git branch --track $2 $1/$2
  git checkout $2
} # Setup a tracking branch from [remote] [branch_name]
function grrb() {
  git checkout $1 &&
  git branch $2 origin/$1 &&
  git push origin $2 &&
  git push origin :$1 &&
  git checkout dev &&
  git branch -D $1
} # git remove remote branch

# Git alias completion
__define_git_completion () {
eval "
    _git_$2_shortcut () {
        COMP_LINE=\"git $2\${COMP_LINE#$1}\"
        let COMP_POINT+=$((4+${#2}-${#1}))
        COMP_WORDS=(git $2 \"\${COMP_WORDS[@]:1}\")
        let COMP_CWORD+=1

        local cur words cword prev
        _get_comp_words_by_ref -n =: cur words cword prev
        _git_$2
    }
"
}

__git_shortcut () {
    type _git_$2_shortcut &>/dev/null || __define_git_completion $1 $2
    alias $1="git $2 $3"
    complete -o default -o nospace -F _git_$2_shortcut $1
}

__git_shortcut  ga    add
__git_shortcut  gb    branch --set-upstream
__git_shortcut  gba   branch -a
__git_shortcut  gbv   branch --color -v | cut -c1-100
__git_shortcut  gco   checkout
__git_shortcut  gc    commit '-v -m'
__git_shortcut  gca   commit '-a -v -m'
__git_shortcut  gd    diff
__git_shortcut  gdc   diff --cached
__git_shortcut  gds   diff --stat
__git_shortcut  gf    fetch
__git_shortcut  gl    pull --rebase
__git_shortcut  gm    merge --no-ff
__git_shortcut  gp    push
__git_shortcut  grm   commit '-F .git/MERGE_MSG'  # git resolve merge
__git_shortcut  gsh   show
__git_shortcut  gst   status -sb

# Hg
alias delorig='find . \( -name "*.orig" \) -exec rm -v {} \;'
alias hgb='hg branch'
alias hgbs='hg branches'
alias hgc='hg commit -m'
alias hgd='hg cdiff'
alias hgg='hg glog'
alias hgl='hg pull'
alias hglu='hg pull -u'
alias hgst='hg status'
alias hgu='hg update'
alias hgco='hg update'
alias hgp='hg push'
alias hgv='hg view'

# Django
alias rmsyn='rm dev.db; syn'
alias rmsynrun='rm dev.db; syn; run'
alias run='python manage.py runserver 0.0.0.0:8000'
alias syn='python manage.py syncdb --noinput'
alias pmt='python manage.py test'
alias pm='python manage.py'
alias pms='python manage.py shell_plus'
alias edj='subl $HOME/development/python/django'
alias rr='reset; run'
alias rt='python manage.py test --settings=settings_test'

# Emacs
function e {
  if [ "$1" == "" ]; then
    emacsclient --tty  .
  else
    emacsclient --tty $1
  fi
} # open in current terminal.

function ec {
  if [ "$1" == "" ]; then
    emacsclient --no-wait .
  else
    emacsclient --no-wait $1
  fi
} # open in the daemon in the current frame, TODO: must be open already.

function en {
  if [ "$1" == "" ]; then
    emacsclient --no-wait --create-frame .
  else
    emacsclient --no-wait --create-frame $1
  fi
} # open in the dameon in a new frame.

#ed
# http://blog.sanctum.geek.nz/actually-using-ed/
alias ed='ed -p "ed> "'

# colortail
alias tailirc='/usr/bin/colortail -q -k /etc/colortail/conf.irc'
alias colortail='colortail -q -k /etc/colortail/conf.messages'

if _have colortail; then
  alias tailirc='/usr/bin/colortail -q -k /etc/colortail/conf.irc'
  alias colortail='colortail -q -k /etc/colortail/conf.messages'
fi

if _have mpc; then
  alias addall='mpc --no-status clear && mpc listall | mpc --no-status add && mpc play'
  alias n='mpc next'
  alias p='mpc prev'
fi

if _have ossvol; then
  alias u='ossvol -i 3'
  alias d='ossvol -d 3'
  alias m='ossvol -t'
fi # ossvol

# Zile
alias z='zile'

if [[ -b '/dev/sr0' ]]; then
  alias eject='eject -T /dev/sr0'
  alias mountdvd='sudo mount -t iso9660 -o ro /dev/sr0 /media/dvd/'
fi # only if we have a disc drive

# only if we have xmonad
[[ -f '$HOME/.xmonad/xmonad.hs' ]] && alias checkmonad='(cd ~/.xmonad && ghci -ilib xmonad.hs)'

# irssi on remote machine
alias irc='ssh -t irc screen -raAd'

# Audio
# works, but not as an alias. lossless > lossless is bad anyway.
alias mp32ogg='find . -iname "*.mp3" | while read song; do mpg321 ${song} -w - | oggenc -q 9 -o ${song%.mp3}.ogg -; done'

combinepdf() {
  _have gs || return 1
  [[ $# -ge 2 ]] || return 1

  local out='$1'; shift

  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile='$out' '$@'
} # combine pdfs into one using ghostscript

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
} # make a thumb

hbrip() {
  _have HandBrakeCLI || return 1
  [[ -n '$1' ]] || return 1

  local name='$1' out drop='$HOME/Movies'; shift
  [[ -d '$drop' ]] || mkdir -p '$drop'

  out='$drop/$name.mp4'

  echo 'rip /dev/sr0 --> $out'
  HandBrakeCLI -Z iPad '$@' -i /dev/sr0 -o '$out' 2>/dev/null
  echo
} # rip a dvd with handbrake

hbconvert() {
  _have HandBrakeCLI || return 1
  [[ -n '$1' ]] || return 1

  local in='$1' out drop='$HOME/Movies/converted'; shift
  [[ -d '$drop' ]] || mkdir -p '$drop'

  out='$drop/$(basename "${in%.*}").mp4'

  echo 'convert $in --> $out'
  HandBrakeCLI -Z iPad '$@' -i '$in' -o '$out' 2>/dev/null
  echo
} # convert media to ipad format with handbrake

spellcheck() {
  [[ -f /usr/share/dict/words ]] || return 1

  for word in '$@'; do
    if grep -Fqx '$word' /usr/share/dict/words; then
      echo -e '\e[1;32m$word\e[0m' # green
    else
      echo -e '\e[1;31m$word\e[0m' # red
    fi
  done
} # simple spellchecker, uses /usr/share/dict/words

google() {
  [[ -z '$BROWSER' ]] && return 1

  local term='${*:-$(xclip -o)}'

  $BROWSER 'http://www.google.com/search?q=${term// /+}' &>/dev/null &
} # go to google for anything

define() {
  _have lynx || return 1

  local lang charset tmp

  lang='${LANG%%_*}'
  charset='${LANG##*.}'
  tmp='/tmp/define'

  lynx -accept_all_cookies \
       -dump \
       -hiddenlinks=ignore \
       -nonumbers \
       -assume_charset='$charset' \
       -display_charset='$charset' \
       'http://www.google.com/search?hl=$lang&q=define%3A+$1&btnG=Google+Search' | grep -m 5 -C 2 -A 5 -w '*' > '$tmp'

  if [[ ! -s '$tmp' ]]; then
    echo -e 'No definition found.\n'
  else
    echo -e '$(grep -v Search "$tmp" | sed "s/$1/\\\e[1;32m&\\\e[0m/g")\n'
  fi

  rm -f '$tmp'
} # go to google for a definition
