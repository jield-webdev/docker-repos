FROM ghcr.io/jield-webdev/docker-repos/php8.3-cli

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="PHP 8.3 CLI production Docker container for cronjobs"

## Install cron, redis and supervisor
RUN apt-get update && apt-get install -y cron redis-server supervisor nano

# Copy crontab file to the cron.d directory
COPY .docker/crontab/crontab.sample /etc/cron.d/cronjobs

# Copy entrypoint file to the etc
COPY .docker/scripts/entrypoint_cron.sh /etc/entrypoint.sh
COPY .docker/supervisor/supervisord.cron.conf /etc/supervisor/supervisord.conf

# Give correct rights to the cron job
RUN chmod 0644 /etc/cron.d/cronjobs

# Give execution rights to the entrypoint
RUN chmod +x /etc/entrypoint.sh

# Run the command on container startup
ENTRYPOINT [ "/etc/entrypoint.sh" ]