FROM nginx:alpine

LABEL maintainer="Johan van der Heide <info@jield.nl>"
LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos"
LABEL org.opencontainers.image.description="Azure Nginx Docker container"

# Install SSH, setup root password, and cleanup in one RUN
RUN apk add --no-cache openssh && \
    echo "root:Docker!" | chpasswd && \
    mkdir -p /etc/ssh /docker-entrypoint.d /tmp

# Copy configuration and scripts
COPY .docker/ssh/sshd_config /etc/ssh/sshd_config
COPY .docker/scripts/init_container_nginx.sh /docker-entrypoint.d/40-init_container.sh
COPY .docker/scripts/ssh_setup.sh /tmp/ssh_setup.sh

# Set permissions and initialize SSH
RUN chmod +x /docker-entrypoint.d/40-init_container.sh /tmp/ssh_setup.sh && \
    /tmp/ssh_setup.sh 2>&1 > /dev/null && \
    rm -rf /tmp/*

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1

EXPOSE 80 2222
