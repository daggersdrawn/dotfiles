#!/bin/bash

# tell the shell to understand emacs editing commands
set -o emacs

# additional shell options
# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s globstar
shopt -s autocd
shopt -s checkwinsize
shopt -s extglob

# dotfile conditionals
_islinux=false; [[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true
_isarch=false; [[ -f /etc/arch-release ]] && _isarch=true
_isxrunning=false; [[ -n "$DISPLAY" ]] && _isxrunning=true
_isroot=false; [[ $UID -eq 0 ]] && _isroot=true

# https://starship.rs
eval "$(starship init bash)"

# https://atuin.sh
eval "$(atuin init bash)"

# bash configuration
. "$HOME/dotfiles/bash/env.sh"
. "$HOME/dotfiles/bash/aliases.sh"
. "$HOME/dotfiles/bash/git.sh"

# private env vars
if [ -f "$HOME/.private" ]; then . "$HOME/.private"; fi
