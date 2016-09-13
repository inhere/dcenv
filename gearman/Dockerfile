FROM ubuntu:14.04
# from thenotable/ubuntu-gearman

MAINTAINER inhere

RUN apt-get update && apt-get install -y \
    build-essential \
    binutils-doc \
    software-properties-common \
    libboost-all-dev \
    gperf \
    libevent-dev \
    uuid-dev \
    wget \
    libmysqlclient-dev \
    libmemcached-dev \
    libsqlite3-dev \
    libpq-dev \
    libdrizzle-dev

# Install Gearman Job Server
RUN wget https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz \
    tar xzf gearmand-1.1.12.tar.gz \
    cd gearmand-1.1.12 && ./configure && make && make install \
    mkdir /usr/local/var \
    mkdir /usr/local/var/log \
    touch /usr/local/var/log/gearmand.log

# WORKDIR /opt
VOLUME ["/data"]

# RUN
RUN usermod -u 1000 gearman

EXPOSE 4730

CMD "gearmand"