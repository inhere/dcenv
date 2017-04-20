FROM redis

MAINTAINER inhere<cloud798@126.com>

ARG timezone
# add build arg in compose.yml "cluster_ports": "7001 7002 7003 7004 7005 7006"
ARG cluster_ports

ENV TIMEZONE=$timezone
ENV CLUSTER_PORTS=$cluster_ports
ENV PATH /var/tools:$PATH

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources /etc/apt/sources.list

# Instal redis cluster toool
RUN apt-get update && apt-get install ruby rubygem \
    && gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    && gem sources -l && gem install redis
    && mkdir /etc/redis /var/log/redis /var/tools

# copy tools
COPY services/redis/tools /var/tools
COPY services/redis/scripts/single-machine-sluster.sh /var/tools/redis-start.sh

# NOTICE: must be create dir before start the redis-server
mkdir /data/7001 /data/7002 /data/7003 /data/7004 /data/7005 /data/7006

##
# Basic config
# 1. change Timezone
# 2. open some command alias
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

# fix the redis warning
RUN chmod a+x /var/tools/* \
    && sed -i '$i echo 511 > /proc/sys/net/core/somaxconn' /etc/rc.local \
    && sed -i '$i echo never > /sys/kernel/mm/transparent_hugepage/enabled' /etc/rc.local \
    && echo "# add by inhere \nvm.overcommit_memory = 1" >> /etc/sysctl.conf

VOLUME [ "/data", "/etc/redis" , "/var/log/redis" ]

ENTRYPOINT redis-start.sh
