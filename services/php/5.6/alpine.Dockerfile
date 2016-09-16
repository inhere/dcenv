FROM php:5.6-fpm-alpine

MAINTAINER inhere<cloud798@126.com>

# RUN apk update && apk add --no-cache \
#     php-pear

VOLUME ["/var/www"]