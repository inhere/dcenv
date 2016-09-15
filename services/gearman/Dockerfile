FROM ubuntu:14.04
# from thenotable/ubuntu-gearman

MAINTAINER inhere<cloud798@126.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/ubuntu14.04.sources  /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    build-essential binutils-doc libboost-all-dev \
    software-properties-common \
    gperf libevent-dev uuid-dev wget \
    libmysqlclient-dev libmemcached-dev libsqlite3-dev \
    libpq-dev libdrizzle-dev \
     && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install Gearman Job Server
RUN cd /tmp \
    && wget https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz \
    && tar xzf gearmand-1.1.12.tar.gz \
    && cd gearmand-1.1.12 && ./configure && make && make install \
    && mkdir /usr/local/var \
    && mkdir /usr/local/var/log \
    && touch /usr/local/var/log/gearmand.log \
    && echo "   Gearman Installed."

VOLUME /data

# RUN
#RUN usermod -u 1000 gearman

EXPOSE 4730

# CMD "gearmand"
CMD gearmand -vvv
# CMD gearmand -q libsqlite3 --libsqlite3-db /var/lib/gearman/data.sqlite3 -l /dev/stdout