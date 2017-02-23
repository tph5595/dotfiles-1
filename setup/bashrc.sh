#!/bin/bash
echo "== Installing ~/.bashrc ..."
this_dir=$(pwd)

IFS=" "

bashrc_parts=" \
  auto_reload \
  default \
  functions \
  aliases \
  tab_completion \
  ruby_on_rails \
  capistrano \
  javascript \
  golang \
  java \
  android \
  docker \
  database_branches \
  shell_fm_aliases \
  prompt"

# Header
cat > ~/.bashrc <<EOF
# Export path of dotfiles repo
export DOTFILES_PATH="$this_dir"

EOF

for part in $bashrc_parts; do
  if [ "$1" = "copy" ]; then
    # Assemble bashrc from parts
    cat assets/bashrc/$part.sh >> ~/.bashrc
  else
    # Source bashrc from parts
    echo "source \"\$DOTFILES_PATH/bashrc/$part.sh\"" >> ~/.bashrc
  fi
done

# Footer
cat >> ~/.bashrc <<EOF

# NVM (Node)
export NVM_DIR="\$HOME/.nvm"
. "\$(brew --prefix nvm)/nvm.sh"

# YARN (Node)
export PATH="\$HOME/.yarn/bin:\$PATH"

# NPM
export PATH="./node_modules/.bin:\$PATH"

# RVM (Ruby)
[ -s "\$HOME/.rvm/scripts/rvm" ] && source "\$HOME/.rvm/scripts/rvm"
export PATH="\$PATH:\$HOME/.rvm/bin" # Add RVM to PATH for scriptingag

# SCM Breeze
[ -s "\$HOME/.scm_breeze/scm_breeze.sh" ] && source "\$HOME/.scm_breeze/scm_breeze.sh"

# Hub tab completion
[ -s "\$HOME/.hub.bash_completion" ] && source "\$HOME/.hub.bash_completion"

# Rails Shell
[ -s "\$HOME/.rails_shell/rails_shell.sh" ] && source "\$HOME/.rails_shell/rails_shell.sh"

# Finalize auto_reload sourced files
finalize_auto_reload
EOF


# If this script was sourced from the terminal, update current shell
if ! [[ "$0" =~ "dev_machine_setup.sh" ]] && [[ "$0" == *bash ]]; then source ~/.bashrc; fi

IFS=$' \t\n'
