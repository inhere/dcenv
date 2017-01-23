FROM php:latest
# php cli
# always use latest version php

MAINTAINER inhere<cloud798@126.com>

ENV TIME_ZONE=Asia/Shanghai

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/debian8.sources /etc/apt/sources.list

# Now,Install basic tool
RUN apt-get update && apt-get -y install openssl vim curl telnet git zip unzip

##
# Install core extensions for php
##
RUN apt-get install -y \
    libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \

    # no dependency extension
    && docker-php-ext-install gettext mysqli opcache pdo_mysql sockets

##
# Install PECL extensions, have dependency
##
# RUN apt-get install -y \

    # for memcache
    # zlib1g-dev \

    # for memcached 此php扩展不支持 php7
    # libmemcached-dev \

    # for gearman 此php扩展不支持 php7
    # libgearman-dev \

    # && pecl install memcache && docker-php-ext-enable memcache \
    # && pecl install memcached && docker-php-ext-enable memcached \
    # && pecl install gearman && docker-php-ext-enable gearman \

##
# PECL extensions, no dependency
##
RUN pecl install seaslog && docker-php-ext-enable seaslog
RUN pecl install swoole && docker-php-ext-enable swoole
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN pecl install redis && docker-php-ext-enable redis
# RUN pecl install xhprof && docker-php-ext-enable xhprof
# RUN pecl install channel://pecl.php.net/xhprof-0.9.4 && docker-php-ext-enable xhprof

# Other extensions
# RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
#     && mkdir -p xcache \
#     && tar -xf xcache.tar.gz -C xcache --strip-components=1 \
#     && rm xcache.tar.gz \
#     && ( \
#         cd xcache \
#         && phpize && ./configure --enable-xcache \
#         && make -j$(nproc) && make install \
#     ) \
#     && rm -r xcache \
#     && docker-php-ext-enable xcache

##
## Basic config
##
RUN echo "${TIME_ZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

##
## PHP Configuration
## Override configurtion
##
COPY data/resources/php/php-seaslog.ini /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini
COPY data/resources/php/php-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY data/resources/php/php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini
RUN echo "date.timezone=$TIME_ZONE" >> /usr/local/etc/php/conf.d/99-overrides.ini

# clear temp files
RUN docker-php-source delete \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && echo -e "\033[42;37m PHP(cli) letest installed.\033[0m"

# install composer
ADD data/packages/php-tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

WORKDIR "/var/www"

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/var/log/php"]

# extends from parent
# EXPOSE 9000

# keep alive
CMD tail -f /var/log/apt/history.log
