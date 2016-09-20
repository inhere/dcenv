FROM ubuntu:16.04

MAINTAINER inhere<cloud798@126.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/ubuntu16.04.sources  /etc/apt/sources.list

# Install Gearman Job Server
RUN apt-get update && apt-get install -y gearman-job-server \
    && ldconfig \
    && mkdir -p /usr/local/var/log \
    && touch /usr/local/var/log/gearmand.log \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
    && gearmand -V && echo "   \n    Gearman Install Successful.\n"

VOLUME /data

EXPOSE 4730

# open persistent queue for product env.
# CMD gearmand -q libsqlite3 --libsqlite3-db /persistent-data.db3 -l /usr/local/var/log/gearmand.log

# if use for local test.
CMD gearmand -l /dev/stdout