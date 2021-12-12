FROM nginx:alpine

MAINTAINER 'Johan van der Heide <info@jield.nl>'

LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos/nginx"
LABEL org.opencontainers.image.description="Azure Nginx Docker container"

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apk add openssh \
     && echo "root:Docker!" | chpasswd

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
    && /tmp/init_container.sh \

