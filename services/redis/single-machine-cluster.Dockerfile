FROM redis

MAINTAINER inhere<cloud798@126.com>

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources /etc/apt/sources.list

RUN apt-get update && apt-get install ruby rubygem \
    gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    gem sources -l && gem install redis \
    # create redis config directory. e.g: /etc/redis/6379.conf /etc/redis/6380.conf
    mkdir /etc/redis

VOLUME [ "/data", "/etc/redis" ]

# simple add a slave redis instance
CMD redis-server --port 6379 && redis-server --port 6380 --slaveof 127.0.0.1 6379 \
    redis-server --port 6381 && redis-server --port 6382 --slaveof 127.0.0.1 6381 \
    redis-server --port 6383 && redis-server --port 6384 --slaveof 127.0.0.1 6383 \

# use config for add a slave instance
# CMD redis-server /etc/redis/6379.conf && redis-server /etc/redis/6380.conf
