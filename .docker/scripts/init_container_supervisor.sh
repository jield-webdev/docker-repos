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

#We create a simple PHP file which includes all parameters and can be included in any PHP script
#It is available in the /var/www folder

# shellcheck disable=SC2028
echo '<?php\n' >/var/www/putenv.php
# shellcheck disable=SC2046
eval $(printenv | sed 's/\(.*\)/putenv("\1");/g' >>/var/www/putenv.php)

# Create a file to which cron logs can be written
touch /var/log/cron.log