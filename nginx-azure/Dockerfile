FROM nginx:alpine

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="Azure Nginx Docker container"

RUN apk add openssh \
     && echo "root:Docker!" | chpasswd

# Copy the sshd_config file to the /etc/ssh/ directory
COPY .docker/ssh/sshd_config /etc/ssh/sshd_config

COPY .docker/scripts/init_container_nginx.sh /docker-entrypoint.d/40-init_container.sh
RUN chmod +x /docker-entrypoint.d/40-init_container.sh

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY .docker/scripts/ssh_setup.sh /tmp
RUN chmod +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

# Open port 2222 for SSH access
EXPOSE 80 2222