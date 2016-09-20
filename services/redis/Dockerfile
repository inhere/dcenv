FROM redis

#
# master-slave
# default is: one master one slave
#

MAINTAINER inhere<cloud798@126.com>

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources  /etc/apt/sources.list

# simple add a slave redis instance
COPY services/redis/scripts/master-slave-by-cmd.sh /bin/redis-start.sh

# can also, use config for add a slave instance
# COPY services/redis/scripts/master-slave-by-conf.sh /bin/redis-start.sh

RUN chmod a+x /bin/redis-start.sh && mkdir /etc/redis /var/log/redis

# EXPOSE 6379 6380

VOLUME [ "/data", "/etc/redis" , "/var/log/redis" ]

CMD redis-start.sh