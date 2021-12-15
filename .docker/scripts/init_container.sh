#!/bin/sh
cat >/etc/motd <<EOL

      _ ___ _____ _     ____    ______     __
     | |_ _| ____| |   |  _ \  | __ ) \   / /
  _  | || ||  _| | |   | | | | |  _ \\ \ / /
 | |_| || || |___| |___| |_| | | |_) |\ V /
  \___/|___|_____|_____|____/  |____/  \_/

Jield BV Docker container

by: Johan van der Heide - info@jield.nl

EOL
cat /etc/motd

# Get environment variables to show up in SSH session
# shellcheck disable=SC2046
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >>/etc/profile)

exec /usr/sbin/sshd -D -e "$@" &
