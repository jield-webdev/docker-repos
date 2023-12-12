#!/bin/sh
cat >/etc/motd <<EOL

      _ ___ _____ _     ____    ______     __
     | |_ _| ____| |   |  _ \  | __ ) \   / /
  _  | || ||  _| | |   | | | | |  _ \\ \ / /
 | |_| || || |___| |___| |_| | | |_) |\ V /
  \___/|___|_____|_____|____/  |____/  \_/

Jield BV CLI/Cron Docker container (using supervisor)

by: Johan van der Heide - info@jield.nl

EOL
cat /etc/motd

# This function adds export commands for all server params to the profile page
# export FOOBAR_VAR='value' so these values are generally available in the container
# this is mainly important for CLI cronjobs
# shellcheck disable=SC2046
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >>/etc/profile)
# shellcheck disable=SC2046
eval $(printenv >>/etc/environment)

crontab /etc/cron.d/cronjobs

if [ -z "$@" ]; then
  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon
else
  exec PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin $@
fi