FROM debian:jessie

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/debian8.sources.list    /etc/apt/sources.list

# manual install :
#   1 . install depends library
# RUN apt-get update && apt-get install -y \
#     make gcc \
#     g++ libboost-dev \
#     uuid-dev libpq-dev libcloog-ppl0 libcurl4-gnutls-dev

#    gcc autoconf bison flex libtool make \
#    libboost-all-dev libcurl4-openssl-dev curl \
#    libevent-dev memcached uuid-dev libsqlite3-dev libmysqlclient-dev

#   2 . do install gearman
# wget https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz
# COPY gearman/gearmand-1.1.12.tar.gz /tmp/gearmand.tar.gz
# COPY gearmand-1.1.12.tar.gz /tmp/gearmand.tar.gz
# RUN cd /tmp && tar -zxvf gearmand.tar.gz \
#     cd gearmand-1.1.12 \
#     ./configure \
#     ./configure --with-boost-libdir=/usr/lib/x86_64-linux-gnu \
#     make \
#     make install

# install from repo
# in the php container: `apt-get install -y php5-gearman` or use `pecl install gearman`
RUN apt-get update && apt-get install -y gearman-job-server && rm -r /var/lib/apt/lists/*

# RUN useradd -M gearman -s /sbin/nologin -r \
# mkdir /var/run/gearman /var/log/gearman-job-server \
# touch /var/log/gearman-job-server/gearman.log \
# chown gearman:gearman /var/run/gearman /var/log/gearman-job-server \
# vi /etc/init.d/gearman-job-server

VOLUME /data

# RUN
RUN usermod -u 1000 gearman

CMD "gearmand"
