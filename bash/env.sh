# locales
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# add local bin
if [ -d "/usr/local/bin" ]; then PATH="/usr/local/bin:$PATH"; fi

# add local sbin
if [ -d "/usr/local/sbin" ]; then PATH="/usr/local/sbin:$PATH"; fi

# add user's private bin
if [ -d "$HOME/bin" ]; then PATH="$HOME/bin:$PATH"; fi

# add haskell's cabal bin
if [ -d "$HOME/.cabal/bin" ]; then PATH="$HOME/.cabal/bin:$PATH"; fi

# add pipsi's bin
if [ -d "$HOME/.local/bin" ]; then PATH="$HOME/.local/bin:$PATH"; fi

# add go's bin
if [ -d "/usr/local/opt/go/libexec/bin" ]; then PATH="/usr/local/opt/go/libexec/bin:$PATH"; fi

# add ec2's bin
if [ -d "$HOME/.ec2/" ]; then
  export EC2_HOME=$HOME/.ec2
  export PATH=$PATH:$EC2_HOME/bin
  export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
  export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
  export JAVA_HOME=/usr
fi

if $_islinux; then
  # add perl's bin
  export PERL_LOCAL_LIB_ROOT="$HOME/perl5"
  export PERL_MB_OPT="--install_base $HOME/perl5"
  export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
  export PERL5LIB="$HOME/perl5/lib/perl5/x86_64-linux-thread-multi:$HOME/perl5/lib/perl5"
  export PATH="$HOME/perl5/bin:$PATH"
else
  # add tex's bin
  export PATH=/usr/texbin:$PATH
  # add homebrew's bins
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH
  # add gnu coreutils bins
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
  # add npm's bin
  export PATH="$HOME/.npm-packages/bin:$PATH"
  # add m-cli binary to path
  export PATH=$PATH:/usr/local/m-cli  # https://github.com/rgcr/m-cli
fi

# history save and reload after each command finishes
unset HISTFILESIZE
unset PROMPT_COMMAND
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%Y/%m/%d %H:%M "
export HISTIGNORE="&:ls:ll:la:cd:exit:clear:history"
export HISTCONTROL=ignoredups:erasedups:ignorespace
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -s histappend

# less paging
export LESS="-QR"
export PAGER=less
export LS_OPTIONS="--color=auto"

if ! $_islinux; then
  # no flow control outside of the dumb tty
  stty -ixon -ixoff
  # openssh fix
  eval $(ssh-agent)
  function cleanup {
    echo "Killing SSH-Agent"
    kill -9 $SSH_AGENT_PID
  }
  trap cleanup EXIT
  export SSH_AUTH_SOCK=$HOME/.ssh/ssh-agent.pipe
  # gpg-agent
  if [ -S ${GPG_AGENT_INFO%%:*} ]; then
    export GPG_AGENT_INFO
  else
    eval $( gpg-agent --daemon )
  fi
fi

# set dir colors
if [[ -f "$HOME/dotfiles/bash/dircolors" ]] && [[ $(tput colors) == "256" ]]; then
  # https://github.com/trapd00r/LS_COLORS
  eval $( dircolors -b $HOME/dotfiles/bash/dircolors )
fi

# set $EDITOR
editors="emacsclient --nw:emacs --nw:zile:vim:vi"
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

# set $BROWSER
xbrowsers="firefox:chromium"
browsers="elinks:lynx:links"
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

# homebrew
if [ -f `brew --prefix`/etc/bash_completion ]; then . `brew --prefix`/etc/bash_completion; fi

# dmenu
if _have dmenu; then . "$HOME/.dmenurc"; fi

# tmux
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# git
if [ -f $HOME/.git-completion.bash ]; then . $HOME/.git-completion.bash; fi

# ruby rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# nvm
export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"

# pyenv-virtualenvwrapper
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# werkzeug debugger
export WERKZEUG_DEBUG_PIN="off"

# set ip address
[[ -f "$HOME/.myip" ]] && export MYIP=$(cat "$HOME/.myip")
