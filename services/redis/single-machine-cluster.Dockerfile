FROM redis

MAINTAINER inhere<cloud798@126.com>

ENV PATH /var/tools:$PATH

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources /etc/apt/sources.list

# Instal redis cluster toool
RUN apt-get update && apt-get install ruby rubygem \
    && gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    && gem sources -l && gem install redis
    && mkdir /etc/redis /var/log/redis /var/tools

COPY services/redis/scripts/single-machine-sluster.sh /var/tools/redis-start.sh
RUN chmod a+x /var/tools/*

VOLUME [ "/data", "/etc/redis" , "/var/log/redis" ]

CMD redis-start.sh