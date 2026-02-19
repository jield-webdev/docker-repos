FROM php:8.4-cli

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.4 CLI production Docker worker container"

## Set a default timezone, can be overridden at build time with --build-arg TZ=Your/Timezone
ARG TZ="Europe/Amsterdam"
ENV TZ="${TZ}"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql

ENV HOME=/tmp \
    RANDFILE=/tmp/.rnd \
    PHP_DATE_TIMEZONE="${TZ}" \
    PHP_MEMORY_LIMIT=-1 \
    PHP_XDEBUG_MODE=coverage \

## Install cron, redis and supervisor
RUN apt-get update && apt-get install -y cron redis-server supervisor nano zip unzip

# Set working directory
WORKDIR /var/www

# Copy crontab file to the cron.d directory
COPY .docker/crontab/crontab.sample /etc/cron.d/cronjobs

# Copy entrypoint file to the etc
COPY .docker/scripts/entrypoint_cron.sh /etc/entrypoint.sh
COPY .docker/supervisor/supervisord.cron.conf /etc/supervisor/conf.d/supervisord.conf

# Give correct rights to the cron job
RUN chmod 0644 /etc/cron.d/cronjobs

# Give execution rights to the entrypoint
RUN chmod +x /etc/entrypoint.sh

# Run the command on container startup
ENTRYPOINT [ "/etc/entrypoint.sh" ]