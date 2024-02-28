#!/bin/bash

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

# shellcheck disable=SC2154
if $_islinux; then
  # add perl's bin
  export PERL_LOCAL_LIB_ROOT="$HOME/perl5"
  export PERL_MB_OPT="--install_base $HOME/perl5"
  export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
  export PERL5LIB="$HOME/perl5/lib/perl5/x86_64-linux-thread-multi:$HOME/perl5/lib/perl5"
  export PATH="$HOME/perl5/bin:$PATH"
  # add bash completions
  . /usr/share/bash-completion/bash_completion
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
  # add bash completions
  . /usr/local/etc/bash_completion.d/pass
  if [ -f "$(brew --prefix)"/etc/bash_completion ]; then . "$(brew --prefix)"/etc/bash_completion; fi
fi

# less
export LESS="-QR"
export PAGER=less
export LS_OPTIONS="--color=auto"
export LESSHISTFILE=-
export LESSOPEN="| src-hilite-lesspipe.sh %s"

if ! $_islinux; then
  # no flow control outside of the dumb tty
  stty -ixon -ixoff
  # replace apple openssh with homebrew openssh
  eval "$(ssh-agent)"
  function cleanup {
    echo "Killing SSH-Agent"
    kill -9 "$SSH_AGENT_PID"
  }
  trap cleanup EXIT
  # gpgtools gpg-agent
  AGENT_PID=$(ps axc | awk "{if (\$5==\"gpg-agent\") print \$1}")
  export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent:$AGENT_PID:1"
  GPG_TTY=$(tty)
  export GPG_TTY
  export SSH_AUTH_SOCK=$HOME/.ssh/auth_sock
  if ! fuser "$SSH_AUTH_SOCK" >/dev/null 2>/dev/null; then
      # Nothing has the socket open, it means the agent isn't running
      ssh-agent -a "$SSH_AUTH_SOCK" -s > "$HOME/.ssh/agent-info"
  fi
fi

# set dircolors: https://github.com/trapd00r/LS_COLORS
if [[ -f "$HOME/dotfiles/bash/dircolors" ]] && [[ $(tput colors) == "256" ]]; then
  eval "$(dircolors -b "$HOME/dotfiles/bash/dircolors")"
fi

# git completion
. "$HOME/dotfiles/bash/git-completion.bash"

# set $EDITOR
editors="emacsclient --nw:emacs --nw:zile:vim:vi"
_set_editor() {
  local IFS=':' editor
  for editor in $editors; do
    editor_binary=$(echo "$editor" | cut -f 1 -d ' ')
    if [ "$editor" == "${editor//[\' ]/}" ]; then
      editor_args=""  # does not contain arguments
    else
      editor_args=$(echo "$editor" | cut --complement -f1 -d ' ')
    fi
    editor_binary="$(which "$editor_binary" 2>/dev/null)"
    if [[ -x "$editor_binary" ]]; then
      export EDITOR="$editor_binary $editor_args"
      export VISUAL="$EDITOR"
      break
    fi
  done
}
_set_editor

# set $BROWSER
xbrowsers="librewolf:firefox"
browsers="elinks:lynx:links"
_set_browser() {
  local IFS=':' _browsers="$*" browser
  for browser in $_browsers; do
    browser="$(which "$browser" 2>/dev/null)"
    if [[ -x "$browser" ]]; then
      export BROWSER="$browser"
      break
    fi
  done
}
# shellcheck disable=SC2154
if $_isxrunning; then _set_browser "$xbrowsers"; else _set_browser "$browsers"; fi

# tmux
[[ -s "$HOME/.tmuxinator/scripts/tmuxinator" ]] && . "$HOME/.tmuxinator/scripts/tmuxinator"

# haskell+ghcup
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# rye
export PATH="$HOME/.rye/shims:$PATH"

# werkzeug debugger
export WERKZEUG_DEBUG_PIN="off"
