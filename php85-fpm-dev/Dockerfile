FROM php:8.5.0RC2-fpm

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.5 FPM development Docker container"

ENV TZ="Europe/Amsterdam"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;

# Set working directory
WORKDIR /var/www

RUN #install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql xdebug
RUN install-php-extensions gd redis-6.3.0RC1 xsl apcu intl gmp gettext zip opcache soap bcmath snappy pdo_mysql #xdebug-^3.5

## Install Xdebug 3.5.0alpha2 via PECL (without install-php-extensions)
#RUN apt-get update \
#    && apt-get install -y --no-install-recommends $PHPIZE_DEPS \
#    && pecl install xdebug-3.5.0alpha2 \
#    && docker-php-ext-enable xdebug \
#    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $PHPIZE_DEPS \
#    && rm -rf /var/lib/apt/lists/*
