# FROM php:7.0-fpm-alpine

FROM alpine

MAINTAINER inhere<cloud798@126.com>

RUN { echo "http://mirrors.aliyun.com/alpine/latest-stable/main"; \
    echo "http://mirrors.aliyun.com/alpine/edge/testing/"; \
    echo "http://mirrors.aliyun.com/alpine/edge/community/"; } \
    | tee /etc/apk/repositories  \
    && echo "nameserver 8.8.8.8" >> /etc/resolv.conf \
    && apk update && apk upgrade \
    && apk add php7 && apk add php7-opcache
    && ln -fs /usr/bin/php7 /usr/bin/php

# install php-fpm and more extensions
RUN apk add vim wget curl bash openssl \
    php7 php7-fpm php7-cgi php7-common \

    php7-openssl php7-pear php7-gmp php7-pcntl \

    php7-mysqlnd php7-mysqli php7-sqlite3 php7-tidy php7-pgsql \
    php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-pdo_sqlite php7-mongodb \

    php7-opcache php7-memcached php7-session php7-redis \

    php7-timezonedb \
    php7-exif \
    php7-posix \
    php7-snmp \

    php7-gd \
    php7-gmagick \
    php7-gettext \

    php7-json \
    php7-iconv \
    php7-mbstring \
    php7-xsl \
    php7-xml \
    php7-xmlreader \

    php7-curl \
    php7-ssh2 \
    php7-ftp \
    php7-soap \
    php7-sockets \

    php7-shmop \
    php7-imap \

    php7-bz2 \
    php7-phar \
    php7-zip \

    php7-ctype \
    php7-mcrypt \
    php7-bcmath \
    php7-calendar \

    php7-dom \
    php7-zlib \
    php7-sysvmsg \
    php7-sysvshm \
    php7-sysvsem \
    && ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm

RUN mkdir /var/www && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /var/www

VOLUME ["/var/www"]

CMD ["php-fpm"]

