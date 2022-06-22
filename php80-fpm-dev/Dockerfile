FROM php:8.0-fpm

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos/php8.0-fpm"
LABEL org.opencontainers.image.description="PHP 8.0 FPM development Docker container"

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd redis apcu igbinary xdebug