FROM php:8.6.0-cli-trixie

ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.6 CLI development Docker container"

ENV TZ=${TZ} \
    HOME=/tmp \
    RANDFILE=/tmp/.rnd

COPY --from=ghcr.io/mlocati/php-extension-installer:2.13.2 /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get install -y --no-install-recommends zip unzip && \
    rm -rf /var/lib/apt/lists/*

RUN { \
      echo "date.timezone=${TZ}"; \
      echo "memory_limit=-1"; \
      echo "xdebug.mode=coverage"; \
    } > /usr/local/etc/php/conf.d/docker-php-ext-custom.ini

RUN --mount=type=bind,source=dockerfiles/php86-install-extensions.sh,target=/tmp/php86-install-extensions.sh \
    sh /tmp/php86-install-extensions.sh

WORKDIR /var/www
