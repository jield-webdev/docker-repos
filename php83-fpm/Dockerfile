FROM php:8.3-fpm

ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.3 FPM production Docker container"

ENV TZ="${TZ}"

# Copy tools from builder images
COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure PHP and install extensions in a single RUN to reduce layers
RUN echo "date.timezone=${TZ}" >> /usr/local/etc/php/conf.d/docker-php-timezone.ini && \
    install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql && \
    # Production PHP configuration
    echo 'expose_php=off' >> /usr/local/etc/php/conf.d/docker-php-expose.ini && \
    echo 'display_errors=off' >> /usr/local/etc/php/conf.d/docker-php-errors.ini && \
    echo 'log_errors=on' >> /usr/local/etc/php/conf.d/docker-php-errors.ini && \
    echo 'error_log=/var/log/php-errors.log' >> /usr/local/etc/php/conf.d/docker-php-errors.ini

# Optimize OPCache for production
RUN echo 'opcache.enable=1' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'opcache.validate_timestamps=0' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'opcache.max_accelerated_files=20000' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'opcache.memory_consumption=256' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Create non-root user for security
RUN useradd -m -u 1000 www-app && \
    mkdir -p /var/www && \
    chown -R www-app:www-app /var/www

# Set working directory
WORKDIR /var/www

# Create error log location
RUN mkdir -p /var/log && chmod 755 /var/log

# Configure FPM to run as non-root
RUN sed -i 's/user = www-data/user = www-app/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/group = www-data/group = www-app/' /usr/local/etc/php-fpm.d/www.conf

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD php -r 'exit((int)!extension_loaded("fpm"));' || exit 1

USER www-app

EXPOSE 9000

CMD ["php-fpm"]
