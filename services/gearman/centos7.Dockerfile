FROM centos:centos7

MAINTAINER inhere<cloud798@126.com>

RUN yum install yum-plugin-fastestmirror && yum update \
    && yum install gearmand

RUN mkdir -p /var/log/gearmand && touch /var/log/gearmand/gearmand.log \
    && yum clean; rm -rf /var/lib/yum/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && gearmand -V && echo "   \n    Gearman Install Successful.\n"

VOLUME [ "/data", "/var/log/gearmand"]

# Open persistent queue for produce env.
# CMD gearmand -q libsqlite3 --libsqlite3-db /persistent-data.db3 -l /var/log/gearmand/gearmand.log

# If use for local test.
CMD gearmand -l /dev/stdout