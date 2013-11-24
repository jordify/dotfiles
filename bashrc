# .bashrc

# exit if we're in a script
[ -z "$PS1" ] && return

# source some files
[ -f $HOME/.dotfiles/.bash_functions ] && source $HOME/.dotfiles/.bash_functions
[ -f $HOME/.dotfiles/.bash_exports ] && source $HOME/.dotfiles/.bash_exports
[ -f $HOME/.dotfiles/.bash_alias ] && source $HOME/.dotfiles/.bash_alias

# advanced bash-completion
[ -f /etc/bash_completion ] && source /etc/bash_completion

# shell completiong with sudo 
complete -cf sudo

# Edit cmd in vim using Esc,v
set -o vi
bind -m vi-insert "\C-n":menu-complete
bind -m vi-insert "\C-p":dynamic-complete-history
bind -m vi-insert "\C-l":clear-screen

# set the titlebar in xterm/urxvt
case "$TERM" in
  xterm*|rxvt*) PROMPT_COMMAND='echo -ne "\0033]0;${HOSTNAME} ${PWD/$HOME/~}\007"' ;;
  *) ;;
esac

# set the titlebar in screen
if [ -n "$STY" ]; then
  PROMPT_COMMAND='echo -ne "\0033k${PWD/$HOME/~}/\0033\\"'
fi

if [ $(id -u) -eq 0 ]; then
  BB="\e[1;31m"
else
  BB="\e[1;34m"
fi

BW="\e[1;37m"
W="\e[0m"

# //host_name/exit_status/working_directory
PS1="\[$BB\]//\[$BW\]\h\[$BB\]/\[$BW\]\$?\[$BB\]/\[$BW\]\w/ \[$W\]"
PS2="\[$BB\]// \[$W\]"

# fallback prompt
#PS1='[ \A ][ \w ]\n> '
#PS2='>'

# stop here if we're root
[ $(id -u) -eq 0 ] && return

# auto startx if on tty1 and logout if/when X ends
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
  startx
  logout
fi

## Clear
#clear

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
