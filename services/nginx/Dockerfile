FROM nginx

MAINTAINER inhere<cloud798@126.com>

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

COPY services/nginx-php/conf/nginx.conf /etc/nginx/

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

# extend form parent image
# EXPOSE 80 443
# CMD ["nginx", "-g", "daemon off;"]