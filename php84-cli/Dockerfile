FROM php:8.4.0RC1-cli

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.4 alpha 2 CLI production Docker container"

ENV TZ="Europe/Amsterdam"

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;

# Set working directory
WORKDIR /var/www

RUN install-php-extensions gd xsl apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql
#RUN install-php-extensions redis xdebug