# Django admin.py color theme
export DJANGO_COLORS='dark'

# Better looking ls output
export LSCOLORS='Gxfxcxdxdxegedabagacad'
export CLICOLOR='1'

# Prompt Colors
BLACK='\[\e[0;30m\]'
BLUE='\[\e[0;34m\]'
GREEN='\[\e[0;32m\]'
CYAN='\[\e[0;36m\]'
RED='\[\e[0;31m\]'
PURPLE='\[\e[0;35m\]'
BROWN='\[\e[0;33m\]'
LGRAY='\[\e[0;37m\]'
DGRAY='\[\e[1;30m\]'
LBLUE='\[\e[1;34m\]'
LGREEN='\[\e[1;32m\]'
LCYAN='\[\e[1;36m\]'
LRED='\[\e[1;31m\]'
LPURPLE='\[\e[1;35m\]'
YELLOW='\[\e[1;33m\]'
WHITE='\[\e[1;37m\]'
NORMAL='\[\e[00m\]'

# Prompt definition
PS1="${LPURPLE}\u${GREEN}@\h${RED}(${YELLOW}\w${RED})${LGREEN}\$(vcprompt)${RED}\$ \n${LPURPLE}✈ ${NORMAL} "
