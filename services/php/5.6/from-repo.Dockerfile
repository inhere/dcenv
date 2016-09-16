################################################################################
# Base image
################################################################################

FROM nginx

################################################################################
# Build instructions
################################################################################

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/debian8.sources    /etc/apt/sources.list

# Install packages
RUN apt-get update && apt-get install -my \
  openssl curl wget \

  # 如果需要手动编译扩展就需要它
  php5-dev \

  # 若需要使用 pecl 安装扩展，可启用它。 依赖 php5-dev
  php-pear \

  # common 包含了大部分公共的扩展
  php5-cli php5-fpm php5-common \

  php5-mysql php5-sqlite php5-mcrypt php5-gd php5-curl php5-ssh2 \

  php5-apcu php5-redis php5-memcache php5-memcached \

  php5-xdebug php5-gearman php5-xhprof \

  && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Ensure that PHP5 FPM is run as root.
RUN sed -i "s/user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php5/fpm/pool.d/www.conf

# Pass all docker environment
RUN sed -i '/^;clear_env = no/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Get access to FPM-ping page /ping
RUN sed -i '/^;ping\.path/s/^;//' /etc/php5/fpm/pool.d/www.conf
# Get access to FPM_Status page /status
RUN sed -i '/^;pm\.status_path/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Prevent PHP Warning: 'xdebug' already loaded.
# XDebug loaded with the core
RUN sed -i '/.*xdebug.so$/s/^/;/' /etc/php5/mods-available/xdebug.ini

ADD data/packages/php-tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

# RUN pecl install /home/memcache.tgz \
#   echo "extension=memcache.so" > /etc/php5/mods-available/memcache.ini \
# Enable php modules
#   php5enmod memcache

WORKDIR /var/www

VOLUME ["/var/www"]

EXPOSE 9000

# ENTRYPOINT ["/usr/bin/supervisord"]
ENTRYPOINT ["php5-fpm"]
