FROM nginx

MAINTAINER inhere<cloud798@126.com>

ARG timezone

ENV TIMEZONE=$timezone

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Install basic tools
# apache2-utils 包含 ab 压力测试工具
RUN apt-get update && apt-get install -my curl wget lsof vim apache2-utils

##
## Basic config
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

# change some config
RUN sed -i '/^\s*#gzip\s*/s/#//g' /etc/nginx/nginx.conf \
    && sed -i '/^\s*#tcp_nopush\s*/s/#//g' /etc/nginx/nginx.conf \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY data/resources/vhosts/default.conf /etc/nginx/conf.d/default.conf

WORKDIR "/var/www"

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

# extend form parent image
# EXPOSE 80 443
# CMD ["nginx", "-g", "daemon off;"]
