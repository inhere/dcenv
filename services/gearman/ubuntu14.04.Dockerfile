FROM ubuntu:14.04

MAINTAINER inhere<cloud798@126.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/ubuntu14.04.sources  /etc/apt/sources.list

# Install Gearman Dependency Library
RUN apt-get update && apt-get install -y \
    build-essential binutils-doc libboost-all-dev \
    software-properties-common \
    gperf libevent-dev uuid-dev wget \
    libmysqlclient-dev libmemcached-dev libsqlite3-dev libdrizzle-dev libpq-dev \
    && ldconfig

# Install Gearman Job Server
COPY data/packages/gearmand-1.1.12.tar.gz /tmp/gearmand.tar.gz
RUN cd /tmp && tar xzf gearmand-1.1.12.tar.gz \
    && cd gearmand-1.1.12 \
    && ./configure && make && make install \
    && mkdir -p /var/log/gearmand && touch /var/log/gearmand/gearmand.log \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && gearmand -V && echo "   \n    Gearman Install Successful.\n"

VOLUME [ "/data", "/var/log/gearmand" ]

EXPOSE 4730

# open persistent queue for produce env.
# CMD gearmand -q libsqlite3 --libsqlite3-db /persistent-data.db3 -l /var/log/gearmand/gearmand.log

# if use for local test.
CMD gearmand -l /dev/stdout