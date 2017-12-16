FROM alpine:latest

MAINTAINER inhere<cloud798@126.com>

ARG timezone

# ENV TIMEZONE=$timezone
ENV TIMEZONE=Asia/Shanghai

RUN mv /etc/apk/repositories /etc/apk/repositories.bak
COPY data/resources/alpine.repositories /etc/apk/repositories

# Install base packages
RUN apk update && apk add curl tzdata \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" >  /etc/timezone \
    && alias ll='ls -al'

# Install gearman
# RUN apk add --no-cache gearmand@testing \
RUN apk add --no-cache gearmand \
    && mkdir -p /var/log/gearmand && touch /var/log/gearmand/gearmand.log \
    && gearmand -V && echo "\n\n    Gearman Install Successful.\n\n"

VOLUME [ "/data", "/var/log/gearmand"]

EXPOSE 4730

# open persistent queue for produce env.
# CMD gearmand -q libsqlite3 --libsqlite3-db /persistent-data.db3 -l /var/log/gearmand/gearmand.log

# if use for local test.
CMD gearmand -l /dev/stdout
