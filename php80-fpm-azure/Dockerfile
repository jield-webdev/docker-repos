FROM ghcr.io/jield-webdev/docker-repos/php8.0-fpm:latest

RUN apt-get install -y --force-yes --no-install-recommends openssh-server

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