alias ls='ls --group-directories-first --color'
alias la='ls -A'
alias ll='ls -lhT'
alias grep='grep --color'

# Safeties and shortcuts
alias sl='ls'
alias tial='tail'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias info='info --vi-keys'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias scr='screen -r'
alias screen='screen -U'
alias o='xdg-open'

alias go='eval $(ssh-agent) ; ssh-add'
alias mktxt="$EDITOR $(date +%Y%m%d).txt"
alias garbage="cat /dev/urandom | tr -cd '\43-\171'" 

alias gits='git status'
alias gitd='git diff'
alias gitl='git log'

# vim: filetype=sh:ts=2:sw=2:expandtab
