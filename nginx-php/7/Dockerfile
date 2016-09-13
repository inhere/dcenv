FROM php:latest
# FROM phpdockerio/php7-fpm:latest

MAINTAINER inhere

# Now,Install
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
     openssl nano curl \
     php7.0-cli php7.0-fpm php7.0-apcu php7.0-apcu-bc php7.0-curl php7.0-json \
     php7.0-mcrypt php7.0-opcache php7.0-readline php7.0-xml php7.0-zip \

     php7.0-mysql \
     php7.0-mysqli \
     php7.0-sqlite3 \
     php7.0-pdo_sqlite \
     php7.0-pdo_pgsql \
     php7.0-pdo_mysql \

     php7.0-memcached \
     php7.0-redis \
     php7.0-session \

     php7.0-bz2 \
     php7.0-dom \
     php7.0-gd \
     php7.0-gmp \
     php7.0-interbase \
     php7.0-intl \
     php7.0-ldap \
     php7.0-mbstring \
     php7.0-mcrypt \
     php7.0-msgpack \
     php7.0-snmp \
     php7.0-soap \
     php7.0-zlib \

     php7.0-openssl \
     php7.0-ssh2 \
     php7.0-ftp \
     php7.0-sockets \

     php7.0-pear \
     php7.0-phar \

     php7.0-dbg \
     php7.0-phpdbg \
     php7.0-xdebug \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

    && echo 'PHP 7 installed.'

# copy configuration files. there is relative the 'docker-compose.yml > build:.' path
COPY php-fpm/php-ini-overrides.ini /etc/php/7.0/fpm/conf.d/99-overrides.ini

WORKDIR "/var/www/workenv"