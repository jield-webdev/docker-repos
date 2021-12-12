FROM php:8.1-fpm

MAINTAINER 'Johan van der Heide <info@jield.nl>'

LABEL org.opencontainers.image.source="https://github.com/jield-webdev/docker-repos/php8.1-fpm"
LABEL org.opencontainers.image.description="PHP 8.1 FPM production Docker container"

# Set working directory
WORKDIR /var/www

RUN apt-get update && \
apt-get install -y --force-yes --no-install-recommends \
	libmemcached-dev  \
	libfreetype6-dev \
	libxml2-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	zlib1g-dev \
	libzip-dev \
	libz-dev \
	libpq-dev  \
	libsqlite3-dev  \
	libicu-dev \
	g++ \
	git \
	zip \
	libmcrypt-dev \
	libvpx-dev \
	libjpeg-dev \
	libpng-dev \
	bzip2 \
	wget \
	libexpat1-dev \
	libbz2-dev \
	libgmp3-dev \
	libldap2-dev \
	unixodbc-dev \
	libsnmp-dev \
	libpcre3-dev \
	libtidy-dev \
	libaspell-dev \
	tar \
	less \
	nano \
	libcurl4-gnutls-dev \
	apt-utils \
	libxrender1 \
	unzip \
	libonig-dev \
	libldap2-dev \
	libxslt-dev \
	libwebp-dev \
	libc-client-dev \
	libkrb5-dev \
	libpspell-dev \
	librabbitmq-dev \
	librabbitmq4 \
&& phpModules=" \
            bcmath \
            bz2 \
            calendar \
            exif \
            gd \
            gettext \
            gmp \
            intl \
            ldap \
            mysqli \
            opcache \
            pcntl \
            pdo_mysql \
            pdo_pgsql \
            pgsql \
            pspell \
            shmop \
            snmp \
            soap \
            sockets \
            sysvmsg \
            sysvsem \
            sysvshm \
            tidy \
            xsl \
            zip \
        " \
&& docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
&& docker-php-ext-install -j$(nproc) $phpModules \
&& pecl install redis-5.3.4 \
&& pecl install apcu-5.1.21 \
&& pecl install igbinary-3.2.6 \
&& docker-php-ext-enable redis apcu igbinary

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Create the necessary cache folders
RUN mkdir -p /home/www/.composer/cache
RUN chmod 777 /home/www/.composer/cache