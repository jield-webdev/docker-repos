FROM php:8.1-fpm

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.1 FPM development Docker container"

ENV TZ="Europe/Amsterdam"

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd redis apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql xdebug