# docker-repos

Dedicate repo for Docker Repositories
There are several flavors, all for PHP 8.1, 8.2, 8.3, and 8.4:

* NGINX (azure)
* CLI (latest, dev)
* FPM (latest, dev)

Tags:

* ghcr.io/jield-webdev/docker-repos/php8.X-cli:latest
* ghcr.io/jield-webdev/docker-repos/php8.X-cli:dev
* ghcr.io/jield-webdev/docker-repos/php8.X-cli-cron:latest
* ghcr.io/jield-webdev/docker-repos/php8.X-fpm:latest
* ghcr.io/jield-webdev/docker-repos/php8.X-fpm:dev
* ghcr.io/jield-webdev/docker-repos/php8.X-nginx-azure:latest

The dev containers are the same as the latest, but only include Xdebug. The CRON containers are the same as the CLI
latest, but only include the cron daemon. The Azure containers are the same as the latest, but include NGINX, an SSH
server and Redis, so they can operate a single container app in Azure.

PHP versions:

- 8.1.29
- 8.2.22
- 8.3.10
- 8.4.0 alpha 2

Azure containers contain an SSH server and default Azure credentials.
Johan van der Heide, Jield BV (info@jield.nl)