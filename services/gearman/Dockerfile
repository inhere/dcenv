FROM debian:jessie

MAINTAINER inhere<cloud798@126.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources /etc/apt/sources.list

# manual install :
#   1 . install depends library
RUN apt-get update && apt-get install -y \
    make gcc g++ libboost-all-dev \
    gperf libevent-dev uuid-dev \
    libmemcached-dev libsqlite3-dev libmysqlclient-dev libpq-dev \
    && ldconfig

#   2 . do install gearman
# wget https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz -O /tmp/gearmand.tar.gz
COPY data/packages/gearmand-1.1.12.tar.gz /tmp/gearmand.tar.gz
RUN cd /tmp && tar -zxvf gearmand.tar.gz \
    && cd gearmand-1.1.12 \
    && ./configure \
    # && ./configure --with-boost-libdir=/usr/lib/x86_64-linux-gnu \
    && make \
    && make install

RUN mkdir -p /var/log/gearmand && touch /var/log/gearmand/gearmand.log \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && gearmand -V && echo "   \n    Gearman Install Successful.\n"

VOLUME [ "/data", "/var/log/gearmand"]

# Open persistent queue for produce env.
# CMD gearmand -q libsqlite3 --libsqlite3-db /persistent-data.db3 -l /var/log/gearmand/gearmand.log

# If use for local test.
CMD gearmand -l /dev/stdout
