ARG PHP_VERSION=8.6.0
FROM php:${PHP_VERSION}-cli

ARG PHP_VERSION
ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP ${PHP_VERSION} CLI development Docker container"

ENV TZ=${TZ}

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get install -y --no-install-recommends zip unzip

ENV HOME=/tmp \
    RANDFILE=/tmp/.rnd

RUN { \
      echo "date.timezone=${TZ}"; \
      echo "memory_limit=-1"; \
      echo "xdebug.mode=coverage"; \
    } > /usr/local/etc/php/conf.d/docker-php-ext-custom.ini

# Set working directory
WORKDIR /var/www

RUN #install-php-extensions gd xsl intl gmp gettext zip soap bcmath pdo_mysql xdebug-3.6.0alpha1
RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql xdebug
