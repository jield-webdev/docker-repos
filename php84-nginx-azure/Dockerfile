FROM php:8.4-fpm

ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.4 Nginx production Docker container (for Azure)"

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
    zip && \
    # Configure PHP \
    echo "date.timezone=${TZ}" >> /usr/local/etc/php/conf.d/docker-php-timezone.ini && \
    echo 'memory_limit = 2G' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini && \
    echo 'max_input_vars = 10000' >> /usr/local/etc/php/conf.d/docker-php-maxinputvars.ini && \
    echo 'upload_max_filesize = 32M' >> /usr/local/etc/php/conf.d/docker-php-limits.ini && \
    echo 'post_max_size = 32M' >> /usr/local/etc/php/conf.d/docker-php-limits.ini && \
    echo 'max_execution_time = 300' >> /usr/local/etc/php/conf.d/docker-php-max-execution.ini && \
    echo 'expose_php=off' >> /usr/local/etc/php/conf.d/docker-php-expose.ini && \
    echo 'display_errors=off' >> /usr/local/etc/php/conf.d/docker-php-errors.ini && \
    echo 'log_errors=on' >> /usr/local/etc/php/conf.d/docker-php-errors.ini && \
    echo 'error_reporting = E_ALL & ~E_DEPRECATED' >> /usr/local/etc/php/conf.d/docker-php-error_reporting.ini

# Optimize OPCache in a single RUN
RUN echo 'opcache.enable=1' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'opcache.max_accelerated_files = 20000' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'opcache.validate_timestamps=0' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'opcache.memory_consumption=256' >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo 'realpath_cache_ttl=600' >> /usr/local/etc/php/conf.d/docker-php-realpatch-cache.ini

# Install PHP extensions
RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath snappy pdo_mysql && \
    # Create directories \
    mkdir -p /tmp /home/LogFiles /opt/startup /var/log && \
    # Setup SSH with password (Azure requirement)
    echo "root:Docker!" | chpasswd && \
    # Create non-root user
    useradd -m -u 1000 www-app && \
    mkdir -p /var/www && \
    chown -R www-app:www-app /var/www && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Set working directory
WORKDIR /var/www

# Copy configuration files
COPY .docker/nginx/nginx.conf /etc/nginx/sites-enabled/default
COPY .docker/supervisor/supervisord.nginx.conf /etc/supervisor/conf.d/supervisord.conf
COPY .docker/scripts/init_container_php84.sh /init_container.sh
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
