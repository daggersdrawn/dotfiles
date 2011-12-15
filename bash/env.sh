### Set path

# add local bin
if [ -d "/usr/local/bin" ]; then
    PATH="/usr/local/bin:$PATH"
fi

# add local sbin
if [ -d "/usr/local/sbin" ]; then
    PATH="/usr/local/sbin:$PATH"
fi

# add user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# }}}

# command line completion scripts of common Python packages.
source `which pycompletion`

### Set dir colors {{{

if [[ -f "$HOME/dotfiles/bash/dircolors" ]] && [[ $(tput colors) == "256" ]]; then
  # https://github.com/trapd00r/LS_COLORS
  eval $( dircolors -b $HOME/dotfiles/bash/dircolors )
fi

# }}}

### General options {{{

# is $1 installed?
_have() { which "$1" &>/dev/null; }

# python virtual env
if [ -f /usr/bin/virtualenvwrapper.sh ]; then
  . /usr/bin/virtualenvwrapper.sh
fi # arch
if [ -f /usr/local/share/python/virtualenvwrapper.sh ]; then
  . /usr/local/share/python/virtualenvwrapper.sh
fi # homebrew

# history
unset HISTFILESIZE
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y/%m/%d %H:%M "
export HISTIGNORE="&:ls:ll:la:cd:exit:clear:history"
export HISTCONTROL=ignoredups
PROMPT_COMMAND="history -a"
export HISTSIZE PROMPT_COMMAND
shopt -s histappend

# Setting for the new UTF-8 terminal support in Leopard
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# bash 4 features
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
  shopt -s globstar
  shopt -s autocd
fi

shopt -s checkwinsize
shopt -s extglob

# should've done this a long time ago
set -o emacs

# no flow control outside of the dumb tty
if [[ "$TERM" != 'linux' ]]; then
  stty -ixon -ixoff
fi

# list of apps to be tried in order
xbrowsers="browser:chromium:google-chrome:firefox"
browsers="elinks:lynx:links"
editors="emacs:vim:vi"

# }}}

### Overall conditionals/functions {{{
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true

# set $EDITOR
_set_editor() {
  local IFS=':' editor

  for editor in $editors; do
  editor="$(which $editor 2>/dev/null)"

    if [[ -x "$editor" ]]; then
      export EDITOR="$editor"
      export VISUAL="$EDITOR"
      break
    fi
  done
}

# set $BROWSER
_set_browser() {
  local IFS=':' _browsers="$*" browser

  for browser in $_browsers; do
    browser="$(which $browser 2>/dev/null)"

    if [[ -x "$browser" ]]; then
      export BROWSER="$browser"
      break
    fi
  done
}

### OS conditionals {{{
if $_islinux; then
  export LS_OPTIONS="--color=auto"
else
  # GCC fix for OSX (libjpeg) http://bit.ly/5M3eUC
  export CC=/usr/bin/gcc-4.2 export CPP=/usr/bin/cpp-4.2 export CXX=/usr/bin/g++-4.2
  # homebrew paths
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/share/python:$PATH
  alias ec="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient --no-wait $1"
  alias rquicksilver="sudo umount -Af && killall Quicksilver && open /Applications/Quicksilver.app"
  alias killdash="defaults write com.apple.dashboard mcx-disabled -boolean YES; killall Dock;"
  alias startdash="defaults write com.apple.dashboard mcx-disabled -boolean NO; killall Dock;"
  alias o="open ."
  alias o.="open ."
fi

# custom ip var
[[ -f "$HOME/.myip" ]] && export MYIP=$(cat "$HOME/.myip")

# set browser
$_isxrunning && _set_browser "$xbrowsers" || _set_browser "$browsers"

# set editor
_set_editor

export LESS="-QR"
export PAGER=less

# git
if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi

# mercurial
if [ -f $HOME/.hgtab-bash.sh ]; then
  . $HOME/.hgtab-bash.sh
fi


# vim
if [ -f /usr/share/vim/vim70 ]; then
  export VIMRUNTIME=/usr/share/vim/vim70
fi
if [ -f /usr/share/vim/vim71 ]; then
  export VIMRUNTIME=/usr/share/vim/vim71
fi
if [ -f /usr/share/vim/vim72 ]; then
  export VIMRUNTIME=/usr/share/vim/vim72
fi

# dmenu options
if _have dmenu; then
  . "$HOME/.dmenurc"
fi

# tmux
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
[[ ${TERM} == "screen" ]] && export TERM="rxvt-unicode-256color"

# perl
if $_islinux; then
  export PERL_LOCAL_LIB_ROOT="/home/rizumu/perl5";
  export PERL_MB_OPT="--install_base /home/rizumu/perl5";
  export PERL_MM_OPT="INSTALL_BASE=/home/rizumu/perl5";
  export PERL5LIB="/home/rizumu/perl5/lib/perl5/x86_64-linux-thread-multi:/home/rizumu/perl5/lib/perl5";
  export PATH="/home/rizumu/perl5/bin:$PATH";
fi

# }}}
