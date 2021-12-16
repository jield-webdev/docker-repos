FROM nginx:alpine

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos/nginx"
LABEL org.opencontainers.image.description="Azure Nginx Docker container"

# Install OpenSSH and set the password for root to "Docker!"
RUN apk add --no-cache openssh

#Copy the init-container in the general docker entrypoints so the final command picks it up
COPY .docker/scripts/init_container_nginx.sh /docker-entrypoint.d/40-init_container.sh

RUN chmod 755 /docker-entrypoint.d/40-init_container.sh \
    && mkdir -p /home/LogFiles/ \
    && mkdir -p /var/www/html/ \
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

EXPOSE 80 2222