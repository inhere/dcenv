################################################################################
# Base image
################################################################################

FROM nginx

################################################################################
# Build instructions
################################################################################

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# 更换(debain 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD conf/sources.list    /etc/apt/sources.list

# Install packages
RUN apt-get update && apt-get install -my \
  supervisor \
#  openssl \
  curl \
  wget \

  php5-dev \
  php5-cli \
  php5-fpm \
  # common 包含了大部分公共的包
  php5-common \
  php-pear \

  php5-mysql \
  php5-sqlite \

  php5-mcrypt \
  php5-gd \
  php5-curl \
  php5-ssh2 \

  php5-apcu \
  php5-redis \
  php5-memcached \

  php5-xdebug \

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

ADD tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

# Install HHVM 去除hhvm的安装
# RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
# RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list
# RUN apt-get update && apt-get install -y hhvm

# Add configuration files
COPY conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord"]
