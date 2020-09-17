# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Append to the history file, don't overwrite it
shopt -s histappend histverify
history -a

# Set unlimited history file size
# In bash 4.3 and later, you can set the history envars to -1 to explicitly
# declare unlimited history.  Earlier versions have a similar effect if the
# variables are declared with an empty string.
IFS='.' read -a bash_version <<< "$BASH_VERSION"
if [ ${bash_version[0]} -ge 4 ] ; then
  if [ ${bash_version[1]} -ge 3 ] ; then
    HISTSIZE='-1' HISTFILESIZE='-1'
  else
    HISTSIZE='' HISTFILESIZE=''
  fi
else
  HISTSIZE='' HISTFILESIZE=''
fi

# Ignore lines beginning with space
HISTCONTROL=ignorespace

# Prepend a timestamp in front of each command
HISTTIMEFORMAT="%F:%T "

# Ensuring UTF-8 behaves
export LC_ALL="en_US.UTF-8"

# Praise be to the Editor of the Beast
export EDITOR='/usr/bin/vim'

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias & Function definitions.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

if [ ! -d ~/.backup ]; then
	mkdir ~/.backup
fi

if [ -f ~/.bashrc.local ] ; then
  . ~/.bashrc.local
fi

# Bash completion, I am lost without you
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f /usr/share/bash-completion/bash_completion ] ; then
  . /usr/share/bash-completion/bash_completion
fi


# Fedora 23/24 apparently doesn't source system-installed shell
# completion for users by default.  Adding this for completenesses sake.
if [ -f /usr/share/bash-completion/bash_completion ] ; then
    . /usr/share/bash-completion/bash_completion
fi

# Adding kubectl completion, if available
if [ -n "$(which kubectl 2> /dev/null)" ] ; then
  source <(kubectl completion bash)
  complete -F __start_kubectl k
fi

# Adding docker completion shortcut, if available
if [ -n "$(which docker 2> /dev/null)" ] ; then
  complete -F _docker d
fi

# Adding minikube completion shortcut, if available
if [ -n "$(which minikube 2> /dev/null)" ] ; then
  source <(minikube completion bash)
  complete -F __start_minikube m
fi

set -o emacs 

# Color Definitions
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# PS1 Descriptive Variables
Time24h="\t"
PathFull="\w"
PathShort="\W"
NewLine="\n"
Jobs="\j"
User="\u"
Host="\h"
Root='\$'

GITDirty="\"$BRed$Root$Color_Off \""
GITStage="\"$BGreen$Root$Color_Off \""
GITClean="\"$IBlack$Root$Color_Off \""
GITPrompt="['$BGreen$User$Color_Off'@'$BBlue$Host$Color_Off' '$BCyan$PathShort$Color_Off']"
Prompt="['$Green$User$Color_Off'@'$Blue$Host$Color_Off' '$Cyan$PathShort$Color_Off']\"$IBlack$Root$Color_Off\"\ "
export PS1=$IBlack$Time24h$Color_Off\ '$(
  if [ $? -eq 0 ] ; then \
    echo "'$BGreen+$Color_Off'" ; \
  else \
    echo "'$BRed-$Color_Off'" ; fi) \
$(
  git rev-parse --git-dir > /dev/null 2>&1 /dev/null; \
  if [ $? -eq 0 ] ; then \
    git status -s | grep -q '^' ; \
    if [ $? -eq 1 ] ; then \
      echo '$GITPrompt$GITClean' ; \
    else \
      git status -s | grep -qe '^[AMRD]' ; \
      if [ $? -eq 0 ] ; then \
        echo '$GITPrompt$GITStage' ; \
      else \
        echo '$GITPrompt$GITDirty' ; \
      fi \
    fi \
  else \
    echo '$Prompt' ; \
  fi
)' 

# In case the overwrought PS1 starts breaking or stalling out (happens on remotely mounted git repos),
# ensure we have an out for a humbler prompt:
alias simple-prompt="export PS1='$IBlack$Time24h$Color_Off [$Green$User$Color_Off@$Blue$Host$Color_Off $Cyan$PathShort$Color_Off]$IBlack$Root$Color_Off '"

# And in case the colors aren't availble:
alias simple-prompt-bw="export PS1='$Time24h [$User@$Host $PathShort]$Root '"

if [ ! -z $STY ] ; then  # If we're in a screen, just set the hostname
  export PROMPT_COMMAND='echo -ne "\033k${HOSTNAME%%.*}\033\\"'
else                     # Otherwise, set the terminal title
  export PROMPT_COMMAND='echo -ne "\033]0;$(date +%T) [${USER}@${HOSTNAME%%.*}]\007"'
fi

# In case there are local modifications that I don't want to add above
if [ -f ~/.bashrc.local ] ; then
  . ~/.bashrc.local
fi

umask 022

# vim: filetype=sh:ts=2:sw=2:expandtab
