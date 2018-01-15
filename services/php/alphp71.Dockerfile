#           some information
# ------------------------------------------------------------------------------------
# @link https://hub.docker.com/_/alpine/      alpine image
# @link https://hub.docker.com/_/php/         php image
# @link https://github.com/docker-library/php php dockerfiles
# ------------------------------------------------------------------------------------
# @description php 7.1 image base on the alpine 3.7
# @build-example build . -f alphp71.Dockerfile -t alphp:71 --build-arg app_env=dev
#

FROM alpine:3.7
LABEL maintainer="inhere <cloud798@126.com>" version="1.0"

##
# ---------- env settings ----------
##

# --build-arg timezone=Asia/Shanghai
ARG timezone
ARG fpm_user=www
    # pdt pre test dev
ARG app_env=pdt

ENV APP_ENV=${app_env:-"pdt"} \
    TIMEZONE=${timezone:-"Asia/Shanghai"}

ENV HIREDIS_VERSION=0.13.3 \
    PHALCON_VERSION=3.3.1 \
    SWOOLE_VERSION=2.0.12 \
    MONGO_VERSION=1.3.4

#  install and remove building packages
ENV PHPIZE_DEPS autoconf dpkg-dev dpkg file g++ gcc libc-dev make php7-dev php7-pear pkgconf re2c pcre-dev zlib-dev

##
# ---------- running ----------
##

# change apk source repo
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories

# Install base packages
# install php7 and some extensions
RUN apk update \
        && apk add --no-cache --virtual .persistent-deps \
        ca-certificates \
        curl \
        tar \
        xz \
        libressl \
        # openssh  \
        openssl  \
        tzdata \
        pcre \

        php7 \
        # php7-common \
        php7-fpm \
        php7-bcmath \
        php7-curl \
        php7-ctype \
        php7-dom \
        php7-fileinfo \
        # php7-filter \
        # php7-gettext \
        php7-iconv \
        php7-json \
        php7-mbstring \
        php7-mysqlnd \
        php7-openssl \
        php7-opcache \
        php7-pcntl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        # php7-phar \
        php7-posix \
        php7-redis \
        php7-simplexml \
        # php7-sqlite \
        php7-session \
        php7-sysvshm \
        php7-sysvmsg \
        php7-sysvsem \
        php7-zip \
        php7-zlib \
        && apk del --purge *-dev \
        && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7

WORKDIR "/tmp"

# 下载太慢，所以推荐先下载好
RUN curl -SL "https://github.com/redis/hiredis/archive/v${HIREDIS_VERSION}.tar.gz" -o hiredis.tar.gz \
# COPY services/php/deps/hiredis-${HIREDIS_VERSION}.tar.gz hiredis.tar.gz
    && curl -SL "https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
# COPY services/php/deps/swoole-${SWOOLE_VERSION}.tar.gz swoole.tar.gz
#   && curl -SL "https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz" -o cphalcon.tar.gz \
# COPY services/php/deps/cphalcon-${PHALCON_VERSION}.tar.gz cphalcon.tar.gz
    && curl -SL "http://pecl.php.net/get/mongodb-${MONGO_VERSION}.tgz" -o mongodb.tgz
# COPY services/php/deps/mongodb-${MONGO_VERSION}.tgz mongodb.tgz

# install php extensions
RUN set -ex \
        && apk add --no-cache --virtual .phpize-deps \
        $PHPIZE_DEPS \
        # for mongodb ext
        openssl-dev \
        # for swoole ext
        libaio linux-headers libaio-dev \

        # php extension: mongodb
        && pecl install ./mongodb.tgz \
        && echo "extension=mongodb.so" > /etc/php7/conf.d/20_mongodb.ini  \

        # php extension: phalcon framework
        # && tar -xf cphalcon.tar.gz \
        # && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
        # && cd cphalcon-${PHALCON_VERSION}/build \
        # # in alpine no bash shell, so change to 'sh install'
        # # && ./install \
        # && sh install \
        # && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
        # && cd ../../ \
        # && rm -r cphalcon-${PHALCON_VERSION} \

        # hiredis - redis C client, provide async operate support for Swoole
        # && wget -O hiredis.tar.gz -c https://github.com/redis/hiredis/archive/v${HIREDIS_VERSION}.tar.gz \
        && cd /tmp \
        && tar -zxvf hiredis.tar.gz \
        && cd hiredis-${HIREDIS_VERSION} \
        && make -j && make install \

        # php extension: swoole
        && cd /tmp \
        && mkdir -p swoole \
        && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
        && rm swoole.tar.gz \
        && ( \
            cd swoole \
            && phpize \
            && ./configure --enable-async-redis --enable-mysqlnd --enable-coroutine \
            && make -j$(nproc) && make install \
        ) \
        && rm -r swoole \
        && echo "extension=swoole.so" > /etc/php7/conf.d/20_swoole.ini \
        && apk del .phpize-deps \
        && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

##
# ---------- config PHP ----------
##
RUN set -ex \
        && cd /etc/php7 \
        && { \
            echo "upload_max_filesize=100M"; \
            echo "post_max_size=108M"; \
            echo "memory_limit=1024M"; \
            echo "date.timezone=${TIMEZONE}"; \
        } | tee conf.d/99-overrides.ini \

        # ---------- config PHP-FPM ----------
        && { \
            echo "[global]"; \
            echo "pid = /var/run/php-fpm.pid"; \
            echo "[www]"; \
            echo "user = www"; \
            echo "group = www"; \
        } | tee php-fpm.d/custom.conf

##
# ---------- some config,clear work ----------
##
RUN set -x \
        # config timezone
        && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
        && echo "${TIMEZONE}" > /etc/timezone \

        # create logs dir
        && mkdir -p /data/logs \

        # ensure www user exists
        && addgroup -S ${fpm_user} \
        && adduser -D -S -G ${fpm_user} ${fpm_user} \

        # remove build deps,tmp files for runtime
        && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
        && apk del --purge *-dev \
        && echo -e "\033[42;37m Build Completed :).\033[0m\n"

EXPOSE 9501 9000
VOLUME ["/var/www", "/data/logs"]
WORKDIR "/var/www"
