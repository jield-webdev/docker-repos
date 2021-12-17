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
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)
# shellcheck disable=SC2046
eval $(printenv >> /etc/environment)

# Create a file to which cron logs can be written
touch /var/log/cron.log

# Start the supervisor
/usr/bin/supervisord
