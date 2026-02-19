ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm

ARG PHP_VERSION
ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP ${PHP_VERSION} Nginx production Docker container (for Azure)"

ENV TZ="${TZ}"

# Copy tools from builder images
COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Consolidate all RUN commands for PHP configuration and system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    supervisor \
    openssh-server \
    redis-server \
    nginx-full \
    zip

ENV HOME=/tmp \
    RANDFILE=/tmp/.rnd \
    PHP_DATE_TIMEZONE="${TZ}" \
    PHP_MEMORY_LIMIT=2G \
    PHP_MAX_EXECUTION_TIME=300 \
    PHP_MAX_INPUT_VARS=10000 \
    PHP_UPLOAD_MAX_FILESIZE=32M \
    PHP_POST_MAX_SIZE=32M \
    PHP_EXPOSE_PHP=off \
    PHP_DISPLAY_ERRORS=off \
    PHP_LOG_ERRORS=on \
    PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=20000 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=256 \
    REALPATH_CACHE_TTL=600

# Install PHP extensions
RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql && \
    # Create directories \
    mkdir -p /tmp /home/LogFiles /opt/startup /var/log && \
    # Setup SSH with password (Azure requirement) \
    echo "root:Docker!" | chpasswd && \
    # Create non-root user \
    useradd -m -u 1000 www-app && \
    mkdir -p /var/www && \
    chown -R www-app:www-app /var/www && \
    # Cleanup \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Set working directory
WORKDIR /var/www

# Copy configuration files
COPY .docker/nginx/nginx.conf /etc/nginx/sites-enabled/default
COPY .docker/supervisor/supervisord.nginx.conf /etc/supervisor/conf.d/supervisord.conf
COPY .docker/scripts/init_container_nginx.sh /init_container.sh
COPY .docker/ssh/sshd_config /etc/ssh/sshd_config
COPY .docker/scripts/ssh_setup.sh /tmp/ssh_setup.sh

# Set permissions and initialize
RUN chmod +x /init_container.sh /tmp/ssh_setup.sh && \
    chmod -R +x /opt/startup && \
    /tmp/ssh_setup.sh 2>&1 > /dev/null && \
    sed -i 's/user = www-data/user = www-app/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/group = www-data/group = www-app/' /usr/local/etc/php-fpm.d/www.conf && \
    rm -rf /tmp/*

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

EXPOSE 80 2222

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
