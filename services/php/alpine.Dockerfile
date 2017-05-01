FROM php:alpine

MAINTAINER inhere<cloud798@126.com>

ARG timezone

ENV TIMEZONE=$timezone

RUN mv /etc/apk/repositories /etc/apk/repositories.bak
COPY data/resources/alpine.repositories /etc/apk/repositories

# Install base packages
RUN apk update && apk add curl tzdata \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" >  /etc/timezone \
    && alias ll='ls -al'

# 调试扩展
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install gearman
RUN apk add --no-cache php7

WORKDIR "/var/www"

################################################################################
# Volumes
################################################################################

VOLUME /var/www /var/log/php7
