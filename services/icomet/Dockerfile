FROM debian:jessie

MAINTAINER inhere<cloud798@126.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources /etc/apt/sources.list

wget --no-check-certificate https://github.com/ideawu/icomet/archive/master.zip
unzip master.zip
cd icomet-master/
make