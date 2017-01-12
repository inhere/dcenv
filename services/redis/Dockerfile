FROM redis

#
# master-slave
# default is: one master one slave
#

MAINTAINER inhere<cloud798@126.com>

ENV PATH /var/tools:$PATH
# ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.2.6.tar.gz

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources  /etc/apt/sources.list

# download a redis package from network
# RUN wget -c ${REDIS_DOWNLOAD_URL} \
#     -O /usr/src/redis-${REDIS_VERSION}.tar.gz

# add a redis package from local
# COPY data/packages/redis-3.2.3.tar.gz /usr/src/redis-3.2.3.tar.gz

# create directory
RUN mkdir /etc/redis /var/log/redis /var/tools

# copy tools
COPY services/redis/tools/* /var/tools/

# simple add a slave redis instance
# COPY services/redis/scripts/master-slave-by-cmd.sh /var/tools/redis-start.sh

# can also, use config for add a slave instance
COPY services/redis/scripts/master-slave-by-conf.sh /var/tools/redis-start.sh

RUN chmod a+x /var/tools/* \
    # && echo never > /sys/kernel/mm/transparent_hugepage/enabled \
    && echo "# add by inhere \nvm.overcommit_memory = 1" >> /etc/sysctl.conf

# EXPOSE 6379 6380 26379

VOLUME [ "/data", "/etc/redis" , "/var/log/redis" ]

# ENTRYPOINT redis-start.sh
# CMD redis-server --port 7000
CMD redis-start.sh 6379 6380
