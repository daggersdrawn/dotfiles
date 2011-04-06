export DOTFILES=$HOME/dotfiles

. "$DOTFILES/bash/env.sh"
. "$DOTFILES/bash/config.sh"
. "$DOTFILES/bash/aliases.sh"

if [ -f "$HOME/.private" ]; then
    . "$HOME/.private"
fi
