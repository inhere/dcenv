FROM debian:jessie

MAINTAINER inhere<cloud798@126.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources    /etc/apt/sources.list

# manual install :
#   1 . install depends library
RUN apt-get update && apt-get install -y \
    make gcc g++ libboost-all-dev \
    libmemcached-dev libsqlite3-dev libmysqlclient-dev \
    gperf libevent-dev uuid-dev

#   2 . do install gearman
# wget https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz -O /tmp/gearmand.tar.gz
COPY data/packages/gearmand-1.1.12.tar.gz /tmp/gearmand.tar.gz
RUN cd /tmp && tar -zxvf gearmand.tar.gz \
    && cd gearmand-1.1.12 \
    && ./configure \
    # && ./configure --with-boost-libdir=/usr/lib/x86_64-linux-gnu \
    && make \
    && make install

# install from repo
# in the php container: `apt-get install -y php5-gearman` or use `pecl install gearman`
# RUN apt-get update && apt-get install -y gearman-job-server

RUN ldconfig \
    && mkdir /usr/local/var \
    && mkdir /usr/local/var/log \
    && touch /usr/local/var/log/gearmand.log \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
    && gearmand -V && echo "   Gearman Installed."

VOLUME /data

CMD "gearmand --log-file=/usr/local/var/log/gearmand.log"
