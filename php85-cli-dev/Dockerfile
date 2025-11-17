FROM php:8.5.0RC5-cli

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.4 CLI development Docker container"

ENV TZ="Europe/Amsterdam"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
apt-get install -y --no-install-recommends zip unzip

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;
RUN echo 'xdebug.mode=coverage' >> /usr/local/etc/php/conf.d/docker-php-xdebug.ini;

# Set working directory
WORKDIR /var/www

RUN #install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql
RUN install-php-extensions gd redis-6.3.0RC1 xsl apcu intl gmp gettext zip opcache soap bcmath pdo_mysql

COPY --from=ghcr.io/php/pie:bin /pie /usr/bin/pie
RUN pie install xdebug/xdebug:3.5.0alpha3

RUN apt-get update && \
apt-get install -y --no-install-recommends zip unzip git