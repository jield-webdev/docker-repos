FROM nginx:alpine

MAINTAINER 'Johan van der Heide <info@jield.nl>'

LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos/nginx"
LABEL org.opencontainers.image.description="Azure Nginx Docker container"

COPY .docker/scripts/init_container.sh /bin/init_container.sh

RUN chmod 755 /bin/init_container.sh \
    && mkdir -p /home/LogFiles/ \
    && mkdir -p /var/www/html/ \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home/site/wwwroot" >> /etc/bash.bashrc \
    && ln -s /home/site/wwwroot /var/www/html \
    && mkdir -p /opt/startup

# configure startup
COPY .docker/ssh/sshd_config /etc/ssh/sshd_config
COPY .docker/scripts/ssh_setup.sh /tmp/ssh_setup.sh
RUN mkdir -p /opt/startup \
   && chmod -R +x /opt/startup \
   && chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) \
   && rm -rf /tmp/*

ENV SSH_PORT 2222
EXPOSE 2222