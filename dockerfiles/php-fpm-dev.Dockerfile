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
    RANDFILE=/tmp/.rnd

RUN { \
      echo "date.timezone=${TZ}"; \
      echo "memory_limit=2G"; \
      echo "max_execution_time=300"; \
      echo "max_input_vars=10000"; \
      echo "upload_max_filesize=32M"; \
      echo "post_max_size=32M"; \
    } > /usr/local/etc/php/conf.d/zz-custom.ini

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql xdebug
