FROM php:5.6-fpm

MAINTAINER inhere<cloud798@126.com>

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources    /etc/apt/sources.list

# extensions

# Install Core extension
#
# bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv
# imap interbase intl json ldap mbstring mcrypt mssql mysql mysqli oci8 odbc opcache pcntl
# pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix
# pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard
# sybase_ct sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip
#
# Must install dependencies for your extensions manually, if need.
RUN apt-get update && apt-get install -y \
    libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \

    # no dependency extension
    && docker-php-ext-install gettext mysqli opcache pdo_mysql sockets

# Install PECL extensions
RUN apt-get install -y \

    # for memcache
    zlib1g-dev \

    # for memcached
    libmemcached-dev \

    # for gearman
    libgearman-dev \

    && pecl install memcache && docker-php-ext-enable memcache \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install gearman && docker-php-ext-enable gearman \

    # no dependency
    && pecl install seaslog && docker-php-ext-enable seaslog \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install redis-2.2.8 && docker-php-ext-enable redis \
    && pecl install swoole && docker-php-ext-enable swoole \
    && pecl install trace && docker-php-ext-enable trace \
    # && pecl install xhprof && docker-php-ext-enable xhprof
    && pecl install channel://pecl.php.net/xhprof-0.9.4 && docker-php-ext-enable xhprof

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

# open pid file
RUN sed -i '/^;pid\s*=\s*/s/\;//g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/^# alias/alias/g' ~/.bashrc

# Override configurtion
COPY data/resources/php/php-seaslog.ini /usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini
COPY data/resources/php/php-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY data/resources/php/php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini

# add php-fpm to service
COPY data/resources/php/init.d.php-fpm /etc/init.d/php-fpm
RUN chmod +x /etc/init.d/php-fpm
    # && chkconfig --add php-fpm

# clear temp files
RUN docker-php-source delete \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && echo 'PHP 5.6 installed.'

COPY data/packages/php-tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

WORKDIR "/var/www"

VOLUME ["/var/www"]

# extends from parent
# EXPOSE 9000
# CMD ["php-fpm"]
