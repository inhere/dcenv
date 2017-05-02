FROM php:latest
# php cli
# always use latest version php

MAINTAINER inhere<cloud798@126.com>

ARG timezone

ENV TIMEZONE=$timezone
ENV HIREDIS_VERSION=0.13.3

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/debian8.sources /etc/apt/sources.list

# Now,Install basic tool
# apache2-utils 包含 ab 压力测试工具
RUN apt-get update && apt-get -y install openssl libssl-dev pkg-config vim curl telnet git zip unzip wget lsof apache2-utils

##
# Install core extensions for php
##
RUN apt-get install -y \
    libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \

    # no dependency extension
    && docker-php-ext-install gettext mysqli opcache pdo_mysql sockets pcntl zip

##
# Install PECL extensions, have dependency
##
RUN apt-get install -y \

    # for memcache
    # zlib1g-dev \

    # for memcached
    libmemcached-dev \

    # for gearman
    # libgearman-dev \

    # && pecl install memcache && docker-php-ext-enable memcache \
    # && pecl install gearman && docker-php-ext-enable gearman \
    && pecl install memcached && docker-php-ext-enable memcached

##
# PECL extensions, no dependency
##
# mongodb 扩展
RUN pecl install mongodb && docker-php-ext-enable mongodb
# 日志扩展
RUN pecl install seaslog && docker-php-ext-enable seaslog
# 调试扩展
RUN pecl install xdebug && docker-php-ext-enable xdebug
# trace调试扩展
RUN pecl install trace-1.0.0 && docker-php-ext-enable trace
# redis缓存扩展
RUN pecl install redis && docker-php-ext-enable redis

RUN pecl install msgpack && docker-php-ext-enable msgpack
RUN pecl install yac && docker-php-ext-enable yac
RUN pecl install yaconf && docker-php-ext-enable yaconf

# 文件变动监控扩展
RUN pecl install inotify && docker-php-ext-enable inotify
# RUN pecl install xhprof && docker-php-ext-enable xhprof
# RUN pecl install channel://pecl.php.net/xhprof-0.9.4 && docker-php-ext-enable xhprof

##
# Swoole extension
# 异步事件扩展
##
RUN pecl install swoole && docker-php-ext-enable swoole

# hiredis - redis C client, provide async operate redis support
RUN cd /tmp \
    # && curl -o hiredis-${HIREDIS_VERSION}.tar.gz https://github.com/redis/hiredis/archive/v${HIREDIS_VERSION}.tar.gz \
    && wget -O 'hiredis-${HIREDIS_VERSION}.tar.gz' -c https://github.com/redis/hiredis/archive/v${HIREDIS_VERSION}.tar.gz \
    && tar -zxvf hiredis-0.13.3.tar.gz && cd hiredis-${HIREDIS_VERSION} && make -j && make install && ldconfig

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
# 1. change Timezone
# 2. open some command alias
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

##
## PHP Configuration
## Override configurtion
##
COPY data/resources/php/php-seaslog.ini /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini
COPY data/resources/php/php-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY data/resources/php/php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini
RUN echo "date.timezone=$TIMEZONE" >> /usr/local/etc/php/conf.d/99-overrides.ini \
  && echo "yaconf.directory=/tmp/yaconf" >> /usr/local/etc/php/conf.d/docker-php-ext-yaconf.ini

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
