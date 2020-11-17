########################################
#  inhere PHP 7.3 FPM image
#
# @homepage https://github.com/inhere/dockerenv
#
# refer image
# - https://github.com/docker-library/php/blob/master/7.3/buster/fpm/Dockerfile
# - info: size=366M layer=6
#
# @link https://hub.docker.com/_/debian/
# @link https://hub.docker.com/_/php/
# @build
#   docker build -f dockerfiles/php/debian-slim/php73-fpm.Dockerfile -t inhere/dcenv:php73fpm .
########################################

# debian slim image size ~=50M
# buster default is: php7.3
FROM debian:buster-slim

LABEL maintainer="inhere <in.798@qq.com>" version="1.0"

ENV PHP_INI_DIR /usr/local/etc/php

RUN set -eux; \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list; \
    sed -i 's/security.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils \
        php-apcu \
        php-redis \
# php7.3-common Provides:(by apt-cache show php7.3-common)
# php7.3-calendar, php7.3-ctype, php7.3-exif, php7.3-fileinfo, php7.3-ftp, php7.3-gettext, php7.3-iconv, php7.3-pdo,
# php7.3-phar, php7.3-posix, php7.3-shmop, php7.3-sockets, php7.3-sysvmsg, php7.3-sysvsem, php7.3-sysvshm, php7.3-tokenizer
# Depends: php-common (>= 1:35), ucf, libc6 (>= 2.15), libssl1.1 (>= 1.1.0)
        php7.3-common \
        php7.3-fpm \
        php7.3-bcmath \
        php7.3-mysql \
        php7.3-sqlite3 \
        php7.3-curl \
        php7.3-dom \
        php7.3-gd \
        php7.3-mbstring \
        php7.3-xml \
        php7.3-xmlrpc \
        php7.3-zip \
        php7.3-opcache; \
# clear works
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /tmp/* /var/tmp/* /usr/share/doc/*; \
    rm -rf /var/lib/apt/lists/*; \
# config
    mkdir -p "$PHP_INI_DIR/conf.d"; \
# allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
    [ ! -d /var/www/html ]; \
    mkdir -p /var/www/html; \
    chown www-data:www-data /var/www/html; \
    chmod 777 /var/www/html; \
# smoke test
    php --version

WORKDIR /var/www/html

# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
STOPSIGNAL SIGQUIT

EXPOSE 9000
CMD ["php-fpm"]
