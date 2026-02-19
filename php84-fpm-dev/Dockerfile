FROM php:8.4-fpm

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.4 FPM development Docker container"

## Set a default timezone, can be overridden at build time with --build-arg TZ=Your/Timezone
ARG TZ="Europe/Amsterdam"
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
    PHP_POST_MAX_SIZE=32M \

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql xdebug
