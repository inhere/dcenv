FROM redis

#
# single machine master-slave
# default is: one master one slave
#

MAINTAINER inhere<cloud798@126.com>

ARG timezone
ENV TIMEZONE=$timezone

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources  /etc/apt/sources.list

RUN apt-get update && apt-get install -y vim

##
# Basic config
# 1. change Timezone
# 2. open some command alias
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

# fix the redis warning
RUN sed -i '$i echo 511 > /proc/sys/net/core/somaxconn' /etc/rc.local \
    && sed -i '$i echo never > /sys/kernel/mm/transparent_hugepage/enabled' /etc/rc.local \
    && echo "# add by inhere \nvm.overcommit_memory = 1" >> /etc/sysctl.conf

# EXPOSE 6379 6380 26379

VOLUME /data /etc/redis /var/log/redis
