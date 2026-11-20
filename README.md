# docker-repos

Dedicate repo for Docker Repositories
There are several flavours for PHP 8.2, 8.3, 8.4 and 8.5, with the following features:

* NGINX (azure)
* CLI (dev, arm64)
* FPM (latest, dev, arm64)
* Worker (latest, arm64)

Tags:

* ghcr.io/jield-webdev/docker-repos/php8.X-cli:(dev,latest)
* ghcr.io/jield-webdev/docker-repos/php8.X-worker:(latest,arm64)
* ghcr.io/jield-webdev/docker-repos/php8.X-fpm:(latest,dev,arm64)
* ghcr.io/jield-webdev/docker-repos/php8.X-nginx-azure:latest

The dev and arm64 containers are the same as the latest, but only include Xdebug.
The Worker containers are the same as the CLI latest but these include supervisor to run symfony/messenger and cron.
The Azure containers are the same as the latest, but include NGINX, an SSH server, and Redis, so they can operate a
single container app in Azure.

PHP versions:

- 8.2.36
- 8.3.37
- 8.4.28
- 8.5.13

## PHP 8.6 development images

The dedicated PHP 8.6.0 CLI and FPM images include GD, Redis, XSL, APCu, igbinary, Intl, GMP,
Gettext, Zip, Zend OPcache, SOAP, BCMath, Snappy, PDO MySQL and Xdebug. The PHP 8.6 development workflow
uses the `ghcr.io/jield-webdev/docker-repos/php8.6-cli:dev` and
`ghcr.io/jield-webdev/docker-repos/php8.6-fpm:dev` tags.

Build and check both images from the repository root.

```sh
docker build -f dockerfiles/php86-cli-dev.Dockerfile -t php8.6-cli:dev .
docker build -f dockerfiles/php86-fpm-dev.Dockerfile -t php8.6-fpm:dev .
docker run --rm php8.6-cli:dev php -m
docker run --rm php8.6-fpm:dev php-fpm -m
```

## MySQL

MySQL version 9.7.1

Azure containers contain an SSH server and default Azure credentials.
Regards, Johan van der Heide, Jield BV (johan.vanderheide@jield.nl)
