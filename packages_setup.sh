#!/bin/bash
. _shared.sh
echo "== Processing required software packages..."

if ! (apt-cache search nautilus-dropbox | grep -q nautilus-dropbox); then
  # Dropbox source
  echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" | sudo tee "/etc/apt/sources.list.d/dropbox.list" > /dev/null
  sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
fi

# -----------------------------------------------------------------------------------
# Base
pkg_base="curl ack-grep vim xclip synergy apache2 python"

# Git
pkg_git="git-core git-gui gitk tig"

# Ruby Libraries
pkg_ruby_libs="libyaml-ruby libzlib-ruby libruby
imagemagick libmagickwand-dev libmagickcore-dev libxslt1-dev libxml2-dev
mysql-server libmysql-ruby libmysqlclient-dev postgresql libpq-dev sqlite3 libsqlite3-dev"

# Gnome (OS UI)
pkg_gnome="libnotify-bin python-pyinotify python-webkit python-webkit-dev
avant-window-navigator avant-window-navigator-data awn-settings
awn-applets-c-core libawn1 vala-awn"

# Addons / Tweaks
pkg_addons="nautilus-dropbox nautilus-image-converter gedit-plugins"

# Applications
pkg_apps="vlc thunderbird skype"

# -----------------------------------------------------------------------------------
# Queue or install apt packages
apt_queue_or_install "$pkg_base $pkg_git $pkg_ruby_libs $pkg_gnome $pkg_addons $pkg_apps"


# Start skype on system startup
cat > ~/.config/autostart/skype.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=skype
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Skype
Comment=
EOF

