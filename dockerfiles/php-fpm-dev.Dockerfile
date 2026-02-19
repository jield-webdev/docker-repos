ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm

ARG PHP_VERSION
ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP ${PHP_VERSION} FPM development Docker container"

ENV TZ="${TZ}"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV HOME=/tmp \
    RANDFILE=/tmp/.rnd \
    PHP_DATE_TIMEZONE="${TZ}" \
    PHP_MEMORY_LIMIT=2G \
    PHP_MAX_EXECUTION_TIME=300 \
    PHP_MAX_INPUT_VARS=10000 \
    PHP_UPLOAD_MAX_FILESIZE=32M \
    PHP_POST_MAX_SIZE=32M

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql xdebug
