#!/bin/bash
# sourced by .bashrc

# simple spellchecker, uses /usr/share/dict/words {{{
spellcheck() {
  for word in "$@"; do
    if grep -qnx "$word" /usr/share/dict/words; then
      echo -en "\e[1;32mRIGHT\e[0m"
    else
      echo -en "\e[1;31mWRONG\e[0m"
    fi
    echo " :: $word"
  done
}
# }}}

# go to google for anything {{{
# googleIt() { 
#   local term="$*" 
#  
#   [ -z "$term" ] && term="$(xclip -o)" 
#  
#   local URL="http://www.google.com/search?q=${term// /+}" 
#  
#   $BROWSER "$URL" &>/dev/null & 
# } 
# }}}

# go to google for a definition {{{
define() {
  local LNG=$(echo $LANG | cut -d '_' -f 1)
  local CHARSET=$(echo $LANG | cut -d '.' -f 2)
  
  lynx -accept_all_cookies -dump -hiddenlinks=ignore -nonumbers -assume_charset="$CHARSET" -display_charset="$CHARSET" "http://www.google.com/search?hl=$LNG&q=define%3A+$1&btnG=Google+Search" | grep -m 5 -C 2 -A 5 -w "*" > /tmp/define

  if [ ! -s /tmp/define ]; then
    echo "No definition found."
    echo
  else
    echo -e "$(grep -v Search /tmp/define | sed "s/$1/\\\e[1;32m&\\\e[0m/g")"
    echo
  fi
  rm -f /tmp/define
}
# }}}

# accepts a relative path and returns an absolute 
rel2abs() {
  local file="$(basename "$1")"
  local dir="$(dirname "$1")"

  pushd "${dir:-./}" &>/dev/null && local dir="$PWD"
  popd &>/dev/null

  echo "$dir/$file"
}

# recursively 'fix' dir/file perm
fix() {
  if [ -d "$1" ]; then 
    find "$1" -type d -exec chmod 755 {} \; 
    find "$1" -type f -exec chmod 644 {} \;
  else
    echo "usage: fix [directory]"
  fi
}

# manage services 
service() {
  if [ $# -lt 2 ]; then
    echo "usage: service [service] [stop|start|restart]"
  else
    sudo /etc/rc.d/$1 $2
  fi
}

# open a GUI app from CLI 
open() {
  if [ -z "$1" ]; then
    echo "usage: open [application]"
  else
    $* &>/dev/null &
  fi
}

# auto send an attachment from CLI 
send() {
  if [ $# -ne 2 ]; then
    echo "usage: send [file] [recipient]"
  else
    echo "Auto-sent from Arch Linux. Please see attached." | mutt -s "File Attached" -a $1 $2
  fi
}

# simple calculator 
calc() {
  if which bc &>/dev/null; then
    echo "scale=3; $*" | bc -l
  else
    awk "BEGIN { print $* }"
  fi
}

aurInstalled() {
  echo -e "$*\t\t" `date +'%D'` >> ~/builds/installed
}

# watch TV at given channel
#TV() {
#  if [ -z "$1" ]; then
#    echo "Usage: TV channel [mplayerOpts]"
#    echo "Defaulting to currently tuned channel!"
#  else
#    ivtv-tune -c $1
#  fi  
#  mplayer -really-quiet /dev/video $2
#}
