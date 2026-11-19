ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm

ARG PHP_VERSION
ARG TZ="Europe/Amsterdam"

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP ${PHP_VERSION} Nginx production Docker container (for Azure)"

# Copy tools from builder images
COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install system packages and the latest stable NGINX from nginx.org
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gpg \
    supervisor \
    openssh-server \
    redis-server \
    zip && \
    install -d /etc/apt/keyrings && \
    curl -fsSL https://nginx.org/keys/nginx_signing.key -o /tmp/nginx_signing.key && \
    gpg --batch --dearmor -o /etc/apt/keyrings/nginx.gpg /tmp/nginx_signing.key && \
    rm /tmp/nginx_signing.key && \
    . /etc/os-release && \
    echo "deb [signed-by=/etc/apt/keyrings/nginx.gpg] https://nginx.org/packages/debian ${VERSION_CODENAME} nginx" \
      > /etc/apt/sources.list.d/nginx.list && \
    printf 'Package: nginx\nPin: origin nginx.org\nPin-Priority: 900\n' > /etc/apt/preferences.d/nginx && \
    apt-get -o APT::Update::Error-Mode=any update && \
    apt-get install -y --no-install-recommends nginx && \
    apt-get purge -y --auto-remove gpg && \
    rm -rf /var/lib/apt/lists/*

ENV HOME=/tmp \
    RANDFILE=/tmp/.rnd \
    TZ=${TZ}

RUN { \
      echo "date.timezone=${TZ}"; \
      echo "memory_limit=2G"; \
      echo "max_execution_time=300"; \
      echo "max_input_vars=10000"; \
      echo "upload_max_filesize=32M"; \
      echo "post_max_size=32M"; \
      echo "expose_php=off"; \
      echo "display_errors=off"; \
      echo "log_errors=on"; \
      echo "opcache.enable=1"; \
      echo "opcache.max_accelerated_files=20000"; \
      echo "opcache.validate_timestamps=0"; \
      echo "opcache.memory_consumption=256"; \
      echo "realpath_cache_ttl=600"; \
    } > /usr/local/etc/php/conf.d/docker-php-ext-custom.ini

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
RUN rm -f /etc/nginx/conf.d/default.conf && \
    sed -i \
      -e 's/^user .*;/user www-data;/' \
      -e 's/#gzip  on;/gzip on;/' \
      -e '/include \/etc\/nginx\/conf\.d\/\*\.conf;/a\    include /etc/nginx/sites-enabled/*;' \
      /etc/nginx/nginx.conf && \
    nginx -t && \
    chmod +x /init_container.sh /tmp/ssh_setup.sh && \
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
