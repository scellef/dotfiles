# Preferences
alias ls='ls --group-directories-first --color'
alias la='ls -A'
alias ll='ls -lhT'
alias grep='grep --color'
alias screen='screen -U'

# Safeties 
alias sl='ls'
alias tial='tail'
alias suod='sudo'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias info='info --vi-keys'
alias view='vim -R'

# Shortcuts
alias L='less'        # Intended to be used like `foo|L`
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ?='echo ${PIPESTATUS[@]}'
alias scr='screen -r'
alias sc='screen '
alias op='xdg-open'
alias clip='xclip -selection clipboard -i'
alias c='vis-clipboard --copy'
alias v='vis-clipboard --paste'
alias rc='. ~/.bashrc'
alias py='python3'
alias py2='python2'
alias p='pushd'
alias o='popd'

# Miscellaneous
alias go-ssh='eval $(ssh-agent) ; ssh-add'
alias mktxt="$EDITOR $(date +%Y%m%d).txt"
alias garbage="cat /dev/urandom | tr -cd '\43-\171'" 
alias pdate='date +%Y%m%d'
alias tstamp="date +%Y%m%d%H%M%S"
alias ustamp="date +%s"
alias ipa='ip addr | grep global | awk "{print $2}"'
alias ipl='ip link'
alias ipr='ip route'
alias tt='t timeline -n 50 -dar -C icon'
alias ts='t stream timeline -C icon -d'

# Git shortcuts
alias gg='git-grab'
alias gita='git add .'
alias gits='git status'
alias gitd='git diff'
alias gitc='git commit'
alias gitl='git log'
alias gitp='git push'
alias gitu='git pull'
alias gitb='git branch'
alias gitr='git remote'

# Vagrant shortcuts
alias vs='vagrant status'
alias vu='vagrant up'
alias vr='vagrant reload'
alias vd='vagrant destroy'
alias vdu='vagrant destroy -f ; vagrant up'
alias vsg='vagrant global-status'
alias vba='vagrant box add'
alias vbl='vagrant box list'
alias vbu='vagrant box update'
alias vssh='vagrant ssh'
alias vpsh='vagrant powershell'
alias vrdp='vagrant rdp'

# Docker shortcuts
alias d='docker'
alias ds='docker ps -a'
alias dr='docker run'
alias de='docker exec'
alias dp='docker pull'
alias dui='docker images --format="{{print (.Repository) \":\" (.Tag) }}" | xargs -n1 docker pull'

# Kubernetes shortcuts
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
alias kgs='kubectl get services'


# In case there local aliases I'd rather not publish to Github
if [ -f ~/.bash_aliases.local ] ; then
  . ~/.bash_aliases.local
fi

# vim: filetype=sh:ts=2:sw=2:expandtab
