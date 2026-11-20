#!/bin/sh
set -eu

sources=$(mktemp -d)
trap 'rm -rf "$sources"' EXIT

extract_source() {
    mkdir -p "$2"
    curl -fsSL "https://codeload.github.com/$1" -o "$sources/source.tar.gz"
    tar -xzf "$sources/source.tar.gz" -C "$2" --strip-components=1
}

# Build the APCu snapshot directly because PECL rejects its development version.
extract_source krakjoe/apcu/tar.gz/ebbcd3d153df21eaee3395413de515a30b48ef05 "$sources/apcu"
docker-php-ext-install -j "$(nproc)" "$sources/apcu"

# Pin Redis after the PHP 8.6 fixes and before its PECL configure prompts changed.
# GitHub source archives omit its bundled liblzf submodule.
extract_source phpredis/phpredis/tar.gz/810984b5a5aedc37e3ff3c19e33af8dc08c8290f "$sources/redis"
extract_source nemequ/liblzf/tar.gz/fb25820c3c0aeafd127956ae6c115063b47e459a "$sources/redis/liblzf"

# Use upstream snapshots with the PHP 8.6 compatibility fixes.
install-php-extensions \
    igbinary/igbinary@2b1f5d62e3037b07c2a46499ac32091cdb41fb40 \
    "$sources/redis" \
    xdebug/xdebug@3.6.0alpha1 \
    gd xsl intl mbstring gmp gettext zip soap bcmath snappy pdo_mysql

# PHP 8.6 provides OPcache as a built-in Zend extension.
php -r '
    $required = explode(" ", "gd redis xsl apcu igbinary intl mbstring gmp gettext zip soap bcmath snappy pdo_mysql xdebug");
    $required[] = "Zend OPcache";
    $missing = array_filter($required, static fn ($extension) => !extension_loaded($extension));
    if ($missing) {
        fwrite(STDERR, "Missing PHP extensions: " . implode(", ", $missing) . PHP_EOL);
        exit(1);
    }
'
