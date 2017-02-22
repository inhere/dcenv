FROM nginx

MAINTAINER inhere<cloud798@126.com>

################################################################################
# Build instructions
################################################################################

ENV PHP_VERSION=5.6.29
ENV TIME_ZONE=Asia/Shanghai

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/* \
    && mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources  /etc/apt/sources.list

# Install packages
# apache2-utils 包含 ab 压力测试工具
RUN apt-get update && apt-get install -my \
  supervisor openssl curl wget vim apache2-utils \

  # 安装tzdata安装包
  tzdata \

  # 如果需要手动编译扩展就需要它
  php5-dev \

  # 若需要使用 pecl 安装扩展，可启用它。 依赖 php5-dev
  php-pear \

  # common 包含了大部分公共的扩展
  php5-cli php5-fpm php5-common \

  # 数据库驱动 php5-mysqlnd 比 php5-mysql 更好
  php5-mysqlnd php5-sqlite php5-mongo \

  php5-mcrypt php5-gd php5-curl php5-ssh2 \

  php5-apcu php5-redis php5-memcache php5-memcached \

  php5-xdebug \

  # gearman job queue
  php5-gearman

RUN pecl install swoole && echo "extension=swoole.so" > /etc/php5/mods-available/swoole.ini && php5enmod swoole
RUN pecl install trace && echo "extension=trace.so" > /etc/php5/mods-available/trace.ini && php5enmod trace

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

#设置时区
RUN echo "${TIME_ZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

# Ensure that PHP5 FPM is run as root.
RUN sed -i "s/user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "s/group = www-data/group = root/" /etc/php5/fpm/pool.d/www.conf

# Pass all docker environment
RUN sed -i '/^;clear_env = no/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Get access to FPM-ping page /ping
RUN sed -i '/^;ping\.path/s/^;//' /etc/php5/fpm/pool.d/www.conf \
   # Get access to FPM_Status page /status
    && sed -i '/^;pm\.status_path/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Prevent PHP Warning: 'xdebug' already loaded.
# XDebug loaded with the core
RUN sed -i '/.*xdebug.so$/s/^/;/' /etc/php5/mods-available/xdebug.ini

COPY data/packages/php-tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

# Manual Install PECL extension memcache and Enable php-memcache
# RUN pecl install /tmp/php-ext/memcache-2.2.7.tgz \
#   && echo "extension=memcache.so" > /etc/php5/mods-available/memcache.ini && php5enmod memcache

# Install HHVM 去除hhvm的安装
# RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
# RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list
# RUN apt-get update && apt-get install -y hhvm

# Add configuration files
COPY services/nginx-php/conf/nginx.conf /etc/nginx/
COPY services/nginx-php/conf/supervisord.conf /etc/supervisor/conf.d/
COPY services/nginx-php/php-custom.ini /etc/php5/fpm/conf.d/40-custom.ini

# COPY data/resources/vhosts/default.conf /etc/nginx/conf.d/default.conf

# Close port listen, enable unix sock listen
# RUN sed -i '/^\s*# fastcgi_pass unix\s*/s/# //g' /etc/nginx/conf.d/default.conf \
#     && sed -i '/\s*fastcgi_pass webapp/s/\s*f/    # f/g' /etc/nginx/conf.d/default.conf

WORKDIR "/var/www"

VOLUME ["/var/www", "/etc/nginx/conf.d"]

EXPOSE 80 443 9000

ENTRYPOINT ["/usr/bin/supervisord"]
