function git-grab {
  cd "$*" ; git pull ; cd -
}

function git-stat {
  cd "$*" ; git status -s ; cd - > /dev/null
}

function tcp {
  cat < /dev/tcp/"$1"/"$2"
}

function udp {
  cat < /dev/udp/"$1"/"$2"
}

function sslv {
  hostname="$1"
  port="$2"
  if [ -z $port ] ; then
    port="443"
  fi
  openssl s_client -connect $hostname:$port -showcerts < /dev/null 2> /dev/null |
  openssl x509 -subject -issuer -dates -noout
}

function sslvv {
  hostname="$1"
  port="$2"
  if [ -z $port ] ; then
    port="443"
  fi
  openssl s_client -connect $1:$2 -showcerts < /dev/null 2> /dev/null |
  openssl x509 -noout -text
}

# In case there are local aliases I'd rather not publish to Github
if [ -f ~/.bash_functions.local ] ; then
  . ~/.bash_functions.local
fi

# vim: filetype=sh:ts=2:sw=2:expandtab
