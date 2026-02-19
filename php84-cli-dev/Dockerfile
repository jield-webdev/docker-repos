FROM php:8.4-cli

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.4 CLI development Docker container"

## Set a default timezone, can be overridden at build time with --build-arg TZ=Your/Timezone
ARG TZ="Europe/Amsterdam"
ENV TZ="${TZ}"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
apt-get install -y --no-install-recommends zip unzip

ENV HOME=/tmp \
    RANDFILE=/tmp/.rnd \
    PHP_DATE_TIMEZONE="${TZ}" \
    PHP_MEMORY_LIMIT=-1 \
    PHP_XDEBUG_MODE=coverage \

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql xdebug