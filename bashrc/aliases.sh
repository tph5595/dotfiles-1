# -------------------------------------------------------
# Aliases, functions & key bindings
# -------------------------------------------------------

# Substitute user/group with user symbol, if defined at ~/.user_sym
# Before : -rw-rw-r-- 1 ndbroadbent ndbroadbent 1.1K Sep 19 21:39 scm_breeze.sh
# After  : -rw-rw-r-- 1 𝐍  𝐍  1.1K Sep 19 21:39 scm_breeze.sh
# if [ -e $HOME/.user_sym ]; then
#   _ll_processor=" | sed \"s/ $USER/ \$(/bin/cat $HOME/.user_sym)/g\" | rejustify_ls_columns"
# fi

LS_CMD=$(which gls > /dev/null 2>&1 && echo "gls" || echo "ls")

alias l="\\$LS_CMD -Cv --group-directories-first"
alias ll="\\$LS_CMD -lhv --group-directories-first $_ls_processor"
alias la="\\$LS_CMD -lhvA --group-directories-first $_ls_processor"

alias rmrf='rm -rf'
alias ldu='du -cks * | sort -rn | head -15' # Lists the size of all the folders

alias s='sudo'
alias ss='ssh'
alias ss2='ssh -p2202'
alias n='nautilus .'
alias le="less"
alias psg='ps aux | grep'
alias sbrc="source ~/.bashrc"

alias grd="~/code/git-remove-debug/git-remove-debug"

which ack-grep > /dev/null 2>&1 || alias ack-grep="ack"
[ -n "$(which greadlink)" ] && alias readlink="greadlink"

alias aga='ag -a'
alias agi='ag -i'

alias agr='ag --type=ruby'
alias agri='ag -i --type=ruby'

alias fl='fastlane'

alias rn='react-native'
alias rnl='react-native link'
# The React Native packager often crashes.
alias rns='while true; do react-native start; done'
alias rnsr='react-native start --reset-cache'
alias rni='react-native run-ios'
alias rnir='react-native run-ios --configuration "Release"'
alias rnid='react-native run-ios --device'
alias rnird='react-native run-ios --configuration "Release" --device'
alias rnli='react-native log-ios'
alias rna='react-native run-android'
alias rnar='react-native run-android --variant=release'
alias rnas='react-native run-android --variant=releaseStaging'
alias rnla='react-native log-android'
alias rnw='react-native run-windows'
alias rnwp='react-native run-wpf'

alias ds='osascript .dev.scpt "$(pwd)" &'

alias f='cd ~/code/form_api'
alias fd='f; ds'

alias ed='c envkey-client-server; ds'

if [ "$(uname)" = Darwin ]; then
  alias beep="afplay /System/Library/Sounds/Glass.aiff"
  bark() {
    for i in $(seq ${1:-1}); do
      afplay $DOTFILES_PATH/sounds/bark.aiff
    done
  }
  alias bork="bark"
else
  alias beep="mplayer /usr/share/sounds/gnome/default/alerts/glass.ogg > /dev/null 2>&1"
  alias bark="mplayer $DOTFILES_PATH/sounds/bark.aiff > /dev/null 2>&1"
  alias bork="bark"
fi

# Edit file function - if SCM Breeze is installed, expand numeric arguments
function edit_file() {
  if type exec_scmb_expand_args > /dev/null 2>&1; then
    if [ -z "$1" ]; then
      # No arguments supplied, open the editor at the current directory.
      exec_scmb_expand_args $GUI_EDITOR "."
    else
      exec_scmb_expand_args $GUI_EDITOR "$@"
    fi
  else
    $GUI_EDITOR "$@"
  fi
}
alias e="edit_file"

alias ~='cd ~'
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

for mod in x w r; do
  alias -- "+$mod"="chmod +$mod"
  alias -- "-$mod"="chmod -- -$mod"
done

# Aliases for scripts in ~/bin
# ----------------------------
alias cb="simple_clipboard"
# Copy contents of a file
alias cbf="simple_clipboard <"
# Copy SSH public key
alias cbs="echo 'Copying ~/.ssh/id_rsa.pub to clipboard...' && simple_clipboard < ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbd="pwd | simple_clipboard"
# Copy current git SHA-1
alias cbg="echo 'Copying latest commit hash to clipboard...' && git rev-parse --verify HEAD | simple_clipboard"

# Apt
# -------------------------------------------------
alias apt-i='sudo apt-get install -y'
alias apt-u='sudo apt-get update'
alias apt-s='apt-cache search'
apt-sd() { apt-cache search $1 | grep "lib.*dev "; } # Search for dev files
alias apt-r='sudo apt-get remove'
alias apt-a='sudo apt-get autoremove'

# Mac
# ---------------
alias flushdns='dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Git
# -------------------------------------------------
# Adds all changes to current commit and then force pushes.
# Never use this on a team project!!
alias GFORCE='git add -A && git commit --amend -C HEAD && git push -f'

alias pv="pivotal"

# -------------------------------------------------
# Include configurable bash aliases, if file exists
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# ---------------------------------------------------------
# Alias management (helper functions for ~/.bash_aliases)
# ---------------------------------------------------------

# Adds an alias to ~/.bash_aliases.
# ------------------------------------------------
add_alias() {
  if [ -n "$2" ]; then
    touch ~/.bash_aliases
    echo "alias $1=\"$2\"" >> ~/.bash_aliases
    source ~/.bashrc
  else
    echo "Usage: add_alias <alias> <command>"
  fi
}
# Adds a change directory alias to ~/.bash_aliases.
# Use '.' for current working directory.
# Changes directory, then lists directory contents.
# ------------------------------------------------
add_dir_alias() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    path=`dirname $2/.`   # Fetches absolute path.
    touch ~/.bash_aliases
    echo "alias $1=\"cd $path; ll\"" >> ~/.bash_aliases
    source ~/.bashrc
  else
    echo "Usage: add_dir_alias <alias> <path>"
  fi
}
# Remove an alias
# ------------------------------------------------
rm_alias() {
  if [ -n "$1" ]; then
    touch ~/.bash_aliases
    grep -Ev "alias $1=" ~/.bash_aliases > ~/.bash_aliases.tmp
    mv ~/.bash_aliases.tmp ~/.bash_aliases
    unalias $1
    source ~/.bashrc
  else
    echo "Usage: rm_alias <alias>"
  fi
}

