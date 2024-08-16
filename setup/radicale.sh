#!/bin/bash
# Radicale
##########################

source setup/functions.sh # load our functions
source /etc/mailinabox.conf # load global vars

# ### Installing Radicale

echo "Installing Radicale (contacts/calendar)..."

# Install radicale
hide_output python3 -m pip install --upgrade radicale
#hide_output python3 -m pip install --upgrade radicale-imap

# create radicale user
#id -u radicale >/dev/null 2>&1 || useradd --system --user-group --home-dir / --shell /sbin/nologin radicale

# Create radicale directories and set proper rights
#mkdir -p $STORAGE_ROOT/radicale/etc/
#chown -R radicale:radicale $STORAGE_ROOT/radicale

# Create radicale directories collections and set proper rights
#mkdir -p $STORAGE_ROOT/radicale/collections/
#chown -R radicale:radicale $STORAGE_ROOT/radicale/collections

# Create log directory and make radicale owner
#mkdir -p /var/log/radicale
#chown -R radicale:radicale /var/log/radicale


# Create etc directory and make radicale owner
#mkdir -p /etc/radicale
#chown -R radicale:radicale /etc/radicale

# Radicale Config file
#cat > /etc/radicale/config <<EOF;
#[server]
#hosts = 127.0.0.1:5232
#[auth]
#type = radicale_imap
#imap_hostname = localhost:993
#imap_secure = True
#[rights]
#type = from_file
#file = $STORAGE_ROOT/radicale/etc/rights
#[storage]
#filesystem_folder = $STORAGE_ROOT/radicale/collections
#[logging]
#level=debug
#EOF

# Radicale rights config
#cat > $STORAGE_ROOT/radicale/etc/rights <<EOF;
# Allow reading root collection for authenticated users
#[root]
#user: .+
#collection:
#permissions: R

# Allow reading and writing principal collection (same as username)
#[principal]
#user: .+
#collection: {user}
#permissions: RW

# Allow reading and writing calendars and address books that are direct
# children of the principal collection
#[calendars]
#user: .+
#collection: {user}/[^/]+
#permissions: rw
#EOF

# Radicale Service
cat > /etc/systemd/system/radicale.service <<EOF;
[Unit]
Description=A simple CalDAV (calendar) and CardDAV (contact) server
After=network.target
Requires=network.target

[Service]
ExecStart=/usr/bin/env python3 -m radicale --storage-filesystem-folder=~/.var/lib/radicale/collections
Restart=on-failure
User=root
# Deny other users access to the calendar data
#UMask=0027
# Optional security settings
#PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Reload radicale so that Radicale starts
restart_service radicale