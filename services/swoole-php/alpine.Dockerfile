FROM alpine

# reference ( http://github.com/wanjochan/ )

MAINTAINER inhere<cloud798@126.com>

RUN { echo "http://mirrors.aliyun.com/alpine/alpine/latest-stable/main"; \
    | echo "http://mirrors.aliyun.com/alpine/alpine/edge/testing/"; \
    | echo "http://mirrors.aliyun.com/alpine/alpine/edge/community/"; } \
    | tee /etc/apk/repositories \
    && echo "nameserver 8.8.8.8" >> /etc/resolv.conf \
    && apk update && apk upgrade \
    && apk add php7 && apk add php7-opcache
    && ln -fs /usr/bin/php7 /usr/bin/php \
    && apk add vim wget curl bash

COPY services/swoole-php/alpine_install_swoole.sh /tmp/
RUN sh /tmp/alpine_install_swoole.sh

RUN mkdir /var/www && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /var/www



