alias ls='ls --group-directories-first --color'
alias la='ls -A'
alias ll='ls -lhT'
alias grep='grep --color'

# Safeties and shortcuts
alias sl='ls'
alias tial='tail'
alias suod='sudo'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias info='info --vi-keys'
alias view='vim -R'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ?='echo ${PIPESTATUS[@]}'
alias screen='screen -U'
alias scr='screen -r'
alias o='xdg-open'
alias clip='xclip -selection clipboard -i'

alias go='eval $(ssh-agent) ; ssh-add'
alias mktxt="$EDITOR $(date +%Y%m%d).txt"
alias garbage="cat /dev/urandom | tr -cd '\43-\171'" 
alias tstamp="date +%Y%m%d%H%M%S"
alias ipa='ip addr | grep global | awk "{print $2}"'
alias ipl='ip link'
alias ipr='ip route'

alias gg='git-grab'
alias gita='git add -p'
alias gits='git status'
alias gitd='git diff'
alias gitc='git commit'
alias gitl='git log'
alias gitp='git push'
alias gitu='git pull'

# In case there local aliases I'd rather not publish to Github
if [ -f ~/.bash_aliases.local ] ; then
  . ~/.bash_aliases.local
fi

# vim: filetype=sh:ts=2:sw=2:expandtab
