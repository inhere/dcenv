FROM php:5.6-fpm

MAINTAINER inhere<cloud798@126.com>

# Now,Install
RUN apt-get update && apt-get -y --no-install-recommends install \
    openssl vim curl telnet \
    php-pear php5-phar php5-dev \

    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \

    && echo 'PHP 5.6 installed.'

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www"]

################################################################################
# Ports
################################################################################

EXPOSE 9000

CMD ["php-fpm"]