#!/bin/sh

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
    }    "
}

__git_shortcut () {
    # shellcheck disable=SC2139
    alias "$1"="git $2 $3"
    __git_complete "$1" _git_"$2" > /dev/null 2>&1
}

__git_shortcut  ga    add
__git_shortcut  gbr   branch --set-upstream
__git_shortcut  gco   checkout
__git_shortcut  gc    commit '-v'
__git_shortcut  gca   commit '-a -v'
__git_shortcut  gcm   commit '-v -m'
__git_shortcut  gd    diff -M
__git_shortcut  gd.   diff -M --color-words='.'
__git_shortcut  gdc   diff -M --cached
__git_shortcut  gdc.  diff -M --cached --color-words='.'
__git_shortcut  gds   diff --stat
__git_shortcut  gf    fetch
__git_shortcut  gg    grep '--color -n -h --heading --break'
__git_shortcut  gl    pull --rebase
__git_shortcut  gm    merge --no-ff
__git_shortcut  gp    push
__git_shortcut  grm   commit '-F .git/MERGE_MSG'  # git resolve merge
__git_shortcut  gsh   show
__git_shortcut  gst   status -sb

alias gap='ga -p'
alias gcb='git-cut-branch'
alias gcompare='hub compare'
alias gdh='git describe --exact-match HEAD'
alias gin='git-incoming'
alias fp='format-patch --stdout'
alias gla='git log --graph --date-order --pretty=format":%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias glb='git log --graph'
alias glc='git log --pretty=oneline --graph --all'
alias gld='git log --decorate --stat --graph --pretty=format:"%C(yellow)%h%Creset (%ar - %Cred%an%Creset), %s%n"'
alias gle='git log --pretty=oneline --abbrev-commit --max-count=15'
alias glf='git log -p -2 --pretty=format:"%h - %an, %ar : %s" --shortstat'
alias gout='git-outgoing'
alias gprune='git remote prune origin'
alias grh='git reset HEAD'
alias grso='git remote show origin'
alias gt='git-track'
alias gw='hub browse'
alias grb='git rebase --preserve-merges origin/$(git_current_branch)'
alias gsti='git ls-files --others -i --exclude-standard'
alias unstage='reset HEAD'
alias staged='diff --cached'
alias unstaged='diff'
alias changes='git log --name-status HEAD..'

gr() {
  git grep --full-name --files-with-matches "$1" | xargs sed -i -e "s/$1/$2/g"
}  # git replace: find and replace in current directory of a git repo

git_current_branch() {
  git symbolic-ref HEAD 2> /dev/null | cut -b 12-
}

gcpfalr() {
  git --git-dir="$1"/.git format-patch -k -1 --stdout "$2"| git am -3 -k
}  # git cherry pick from another local repo. $ gcpfalr ../path/to/repo SHA

gbt() {
  git branch --track "$2" "$1"/"$2"
  git checkout "$2"
}  # Setup a tracking branch from [remote] [branch_name]

grrb() {
  git checkout "$1" &&
  git branch "$2" origin/"$1" &&
  git push origin "$2" &&
  git push origin :"$1" &&
  git checkout dev &&
  git branch -D "$1"
}  # git remove remote branch
