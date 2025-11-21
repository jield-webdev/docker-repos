FROM php:8.5-fpm

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.5 FPM development Docker container"

ENV TZ="Europe/Amsterdam"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;

# Set working directory
WORKDIR /var/www

RUN apt-get update && \
apt-get install -y --no-install-recommends zip unzip git

RUN #install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql xdebug
RUN install-php-extensions gd redis xsl apcu intl gmp gettext zip opcache soap bcmath snappy pdo_mysql


COPY --from=ghcr.io/php/pie:bin /pie /usr/bin/pie
RUN pie install xdebug/xdebug:3.5.0alpha3