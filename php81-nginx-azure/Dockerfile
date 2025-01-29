FROM php:8.1-fpm

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.1 Nginx production Docker container (for Azure)"

ENV TZ="Europe/Amsterdam"

RUN echo 'date.timezone=Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-timezone.ini;
RUN echo 'memory_limit = 2G' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;
RUN echo 'max_input_vars = 10000' >> /usr/local/etc/php/conf.d/docker-php-maxinputvars.ini;
RUN echo 'upload_max_filesize = 32M' >> /usr/local/etc/php/conf.d/docker-php-limits.ini;
RUN echo 'post_max_size = 32M' >> /usr/local/etc/php/conf.d/docker-php-limits.ini;
RUN echo 'max_execution_time = 300' >> /usr/local/etc/php/conf.d/docker-php-max-execution.ini;
RUN echo 'opcache.max_accelerated_files = 20000' >> /usr/local/etc/php/conf.d/docker-php-opcache.ini;
RUN echo 'opcache.validate_timestamps=0' >> /usr/local/etc/php/conf.d/docker-php-opcache.ini;
RUN echo 'realpath_cache_ttl=600' >> /usr/local/etc/php/conf.d/docker-php-realpatch-cache.ini;

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

#RUN install-php-extensions gd redis xsl apcu igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql
RUN install-php-extensions gd redis xsl igbinary intl gmp gettext zip opcache soap bcmath pdo_mysql

RUN apt-get update && \
apt-get install -y --no-install-recommends \
    supervisor \
    openssh-server \
    redis-server \
    nginx-full \
    zip

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp

#Copy the nginx conf
COPY .docker/nginx/nginx.conf /etc/nginx/sites-enabled/default
COPY .docker/supervisor/supervisord.nginx.conf /etc/supervisor/conf.d/supervisord.conf
COPY .docker/scripts/init_container_php82.sh /init_container.sh

RUN chmod +x /init_container.sh \
    && mkdir -p /home/LogFiles/ \
    && echo "root:Docker!" | chpasswd \
    && mkdir -p /opt/startup

# configure startup
COPY .docker/ssh/sshd_config /etc/ssh/sshd_config
COPY .docker/scripts/ssh_setup.sh /tmp/ssh_setup.sh
RUN mkdir -p /opt/startup \
   && chmod -R +x /opt/startup \
   && chmod -R +x /init_container.sh \
   && chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) \
   && rm -rf /tmp/*

# Open port 2222 for SSH access
EXPOSE 80 2222

#Start supervisor
RUN /init_container.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]