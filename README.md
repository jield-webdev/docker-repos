# docker-repos

Dedicate repo for Docker Repositories
There are several flavours, all for PHP 8.2, 8.3, and 8.4:

* NGINX (azure)
* CLI (dev)
* FPM (latest, dev)
* Worker (latest, dev)

Tags:

* ghcr.io/jield-webdev/docker-repos/php8.X-cli:dev
* ghcr.io/jield-webdev/docker-repos/php8.X-worker:latest
* ghcr.io/jield-webdev/docker-repos/php8.X-fpm:latest
* ghcr.io/jield-webdev/docker-repos/php8.X-fpm:dev
* ghcr.io/jield-webdev/docker-repos/php8.X-nginx-azure:latest

The dev containers are the same as the latest, but only include Xdebug. The CRON containers are the same as the CLI
latest, but only include the cron daemon. The Azure containers are the same as the latest, but include NGINX, an SSH
server and Redis, so they can operate a single container app in Azure.

PHP versions:

- 8.2.26
- 8.3.14
- 8.4.1

Azure containers contain an SSH server and default Azure credentials.
Johan van der Heide, Jield BV (info@jield.nl)