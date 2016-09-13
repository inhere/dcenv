FROM debian:jessie

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/sources.list    /etc/apt/sources.list

# manual install
RUN apt-get update && apt-get install -y \
    gcc autoconf make libboost-program-options-dev libevent-dev uuid-dev

#RUN apt-get update && apt-get install -y gcc autoconf bison flex libtool make \
#    libboost-all-dev libcurl4-openssl-dev curl \
#    libevent-dev memcached uuid-dev libsqlite3-dev libmysqlclient-dev

COPY gearman/gearmand-1.1.12.tar.gz /tmp/gearmand.tar.gz
RUN cd /tmp && tar -zxvf gearmand.tar.gz && cd gearmand-1.1.12 && ./configure && make && make install

# install from repo
# RUN apt-get update && apt-get install -y gearman-job-server && rm -r /var/lib/apt/lists/*

# WORKDIR /opt
VOLUME ["/data"]

# RUN
RUN usermod -u 1000 gearman

CMD "gearmand"
