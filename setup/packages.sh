#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
echo "== Setting up default software packages..."

# -----------------------------------------------------------------------------------
# Base
pkg_base="curl vim htop ack-grep xclip ssh synergy apache2 build-essential"

# Development
pkg_dev="git-core git-gui gitk tig python"

# Databases
pkg_db="postgresql libpq-dev mysql-client libmysqlclient-dev sqlite3 libsqlite3-dev"

# Gnome (OS UI)
pkg_gnome="libnotify-bin python-pyinotify python-webkit python-webkit-dev"

# Addons / Tweaks
pkg_addons="nautilus-image-converter nautilus-open-terminal nautilus-gksu"

# Applications
pkg_apps="vlc thunderbird"

# -----------------------------------------------------------------------------------
# Queue or install apt packages
apt_queue_or_install "$pkg_base $pkg_dev $pkg_gnome $pkg_addons $pkg_apps"

# Add Canonical Partners repository
sudo add-apt-repository "deb http://archive.canonical.com/ $ubuntu_codename partner"

