# docker-repos

Dedicate repo for Docker Repositories
There are several flavours, all for PHP 8.1, 8.2, 8.3, and 8.4:

* NGINX (azure)
* CLI (dev, arm64)
* FPM (latest, dev, arm64)
* Worker (latest, arm64)

Tags:

* ghcr.io/jield-webdev/docker-repos/php8.X-cli:(dev,arm64)
* ghcr.io/jield-webdev/docker-repos/php8.X-worker:(latest,arm64)
* ghcr.io/jield-webdev/docker-repos/php8.X-fpm:(latest,dev,arm64)
* ghcr.io/jield-webdev/docker-repos/php8.X-nginx-azure:latest

The dev and arm64 containers are the same as the latest, but only include Xdebug.
The Worker containers are the same as the CLI latest but these include supervisor to run symfony/messenger and cron.
The Azure containers are the same as the latest, but include NGINX, an SSH server, and Redis, so they can operate a
single container app in Azure.

PHP versions:

- 8.1.32 (only Azure container)
- 8.2.28
- 8.3.21
- 8.4.7

Azure containers contain an SSH server and default Azure credentials.
Johan van der Heide, Jield BV (johan.vanderheide@jield.nl)
