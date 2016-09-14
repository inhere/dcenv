FROM ubuntu:16.04
# from thenotable/ubuntu-gearman

MAINTAINER inhere<cloud798@126.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/ubuntu16.04.sources  /etc/apt/sources.list

# Install Gearman Job Server
RUN apt-get update && apt-get install -y gearman-job-server \
    && mkdir /usr/local/var \
    && mkdir /usr/local/var/log \
    && touch /usr/local/var/log/gearmand.log

VOLUME /data

# RUN
# RUN usermod -u 1000 gearman

EXPOSE 4730

CMD "gearmand"
# CMD gearmand -q libsqlite3 --libsqlite3-db /var/lib/gearman/data.sqlite3 -l /dev/stdout