FROM ghcr.io/jield-webdev/docker-repos/php8.1-cli:latest

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos/php8.1-cli"
LABEL org.opencontainers.image.description="PHP 8.1 CLI/Cronjob Docker container"

# Install OpenSSH and set the password for root to "Docker!"
RUN apt-get update && apt-get install -y --no-install-recommends openssh-server cron supervisor screen

COPY .docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY .docker/scripts/init_container_supervisor.sh /init_container.sh

# Add the cronjobs
COPY ./.docker/crontab/crontab /etc/crontab

# Give execution rights on the cron job
RUN chmod +x /etc/crontab

#remove the existing crontabs
RUN rm -rf /etc/cron.*/*

#Add some default cronjobs
# Create a job
ADD ./.docker/crontab/cronjob_1min.sh /cronjob_1min.sh
ADD ./.docker/crontab/cronjob_1min.sh /cronjob_1hour.sh
ADD ./.docker/crontab/cronjob_15min.sh /cronjob_15min.sh
ADD ./.docker/crontab/cronjob_24hour.sh /cronjob_24hour.sh
ADD ./.docker/crontab/cronjob_24hour.sh /cronjob_weekly.sh
RUN chmod +x /cronjob_1min.sh
RUN chmod +x /cronjob_1hour.sh
RUN chmod +x /cronjob_15min.sh
RUN chmod +x /cronjob_24hour.sh
RUN chmod +x /cronjob_weekly.sh

RUN chmod +x /init_container.sh \
    && mkdir -p /home/LogFiles/ \
    && echo "root:Docker!" | chpasswd \
    && mkdir -p /opt/startup

# configure startup
COPY .docker/ssh/sshd_config /etc/ssh/sshd_config
COPY .docker/scripts/ssh_setup.sh /tmp/ssh_setup.sh
RUN mkdir -p /opt/startup \
   && chmod -R +x /opt/startup \
   && chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) \
   && rm -rf /tmp/*

EXPOSE 2222

#Start supervisor
RUN /init_container.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]