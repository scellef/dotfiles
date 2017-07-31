function error { IFS='\n' printf >&2 "[1;31mERROR: %s[0m\n" "$*" ;}
function success { IFS='\n' printf >&2 "[1;32mSUCCESS: %s[0m\n" "$*" ;}
function warning { IFS='\n' printf >&2 "[1;33mWARNING: %s[0m\n" "$*" ;}
function prompt { IFS='\n' printf >&2 "[1;36m%s[0m\n" "$*" ;}
function quit { prompt "Exiting..." ; exit 0 ;}

function git-grab {
  # Pull from the specified repos all at once
  targets=( ${*:-$(pwd)} )
  for target in ${targets[*]} ; do
    printf "%-20s: " ${target}
    git -C $target pull --rebase
  done
}

function tcp {
  # Shortcut for making a TCP connection using bash's builtin capability
  cat < /dev/tcp/"$1"/"$2"
}

function udp {
  # Shortcut for making a UDP connection using bash's builtin capability
  cat < /dev/udp/"$1"/"$2"
}

function csr {
  # Parse a CSR and return it's full contents or specified values
  certReq="$1" && shift 1
  flags="${*--text}"
  openssl req -in $certReq -noout $flags
}

function ssl {
  # Parse a PEM certificate and return it's full contents or specified values
  cert="$1" && shift 1
  flags="${*--text}"
  openssl x509 -in $cert -noout $flags
}

function sslv {
  # Connect to a specified host and print some basic information about its certificate
  hostname="$1"
  port="${2:-443}"
  openssl s_client -connect $hostname:$port -servername $hostname -showcerts < /dev/null 2> /dev/null |
  openssl x509 -subject -issuer -dates -noout
}

function sslvv {
  # Connect to a specified host and print all information about its certificate
  hostname="$1"
  port="${2:-443}"
  openssl s_client -connect $hostname:$port -servername $hostname -showcerts < /dev/null 2> /dev/null |
  openssl x509 -noout -text
}

function man {
  # Environmental variables for colorized manpages
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
  # Print kernel's understanding of the remaining charge in system battery
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
  # Sometimes you just need a string full of garbage
  [ $1 -gt 0 ] 2> /dev/null && length=$1 || length='24'
  cat /dev/urandom | tr -cd '[:alnum:]' | head -c $length ; echo
}

function convert-win-timestamp {
  # Number of 100-nanosecond intervals since 1601 Jan 1 UTC
  date -d @$(bc <<< "${1}/10000000-11644473600") '+%F %T %Z'
}

function convert-unix-timestamp {
  # Number of seconds since 1970 Jan 1 UTC
  date -d @${1} '+%F %T %Z'
}

function parse-yaml {
  # Half-assed YAML parser for distinguishing keys from values
  local prefix=$2
  local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\($s\):|\1|" \
       -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
       -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
  awk -F$fs '{
     indent = length($1)/2;
     vname[indent] = $2;
     for (i in vname) {if (i > indent) {delete vname[i]}}
     if (length($3) > 0) {
        vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
        printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
     }
  }'
}

function stubborn-ssh {
  # Continue attempting to ssh into a host until it finally lets you
  # Usually used when waiting on a system to come back online
  false

  while [ $? -ne 0 ]; do
    sleep 3;
    ssh $@ && true;
  done
}

function time-page-load {
  # Generate a TSV of timings for website page loads
  siteUrl="$1"

  prompt "Recording page load times, Ctrl+C to exit:"
  while : ; do
    export TIMEFORMAT=%2R ; date +%T | tr '\n' '\t' >> $siteUrl.tsv
    { time curl -sko /dev/null $siteUrl ;} 2>> $siteUrl.tsv
    sleep 300
  done
}



# In case there local aliases I'd rather not publish to Github
if [ -f ~/.bash_functions.local ] ; then
  . ~/.bash_functions.local
fi

# vim: filetype=sh:ts=2:sw=2:expandtab
