FROM redis

#
# single machine master-slave
# default is: one master one slave
#

MAINTAINER inhere<cloud798@126.com>

ARG timezone
ARG master_port
ARG slaves_port

ENV TIMEZONE=$timezone
ENV MASTER_PORT=$master_port
ENV SLAVES_PORT=$slaves_port
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

RUN apt-get update && apt-get install -y vim

# create directory
RUN mkdir -p /etc/redis/conf.default /var/log/redis /var/tools

# copy config,tools,script
COPY services/redis/conf/* /etc/redis/conf.default/
COPY services/redis/tools/* /var/tools/
COPY services/redis/scripts/master-slave-by-conf.sh /var/tools/redis-start.sh

##
# Basic config
# 1. change Timezone
# 2. open some command alias
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

RUN chmod a+x /var/tools/* \
    # && echo never > /sys/kernel/mm/transparent_hugepage/enabled \
    && echo "# add by inhere \nvm.overcommit_memory = 1" >> /etc/sysctl.conf

# EXPOSE 6379 6380 26379

VOLUME [ "/data", "/etc/redis" , "/var/log/redis" ]

# ENTRYPOINT redis-start.sh
# CMD redis-server --port 7000
CMD redis-start.sh
