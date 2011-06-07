# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ `uname` == "Darwin" ]; then
    # GCC fix for OSX (libjpeg) http://bit.ly/5M3eUC
    export CC=/usr/bin/gcc-4.2 export CPP=/usr/bin/cpp-4.2 export CXX=/usr/bin/g++-4.2
    # homebrew paths
    export PATH=/usr/local/bin:$PATH
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/share/python:$PATH
fi

#default text editor
export LESS="-R"
export EDITOR="emacs -nw"

# GIT
if [ -f $HOME/.git-completion.bash ]; then
    . $HOME/.git-completion.bash
fi

# MERCURIAL
if [ -f $HOME/.hgtab-bash.sh ]; then
    . $HOME/.hgtab-bash.sh
fi

# Virtual Env
if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    . /usr/bin/virtualenvwrapper.sh
fi # arch
if [ -f /usr/local/share/python/virtualenvwrapper.sh ]; then
    . /usr/local/share/python/virtualenvwrapper.sh
fi # homebrew

# History
export HISTSIZE=10000
export HISTFILESIZE=10000
# Don't store duplicate adjacent items in the history
HISTCONTROL=ignoreboth

#Vim
if [ -f /usr/share/vim/vim70 ]; then
    export VIMRUNTIME=/usr/share/vim/vim70
fi
if [ -f /usr/share/vim/vim71 ]; then
    export VIMRUNTIME=/usr/share/vim/vim71
fi
if [ -f /usr/share/vim/vim72 ]; then
    export VIMRUNTIME=/usr/share/vim/vim72
fi

# BIN
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi
echo $PATH | grep -q -s "/usr/local/sbin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/sbin
    export PATH
fi

# Tmux
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
[[ ${TERM} == "screen" ]] && export TERM="rxvt-unicode-256color"
