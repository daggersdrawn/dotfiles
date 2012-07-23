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

# add haskell cabal bin if it exists
if [ -d "$HOME/.cabal/bin" ]; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

# add ruby's bins if they exists
if [ -d "$HOME/.gem/ruby/1.9.1/bin" ]; then
    PATH="$HOME/.gem/ruby/1.9.1/bin:$PATH"
fi
if [ -d "$HOME/.rbenv/bin" ]; then
    PATH="$HOME/.rbenv/bin:$PATH"
fi
# }}}

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
  export EC2_HOME=~/.ec2
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
# For OSX gcc issues see:
#     http://stackoverflow.com/questions/8473066/gcc-4-2-failed-with-exit-status-1
#     https://github.com/kennethreitz/osx-gcc-installer/downloads
#
if $_islinux; then
  export LS_OPTIONS="--color=auto"
  export PACMAN="pacman-color"
  # command line completion scripts of common Python packages.
  source `which pycompletion`
else
  # command line completion scripts of common Python packages.
  source /usr/local/share/python/pycompletion
  # coreutils fix
  PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  # homebrew paths
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/share/python:$PATH
  alias rquicksilver="sudo umount -Af && killall Quicksilver && open /Applications/Quicksilver.app"
  alias killdash="defaults write com.apple.dashboard mcx-disabled -boolean YES; killall Dock;"
  alias startdash="defaults write com.apple.dashboard mcx-disabled -boolean NO; killall Dock;"
  alias o="open ."
  alias o.="open ."
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
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
