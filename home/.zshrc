# -*- shell-script -*-
# 
# anrxc's init file for Z-SHELL 4.3.10 on Arch GNU/Linux.


# {{{ User settings

# {{{ Environment
export PATH="${PATH}:${HOME}/code/bin"
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export LESSHISTFILE="-"
export PAGER="less"
export READNULLCMD="${PAGER}"
export VISUAL="emacsclient"
export EDITOR="${VISUAL}"
export BROWSER="firefox"
export XTERM="urxvt"
# }}}

# {{{ Dircolors
#     - with rxvt-256color support
eval `dircolors -b "${HOME}/dotfiles/bash/dircolors"`
# }}}

# {{{ Manual pages
#     - colorize, since man-db fails to do so
export LESS_TERMCAP_mb=$'\E[01;31m'   # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'   # begin bold
export LESS_TERMCAP_me=$'\E[0m'       # end mode
export LESS_TERMCAP_se=$'\E[0m'       # end standout-mode
export LESS_TERMCAP_so=$'\E[1;33;40m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'       # end underline
export LESS_TERMCAP_us=$'\E[1;32m'    # begin underline
# }}}

# {{{ Aliases

# {{{ Main
alias ..="cd .."
alias ...="cd ../.."
alias ls="ls -aF --color=always"
alias ll="ls -l"
alias lfi="ls -l | egrep -v '^d'"
alias ldi="ls -l | egrep '^d'"
alias lst="ls -htl | grep `date +%Y-%m-%d`"
alias grep="grep --color=always"
alias cp="cp -ia"
alias mv="mv -i"
alias rm="rm -i"
alias cls="clear"
alias upmem="ps -eo pmem,pcpu,rss,vsize,args | sort -k 1"
alias top="htop"
alias psg="ps auxw | grep -i "
alias psptree="ps auxwwwf"
alias df="df -hT"
alias du="du -hc"
alias dus="du -S | sort -n"
alias free="free -m"
alias su="su - "
alias x="startx &! logout"
alias rehash="hash -r"
alias eject="eject -v "
alias retract="eject -t -v "
alias vuser="fuser -v "
alias ping="ping -c 5"
alias more="less"
alias mc=". /usr/lib/mc/mc-wrapper.sh -x"
alias links="links ${HOME}/.links/startpage.html"
alias play="play -v"
alias xtr="extract"
alias last='last -adn 10'
alias screen="screen -U -l"
alias scr="screen -r"
alias scd="screen -rd"
alias sat="date +%R"
alias bat="acpitool -b"
alias calc="bc -l <<<"
alias iodrag="ionice -c3 nice -n19"
alias spell="aspell -a <<< "
alias ec="emacsclient -a emacs -n "
alias ect="emacsclient -a emacs -t "
alias gpgd="gpg2 --decrypt"
alias gpge="gpg2 -ear anrxc"
alias passgen="< /dev/urandom tr -cd \[:graph:\] | fold -w 32 | head -n 5"
alias keyshare="synergys -f --config /etc/synergy.conf"
alias xpop="xprop | grep --color=none 'WM_CLASS\|^WM_NAME' | xmessage -file -"
# }}}

# {{{ Pacman
alias pacsy="sudo pacman -Sy"               # Sync & Update
alias pacup="sudo pacman -Syu"              # Sync, Update & Upgrade
alias pacdg="sudo pacman -Syuu"             # Sync, Update & Downgrade
alias paclu="pacman -Qu"                    # List upgradeable
alias pacin="sudo pacman -S"                # Install a specific package
alias pacnd="sudo pacman -Sdd"              # Install a package but ignore deps
alias pacrm="sudo pacman -Rns"              # Remove a specific package
alias pacrd="sudo pacman -Rdd"              # Remove a package but ignore deps
alias pacss="pacman -Ss"                    # Search for a package
alias pacsl="pacman -Qs"                    # Search for a package localy
alias pacsi="pacman -Si"                    # Package info
alias pacqi="pacman -Qi"                    # Package local info
alias pacls="pacman -Ql"                    # List files in a package
alias pacui="pacman -Qm"                    # List localy built packages
alias pacfi="pacman -Qo"                    # Which package file belongs to
alias paccl="sudo pacman -Scc"              # Fully clean the package cache
alias pacdl="sudo pacman -Sw"               # Download a package without installing
alias paclo="pacman -Qdt"                   # List package orphans
alias paclog="pacman -Qc"                   # Package changelog
# }}}

# {{{ Slurpy
alias aurup="slurpy -c -u -d"               # Sync, Update & Download
alias aurlu="slurpy -c -u"                  # Update & List upgradeable
alias aurss="slurpy -c -s"                  # Search for a package
alias aursi="slurpy -c -i"                  # Package info
alias aurgo="slurpy -c -g"                  # Visit AUR page
alias aurdl="slurpy -c -d"                  # Download a package without installing
# }}}

# {{{ Swaret
alias swup="sudo swaret --update --upgrade" # Sync, Update & Upgrade
alias swsy="sudo swaret --update"           # Sync & Update
alias swlu="sudo swaret --list -u"          # List upgradeable
alias swin="sudo swaret --install"          # Install a specific package
alias swrm="sudo swaret --remove"           # Remove a specific package
alias swss="sudo swaret --search"           # Search for a package
swsl() { sudo swaret --search "$1" -i }     # Search for a package localy
swsi() { sudo swaret --show "$1" -p }       # Package info
swqi() { sudo swaret --show "$1" -i }       # Package local info
swls() { less `locate /var/log/packages/"$1"` } # List files in a package
swfi() { grep "$1" /var/log/packages/* }    # Which package file belongs to
alias swui="sudo swaret --search aic -i"    # List localy built packages
alias swcl="sudo swaret --purge"            # Fully clean the package cache
alias swdl="sudo swaret --get"              # Download a package without installing
alias swlog="sudo swaret --changelog"       # Package changelog
# }}}
# }}}

# {{{ Completion
compctl -k "(add delete draft edit list import preview publish update)" nb
# }}}
# }}}


# {{{ ZSH settings
setopt emacs
setopt nohup
setopt autocd
setopt cdablevars
setopt ignoreeof
setopt nobgnice
setopt nobanghist
setopt clobber
setopt shwordsplit
setopt interactivecomments
setopt autopushd pushdminus pushdsilent pushdtohome
setopt histreduceblanks histignorespace inc_append_history

# Prompt requirements
setopt extended_glob prompt_subst
autoload colors zsh/terminfo

# New style completion system
autoload -U compinit; compinit
#  * List of completers to use
zstyle ":completion:*" completer _complete _match _approximate
#  * Allow approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric
#  * Selection prompt as menu
zstyle ":completion:*" menu select=1
#  * Menu selection for PID completion
zstyle ":completion:*:*:kill:*" menu yes select
zstyle ":completion:*:kill:*" force-list always
zstyle ":completion:*:processes" command "ps -au$USER"
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;32"
#  * Don't select parent dir on cd
zstyle ":completion:*:cd:*" ignore-parents parent pwd
#  * Complete with colors
zstyle ":completion:*" list-colors ""
# }}}


# {{{ Functions
function web ()   { "${BROWSER}" "http://yubnub.org/parser/parse?command=${*}" }
function pmem ()  { ps -o rss,comm -p `pgrep "$1"` }
function dsync () { rsync -lprt --progress --stats --delete "$1/" "$2/" }

function snap () {
    [ "$2" ] && tmout="$2"  || tmout=5
    [ "$3" ] && format="$3" || format=png
    fname="${HOME}/$1-`date +%d%m%y-%H%M`"
    for ((i=${tmout}; i>=1; i--)) do; echo -n "${i}.. "; sleep 1; done
    import -window root -quality 100 "${fname}.${format}"
    convert -resize "15%" "${fname}.${format}" "${fname}.th.${format}"
    echo ": ${fname}.${format}"
}

function extract () {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tbz2 | *.tar.bz2) tar -xvjf  "$1"     ;;
            *.txz | *.tar.xz)   tar -xvJf  "$1"     ;;
            *.tgz | *.tar.gz)   tar -xvzf  "$1"     ;;
            *.tar | *.cbt)      tar -xvf   "$1"     ;;
            *.zip | *.cbz)      unzip      "$1"     ;;
            *.rar | *.cbr)      unrar x    "$1"     ;;
            *.arj)              unarj x    "$1"     ;;
            *.ace)              unace x    "$1"     ;;
            *.bz2)              bunzip2    "$1"     ;;
            *.xz)               unxz       "$1"     ;;
            *.gz)               gunzip     "$1"     ;;
            *.7z)               7z x       "$1"     ;;
            *.Z)                uncompress "$1"     ;;
            *.gpg)       gpg2 -d "$1" | tar -xvzf - ;;
            *) echo 'Error: failed to extract "$1"' ;;
        esac
    else
        echo 'Error: "$1" is not a valid file for extraction'
    fi
}

# {{{ Terminal and prompt
function precmd {
    # Terminal width = width - 1 (for lineup)
    local TERMWIDTH
    ((TERMWIDTH=${COLUMNS} - 1))

    # Truncate long paths
    PR_FILLBAR=""
    PR_PWDLEN=""
    local PROMPTSIZE="${#${(%):---(%n@%m:%l)---()--}}"
    local PWDSIZE="${#${(%):-%~}}"
    if [[ "${PROMPTSIZE} + ${PWDSIZE}" -gt ${TERMWIDTH} ]]; then
	((PR_PWDLEN=${TERMWIDTH} - ${PROMPTSIZE}))
    else
        PR_FILLBAR="\${(l.((${TERMWIDTH} - (${PROMPTSIZE} + ${PWDSIZE})))..${PR_HBAR}.)}"
    fi
}

function preexec () {
    # Screen window titles as currently running programs
    if [[ "${TERM}" == "screen-256color" ]]; then
        local CMD="${1[(wr)^(*=*|sudo|-*)]}"
        echo -n "\ek$CMD\e\\"
    fi
}

function setprompt () {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_"${color}"="%{${terminfo[bold]}$fg[${(L)color}]%}"
	eval PR_LIGHT_"${color}"="%{$fg[${(L)color}]%}"
    done
    PR_NO_COLOUR="%{${terminfo[sgr0]}%}"

    # Try to use extended characters to look nicer
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{${terminfo[enacs]}%}"
    PR_SHIFT_IN="%{${terminfo[smacs]}%}"
    PR_SHIFT_OUT="%{${terminfo[rmacs]}%}"
    PR_HBAR="${altchar[q]:--}"
    PR_ULCORNER="${altchar[l]:--}"
    PR_LLCORNER="${altchar[m]:--}"
    PR_LRCORNER="${altchar[j]:--}"
    PR_URCORNER="${altchar[k]:--}"

    # Terminal prompt settings
    case "${TERM}" in
        dumb) # Simple prompt for dumb terminals
            unsetopt zle
            PROMPT='%n@%m:%~%% '
            ;;
        linux) # Simple prompt with Zenburn colors for the console
            echo -en "\e]P01e2320" # zenburn black (normal black)
            echo -en "\e]P8709080" # bright-black  (darkgrey)
            echo -en "\e]P1705050" # red           (darkred)
            echo -en "\e]P9dca3a3" # bright-red    (red)
            echo -en "\e]P260b48a" # green         (darkgreen)
            echo -en "\e]PAc3bf9f" # bright-green  (green)
            echo -en "\e]P3dfaf8f" # yellow        (brown)
            echo -en "\e]PBf0dfaf" # bright-yellow (yellow)
            echo -en "\e]P4506070" # blue          (darkblue)
            echo -en "\e]PC94bff3" # bright-blue   (blue)
            echo -en "\e]P5dc8cc3" # purple        (darkmagenta)
            echo -en "\e]PDec93d3" # bright-purple (magenta)
            echo -en "\e]P68cd0d3" # cyan          (darkcyan)
            echo -en "\e]PE93e0e3" # bright-cyan   (cyan)
            echo -en "\e]P7dcdccc" # white         (lightgrey)
            echo -en "\e]PFffffff" # bright-white  (white)
            PROMPT='$PR_GREEN%n@%m$PR_WHITE:$PR_YELLOW%l$PR_WHITE:$PR_RED%~$PR_YELLOW%%$PR_NO_COLOUR '
            ;;
        *)  # Main prompt
            PROMPT='$PR_SET_CHARSET$PR_GREEN$PR_SHIFT_IN$PR_ULCORNER$PR_GREEN$PR_HBAR\
$PR_SHIFT_OUT($PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m$PR_WHITE:$PR_YELLOW%l$PR_GREEN)\
$PR_SHIFT_IN$PR_HBAR$PR_GREEN$PR_HBAR${(e)PR_FILLBAR}$PR_GREEN$PR_HBAR$PR_SHIFT_OUT(\
$PR_RED%$PR_PWDLEN<...<%~%<<$PR_GREEN)$PR_SHIFT_IN$PR_HBAR$PR_GREEN$PR_URCORNER$PR_SHIFT_OUT\

$PR_GREEN$PR_SHIFT_IN$PR_LLCORNER$PR_GREEN$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_RED%?$PR_WHITE:)%(!.$PR_RED.$PR_YELLOW)%#$PR_GREEN)$PR_NO_COLOUR '

            RPROMPT=' $PR_GREEN$PR_SHIFT_IN$PR_HBAR$PR_GREEN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'
            ;;
    esac
}

# Prompt init
setprompt
# }}}
# }}}
