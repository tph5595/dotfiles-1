# -------------------------------------------------------
# Aliases, functions & key bindings
# -------------------------------------------------------

# -- bash
alias l='ls -Cv --group-directories-first'
alias ll='ls -lv --group-directories-first'
alias la='ls -lvA --group-directories-first'
alias ldu='du -cks * | sort -rn | head -15' # Lists the size of all the folders

alias _='sudo'
alias n='nautilus .'
alias ak='ack-grep'
alias aka='ack-grep -a'
alias aki='ack-grep -i'
alias psg='ps ax | grep'
alias e="ge geany"
alias sbrc="source ~/.bashrc"

cpmkdir() {
  if [ -z "$1" ]; then echo -e "Usage: cpmkdir <source> <dest dir>"; return 1; fi
  if [ ! -d "$2" ]; then mkdir -p "$2"; fi
  cp -R "$1" "$2"
}

alias ~='cd ~'
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# -- apt
alias apt-install='sudo apt-get install -y'
alias apt-search='apt-cache search'
# Search for development files
apt-search-dev() { apt-cache search $1 | grep "lib.*dev "; }

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

