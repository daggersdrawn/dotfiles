# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ `uname` == "Darwin" ]; then
    # GCC fix for OSX (libjpeg) http://bit.ly/5M3eUC
    export CC=/usr/bin/gcc-4.2 export CPP=/usr/bin/cpp-4.2 export CXX=/usr/bin/g++-4.2
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

# SQL
#PATH=${PATH}:/usr/local/mysql/bin
#export PGDATA=/usr/local/pgsql/bin

# Virtual Env
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
export VIRTUALENVWRAPPER_TMPDIR=/tmp/virtualenv
export PIP_VIRTUALENV_BASE=$WORKON_HOME
if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    . /usr/bin/virtualenvwrapper.sh
fi

# History
export HISTSIZE=10000
export HISTFILESIZE=10000
# Don't store duplicate adjacent items in the history
HISTCONTROL=ignoreboth

# Setting PATH for Python + Ruby bin folders
export PATH=/usr/bin/python2:"$PATH"
export PYTHONPATH=$PYTHONPATH:/usr/lib/python2.7/site-packages
export PATH=/usr/local/Cellar/ruby/1.9.1-p378/bin:"$PATH"
export PATH=/Users/mal4ik/.gem/ruby/1.8/bin:"$PATH"

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
