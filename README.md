# docker-repos

Dedicate repo for Docker Repositories

There are 10 versions

* NGINX (azure)
* PHP 8.1 cli (latest, dev)
* PHP 8.1 fpm (latest, dev)
* PHP 8.1 nginx (for azure)
* PHP 8.2 cli (latest, dev)
* PHP 8.2 fpm (latest, dev)
* PHP 8.2 nginx (for azure)
* PHP 8.3 cli (latest, dev)
* PHP 8.3 fpm (latest, dev)
* PHP 8.3 nginx (for azure)

The dev containers are the same as the latest, but only include Xdebug (except for PHP 8.3, which is not yet supported by Xdebug)
Use these containers for your PHP production and development stacks

PHP versions: 

- 8.1.23
- 8.2.10
- 8.3.0 RC1

Azure containers contain an SSH server and default Azure credentials.
Johan van der Heide, Jield BV (info@jield.nl)