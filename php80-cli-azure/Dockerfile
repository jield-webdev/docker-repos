FROM ghcr.io/jield-webdev/docker-repos/php8.0-cli:latest

LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos/php8.0-cli"
LABEL org.opencontainers.image.description="PHP 8.0 CLI production Docker container for Azure"

# Install OpenSSH and set the password for root to "Docker!"
RUN apt-get install -y --force-yes --no-install-recommends openssh-server

RUN echo "root:Docker!" | chpasswd

# Copy the sshd_config file to the /etc/ssh/ directory
COPY .docker/ssh/sshd_config /etc/ssh/

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ./.docker/ssh/ssh_setup.sh /tmp
RUN chmod +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

#Start the container
COPY ./.docker/scripts/init_container.sh /tmp
RUN chmod +x /tmp/init_container.sh \
    && /tmp/init_container.sh

# Open port 2222 for SSH access
EXPOSE 2222