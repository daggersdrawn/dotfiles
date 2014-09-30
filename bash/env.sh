### Set path {{{

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

# add haskell cabal bin if it exists
if [ -d "$HOME/.cabal/bin" ]; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

# add ruby's bins if they exist
if [ -d "$HOME/.gem/ruby/1.9.1/bin" ]; then
    PATH="$HOME/.gem/ruby/1.9.1/bin:$PATH"
fi
if [ -d "$HOME/.rbenv/bin" ]; then
    PATH="$HOME/.rbenv/bin:$PATH"
fi

# Load RVM into a shell session *as a function*
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
    . "$HOME/.rvm/scripts/rvm"
fi
# }}}


### General options {{{

# is $1 installed?
_have() { which "$1" &>/dev/null; }

# python virtual env
export VIRTUALENVWRAPPER_PYTHON=`which python`
export VIRTUALENVWRAPPER_VIRTUALENV=`which virtualenv`
source `which virtualenvwrapper.sh`

# history
# Save and reload the history after each command finishes
unset HISTFILESIZE
unset PROMPT_COMMAND
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%Y/%m/%d %H:%M "
export HISTIGNORE="&:ls:ll:la:cd:exit:clear:history"
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -s histappend

# Setting for the new UTF-8 terminal support in Leopard
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


if [ -d "$HOME/.ec2/" ]; then
  export EC2_HOME=$HOME/.ec2
  export PATH=$PATH:$EC2_HOME/bin
  export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
  export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
  export JAVA_HOME=/usr
fi

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
xbrowsers="browser:uzbl-browser:chromium:firefox"
browsers="elinks:lynx:links"
editors="subl:emacsclient --nw:emacs:zile:vim:vi"

# }}}

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
_set_editor

# set ip address
[[ -f "$HOME/.myip" ]] && export MYIP=$(cat "$HOME/.myip")

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

# dmenu options
# tmux
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
[[ ${TERM} == "screen" ]] && export TERM="rxvt-unicode-256color"

# }}}


### System conditionals {{{
# For OSX gcc issues see:
#     http://stackoverflow.com/questions/8473066/gcc-4-2-failed-with-exit-status-1
#     https://github.com/kennethreitz/osx-gcc-installer/downloads
#
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true

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
$_isxrunning && _set_browser "$xbrowsers" || _set_browser "$browsers"

# command line completion scripts of common Python packages.
# pip install pycompletion into system python
[[ `which pycompletion` ]] && source `which pycompletion`

if $_islinux; then
  export LS_OPTIONS="--color=auto"
  export PACMAN="pacman"
else  # assume osx
  # latex/auctex
  export PATH=/usr/texbin:$PATH
  # homebrew paths
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/share/npm/bin:$PATH
  # coreutils fix
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  alias rquicksilver="sudo umount -Af && killall Quicksilver && open /Applications/Quicksilver.app"
  alias killdash="defaults write com.apple.dashboard mcx-disabled -boolean YES; killall Dock;"
  alias startdash="defaults write com.apple.dashboard mcx-disabled -boolean NO; killall Dock;"
  alias o="open ."
  alias o.="open ."
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
  # openssh fix
  eval $(ssh-agent)
  function cleanup {
    echo "Killing SSH-Agent"
    kill -9 $SSH_AGENT_PID
  }
  trap cleanup EXIT
fi

# perl
if $_islinux; then
  export PERL_LOCAL_LIB_ROOT="$HOME/perl5";
  export PERL_MB_OPT="--install_base $HOME/perl5";
  export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
  export PERL5LIB="$HOME/perl5/lib/perl5/x86_64-linux-thread-multi:$HOME/perl5/lib/perl5";
  export PATH="$HOME/perl5/bin:$PATH";
fi

# }}}


### Set dir colors {{{

if [[ -f "$HOME/dotfiles/bash/dircolors" ]] && [[ $(tput colors) == "256" ]]; then
  # https://github.com/trapd00r/LS_COLORS
  eval $( dircolors -b $HOME/dotfiles/bash/dircolors )
fi

# set $EDITOR
_set_editor() {
  local IFS=':' editor

  for editor in $editors; do
    editor_binary=`echo $editor | cut -f 1 -d ' '`
    if [ "$editor" == "${editor//[\' ]/}" ]; then
      editor_args=""  # does not contain arguments
    else
      editor_args=`echo $editor | cut --complement -f1 -d ' '`
    fi
    editor_binary="$(which $editor_binary 2>/dev/null)"
    if [[ -x "$editor_binary" ]]; then
      export EDITOR="$editor_binary $editor_args"
      export VISUAL="$EDITOR"
      break
    fi
  done
}
_set_editor

# }}}
