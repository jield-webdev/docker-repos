FROM php:8.6.0-fpm-trixie

ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.6 FPM development Docker container"

ENV TZ=${TZ} \
    HOME=/tmp \
    RANDFILE=/tmp/.rnd

COPY --from=ghcr.io/mlocati/php-extension-installer:2.13.2 /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN { \
      echo "date.timezone=${TZ}"; \
      echo "memory_limit=2G"; \
      echo "max_execution_time=300"; \
      echo "max_input_vars=10000"; \
      echo "upload_max_filesize=32M"; \
      echo "post_max_size=32M"; \
    } > /usr/local/etc/php/conf.d/docker-php-ext-custom.ini

RUN --mount=type=bind,source=dockerfiles/php86-install-extensions.sh,target=/tmp/php86-install-extensions.sh \
    sh /tmp/php86-install-extensions.sh && php-fpm -t

WORKDIR /var/www
