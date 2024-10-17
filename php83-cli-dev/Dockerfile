FROM php:8.3-cli

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.3 CLI development Docker container"

ENV TZ="Europe/Amsterdam"

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;
RUN echo 'xdebug.mode=coverage' >> /usr/local/etc/php/conf.d/docker-php-xdebug.ini;

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql xdebug

RUN apt-get update && \
apt-get install -y --no-install-recommends zip