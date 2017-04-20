FROM redis

MAINTAINER inhere<cloud798@126.com>

ARG timezone
ARG master_port
ARG slave_port

ENV TIMEZONE=$timezone
ENV MASTER_PORT=$master_port
ENV SLAVE_PORT=$slave_port
ENV PATH /var/tools:$PATH

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources /etc/apt/sources.list

# Instal redis cluster toool
RUN apt-get update && apt-get install ruby rubygem \
    && gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    && gem sources -l && gem install redis \
    && mkdir /etc/redis /var/log/redis /var/tools

# copy tools
COPY services/redis/tools /var/tools
COPY services/redis/scripts/master-slave-by-conf.sh /var/tools/redis-start.sh

# NOTICE: must be create dir before start the redis-server
RUN mkdir /data/6379 /data/6380

# fix the redis warning
RUN chmod a+x /var/tools/* \
    && sed -i '$i echo 511 > /proc/sys/net/core/somaxconn' /etc/rc.local \
    && sed -i '$i echo never > /sys/kernel/mm/transparent_hugepage/enabled' /etc/rc.local \
    && echo "# add by inhere \nvm.overcommit_memory = 1" >> /etc/sysctl.conf

# EXPOSE 6379

VOLUME [ "/data", "/etc/redis" , "/var/log/redis" ]

ENTRYPOINT redis-start.sh
