function error { IFS='\n' printf >&2 "[1;31mERROR: %s[0m\n" "$*" ;}
function success { IFS='\n' printf >&2 "[1;32mSUCCESS: %s[0m\n" "$*" ;}
function warning { IFS='\n' printf >&2 "[1;33mWARNING: %s[0m\n" "$*" ;}
function prompt { IFS='\n' printf >&2 "[1;36m%s[0m\n" "$*" ;}
function quit { prompt "Exiting..." ; exit 0 ;}

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

function ssl {
  cert="$1" && shift 1
  flags="${*--text}"
  openssl x509 -in $cert -noout $flags
}

function sslv {
  hostname="$1"
  port="$2"
  if [ -z $port ] ; then
    port="443"
  fi
  openssl s_client -connect $hostname:$port -servername $hostname -showcerts < /dev/null 2> /dev/null |
  openssl x509 -subject -issuer -dates -noout
}

function sslvv {
  hostname="$1"
  port="$2"
  if [ -z $port ] ; then
    port="443"
  fi
  openssl s_client -connect $1:$2 -servername $hostname -showcerts < /dev/null 2> /dev/null |
  openssl x509 -noout -text
}

function man {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;35m") \
  LESS_TERMCAP_md=$(printf "\e[1;36m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;47;30m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;33m") \
  man "$@"
}

function grepe {
  # Print entire file to stdout with regex highlighted
  grep -E "$1|$" $2
}

function read_dom {
  # Poor man's {X,HT}ML parser, shamelessly ganked from
  # http://stackoverflow.com/a/6541324
  local IFS='\>'
  read -d \< entity content
  local ret="$?"
  tag=${entity%% *}
  attributes=${entity#* }
  return $ret
}

function scrape {
  # Poor man's web scraper
  target="$1"
  url="$2"
  while read_dom ; do
    if [ "$tag" == "$target" ] ; then
      eval local $attributes
      echo $content
    fi
  done <<< $(curl -s $url)
}

function batt {
  if [ -d /sys/class/power_supply/BAT0/ ] ; then
    # sysfs doesn't enclose its variables in spaces.  Working around by
    # temporarily dumping to, sourcing and cleaning up a file
    sed -e 's/=\(.*\)/="\1"/' /sys/class/power_supply/BAT0/uevent > /tmp/BAT0
    source /tmp/BAT0 && rm -f /tmp/BAT0
    if [ "$POWER_SUPPLY_MANUFACTURER" == 'Samsung SDI' ] ; then # Dell Latitude E7470
      echo $(bc <<< "scale=2 ; 100 * $POWER_SUPPLY_CHARGE_NOW / $POWER_SUPPLY_CHARGE_FULL")% remaining
    elif [ "$POWER_SUPPLY_MANUFACTURER" == 'SANYO' ] ; then # ThinkPad T420
      echo $(bc <<< "scale=2 ; 100 * $POWER_SUPPLY_ENERGY_NOW / $POWER_SUPPLY_ENERGY_FULL")% remaining
    else
      echo "INFO: Battery manufacturer unknown; time to update this function?"
    fi
  else
    echo 'WARNING: Could not detect battery... Are you on a laptop?'
  fi
}

function randomstring {
  [ $1 -gt 0 ] 2> /dev/null && length=$1 || length='24'
  cat /dev/urandom | tr -cd '[:alnum:]' | head -c $length ; echo
}


# In case there local aliases I'd rather not publish to Github
if [ -f ~/.bash_functions.local ] ; then
  . ~/.bash_functions.local
fi

# vim: filetype=sh:ts=2:sw=2:expandtab
