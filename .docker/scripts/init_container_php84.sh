#!/bin/sh
cat >/etc/motd <<EOL

      _ ___ _____ _     ____    ______     __
     | |_ _| ____| |   |  _ \  | __ ) \   / /
  _  | || ||  _| | |   | | | | |  _ \\ \ / /
 | |_| || || |___| |___| |_| | | |_) |\ V /
  \___/|___|_____|_____|____/  |____/  \_/

Jield BV Nginx container (Including PHP 8.4 and Redis server for Azure)

by: Johan van der Heide - info@jield.nl

EOL
cat /etc/motd