FROM nginx

MAINTAINER inhere<cloud798@126.com>

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# change some config
RUN sed -i '/^\s*#gzip\s*/s/#//g' /etc/nginx/nginx.conf \
    && sed -i '/^\s*#tcp_nopush\s*/s/#//g' /etc/nginx/nginx.conf \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR "/var/www"

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

# extend form parent image
# EXPOSE 80 443
# CMD ["nginx", "-g", "daemon off;"]