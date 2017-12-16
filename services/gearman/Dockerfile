FROM debian:jessie

MAINTAINER inhere<cloud798@126.com>

ARG timezone

ENV TIMEZONE=$timezone

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources /etc/apt/sources.list

#
# manual install begin
#

#   install basic tools
RUN apt-get update && apt-get install -y wget make gcc g++

#   install depends library
RUN apt-get install -y libboost-all-dev libboost-mpi-dev libboost-mpi-python-dev gperf libevent-dev uuid-dev

#   install extra library
RUN apt-get install -y libmemcached-dev libsqlite3-dev libmysqlclient-dev libpq-dev \
    && ldconfig

#   do install gearman

# RUN wget https://github.com/gearman/gearmand/releases/download/1.1.15/gearmand-1.1.15.tar.gz -O /tmp/gearmand.tar.gz

COPY services/gearman/resource/gearmand-1.1.15.tar.gz /tmp/gearmand.tar.gz

RUN cd /tmp && tar -zxvf gearmand.tar.gz \
    && cd gearmand-1.1.12 \
    && ./configure \
    # && ./configure --with-boost-libdir=/usr/lib/x86_64-linux-gnu \
    && make \
    && make install

##
# Basic config
# 1. change Timezone
# 2. open some command alias
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

RUN mkdir -p /var/log/gearmand && touch /var/log/gearmand/gearmand.log \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && gearmand -V && echo "   \n    Gearman Install Successful.\n"

VOLUME /data /var/log/gearmand

# Open persistent queue for produce env.
# CMD gearmand -q libsqlite3 --libsqlite3-db /persistent-data.db3 -l /var/log/gearmand/gearmand.log

# If use for local test.
CMD gearmand -l /dev/stdout
