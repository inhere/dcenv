FROM php:5.6-fpm

MAINTAINER inhere<cloud798@126.com>

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/debian8.sources    /etc/apt/sources.list

# Now,Install
RUN apt-get update && apt-get -y --no-install-recommends install \
    vim curl telnet \
    php-pear php5-phar php5-dev php5-common\

    php5-mysql php5-mcrypt php5-gd php-gettext \

    php5-apcu php5-redis php5-memcache php5-memcached php5-gearman\

    php5-xdebug php5-xhprof \

    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && echo 'PHP 5.6 installed.'

ADD data/packages/php-tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

WORKDIR "/var/www"

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www"]

# extends from parent
# EXPOSE 9000
# CMD ["php-fpm"]