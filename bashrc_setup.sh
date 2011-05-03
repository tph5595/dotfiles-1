#!/bin/bash
echo "== Installing custom bashrc..."
this_dir=$(pwd)
cp -f assets/custom_bashrc.sh ~/.custom_bashrc
# Update the 'update' command with the current directory. (# delimiter)
sed -i s#--MYNIX_DIR--#$this_dir#g ~/.custom_bashrc

# Check if ubuntu_bashrc is already installed.
if ! (grep -q ". ~/.custom_bashrc" ~/.bashrc); then
  echo ". ~/.custom_bashrc" >> ~/.bashrc
  echo "===== Installed custom bashrc."
else
  echo "===== Updated custom bashrc."
fi
source ~/.bashrc

echo "===== If you did not run: [ . bashrc_setup.sh ], please run this command: [ source ~/.bashrc ]"

