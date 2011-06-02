if [ `uname` == "Linux" ]; then
  export LS_OPTIONS="--color=auto"
  eval `dircolors $HOME/dotfiles/bash/dircolors`
fi

# Alias Editing
alias ea="ec $HOME/dotfiles/" # because i edit my bash_profile a lot with new things
alias reload=". $HOME/.profile" # same as previous, after editing you have to source it for the new stuff to work

# Global
alias ..="cd .."        # Go up one directory
alias ...="cd ../.."    # Go up two directories
alias ....="cd ../../.."    # Go up three directories
alias c="clear"         #to clear your terminal
alias delds="find . \( -name '.DS_Store' \) -exec rm -v {} \;"
alias df="df -h"        # Disk free, in gigabytes, not bytes
alias du="du -h -c"     # Calculate total disk usage for a folder
alias grep="grep --color=auto" # Always highlight grep search term
alias h="history"       # shortcut for history
alias hc="history | awk '{a[$2]++}END{for (i in a){print a [i] \' \' i}}' | sort -rn | head" # show most commonly used command
alias ping="ping -c 5"  # Pings with 5 packets, not unlimited
function take {
    mkdir $1
    cd $1
}
alias cal="cal -3" # show 3 months by default
alias units="units -t" # terse mode
alias diff="LC_ALL=C TZ=GMT0 diff -Naur" # normalise diffs for distribution
alias lynx="lynx -force_html -width=$COLUMNS" # best settings for viewing HTML

alias l="ls -AF $LS_OPTIONS"        # Compact view, show hidden
alias la="ls -haliF $LS_OPTIONS"    # l for list style, a for all including hidden, h for human readable file sizes, i for inode to determine hardlinks
alias ll="ls -lFh $LS_OPTIONS"      # Long view, no hidden
alias ls="ls -GFp $LS_OPTIONS"      # Compact view, show colors

# task
alias t="c && task ls"

# Find and Replace
function rep() {
    for i in `grep -R --exclude="*.svn*" "$1" * | sed s/:.*$//g | uniq`; do
        sed -i ".bak" -e "s#$1#$2#g" $i
    done
}

# I hate noise
set bell-style visible

# Tell less not to beep and also display colours
export LESS="-QR"
alias vless="vim -u $VIMRUNTIME/macros/less.vim"

# Processes
alias tm="top -o vsize" #memory
alias tu="top -o cpu" #cpu

# Bash
# GREP_COLOR=bright yellow on black bg.
# use GREP_COLOR=7 to highlight whitespace on black terminals
# LANG=C for speed. See also: http://www.pixelbeat.org/scripts/findrepo
alias grep="GREP_COLOR='1;33;40' LANG=C grep --color=auto"

# Pacman
alias pacupg="sudo pacman -Syu" # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacin="sudo pacman -S"    # Install specific package(s) from the repositories
alias pacins="sudo pacman -U"   # Install specific package not from the repositories but from a file 
alias pacre="sudo pacman -R"    # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem="sudo pacman -Rns" # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep="pacman -Si"       # Display information about a given package in the repositories
alias pacreps="pacman -Ss"      # Search for package(s) in the repositories
alias pacloc="pacman -Qi"       # Display information about a given package in the local database
alias paclocs="pacman -Qs"      # Search for package(s) in the local database
alias pacupd="sudo pacman -Sy && sudo abs" # Update and refresh the local package and ABS databases against repositories
alias pacinsd="sudo pacman -S --asdeps"    # Install given package(s) as dependencies of another package
alias pacmir="sudo pacman -Syy"            # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist


# Python
alias delpyc="find . \( -name '*.pyc' -o -name '*.pyo' \) -exec rm -v {} \;"
alias p="ipython"
alias path="python -c 'from distutils.sysconfig import get_python_lib; print get_python_lib()'"
alias site="cd $(python -c 'from distutils.sysconfig import get_python_lib; print get_python_lib()')"
alias emailserver="python -m smtpd -n -c DebuggingServer localhost:1025"

# Screen
alias s="screen"
alias sl="screen -ls"

# Git
alias git="hub"
alias ga="git add"
alias gb="git branch"
alias gba="git branch -a"
alias gc="git commit -v -m"
alias gca="git commit -v -a -m"
alias gco="git checkout"
alias gd="git diff"
alias gdm="git diff master n"
alias gg="git log -p -2 --pretty=format:'%h - %an, %ar : %s' --shortstat"
alias glog="git log --graph"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
alias grau="git remote add upstream"
alias glum="git pull upstream master"
# Setup a tracking branch from [remote] [branch_name]
function gbt() {
    git branch --track $2 $1/$2
    git checkout $2
}
function grf() {
    rm $1
    git checkout $1
}
function gmd() {
    git checkout master
    git merge dev
    git push
    git checkout dev
}

# Hg
alias delorig="find . \( -name '*.orig' \) -exec rm -v {} \;"
alias hgb="hg branch"
alias hgbs="hg branches"
alias hgc="hg commit -m"
alias hgd="hg cdiff"
alias hgg="hg glog"
alias hgl="hg pull"
alias hglu="hg pull -u"
alias hgst="hg status"
alias hgu="hg update"
alias hgco="hg update"
alias hgp="hg push"
alias hgv="hg view"

# Django
alias rmsyn="rm dev.db; syn"
alias rmsynrun="rm dev.db; syn; run"
alias run="python manage.py runserver 0.0.0.0:8000"
alias syn="python manage.py syncdb --noinput"
alias pmt="python manage.py test"
alias pm="python manage.py"
alias pms="python manage.py shell_plus"
alias edj="subl $HOME/development/python/django"
. $HOME/dotfiles/bash/django_bash_completion
alias rr="reset; run"
alias rt="python manage.py test --settings=settings_test"

# Emacs
alias e="emacs -nw"
function ec {
    if ! ps aux | egrep "emacs$" | grep -v grep > /dev/null;
        then emacs &
        sleep 4
    fi
    if [ "$1" == "" ]; then
        emacsclient --no-wait .
    else
        emacsclient --no-wait $1
    fi
}

# Zile
alias z="zile"

# Unidad
alias woc="deactivate || true && cd $HOME/development/unidad/comunidad && . ACTIVATE"

# OSX
if [ `uname` == "Darwin" ]; then
    alias ec="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient --no-wait $1"
    alias rquicksilver="sudo umount -Af && killall Quicksilver && open /Applications/Quicksilver.app"
    alias killdash="defaults write com.apple.dashboard mcx-disabled -boolean YES; killall Dock;"
    alias startdash="defaults write com.apple.dashboard mcx-disabled -boolean NO; killall Dock;"
    alias o="open ."
    alias o.="open ."
fi
