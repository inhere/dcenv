FROM redis

MAINTAINER inhere<cloud798@126.com>

# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources    /etc/apt/sources.list

RUN apt-get install ruby rubygem \
    gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    gem sources -l && gem install redis \
    # create redis config directory. e.g: /etc/redis/6379.conf /etc/redis/6380.conf
    mkdir /var/redis

VOLUME [ "/data", "/var/redis" ]

# add a slave redis
CMD "redis-server /etc/redis/6379.conf && redis-server --port 6380 --slaveof 127.0.0.1 6379"
# CMD "redis-server /etc/redis/6379.conf && redis-server /etc/redis/6380.conf"
