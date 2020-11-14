FROM golang:alpine

MAINTAINER inhere<cloud798@126.com>

RUN { echo "http://mirrors.aliyun.com/alpine/latest-stable/main"; \
    echo "http://mirrors.aliyun.com/alpine/edge/testing/"; \
    echo "http://mirrors.aliyun.com/alpine/edge/community/"; } \
    | tee /etc/apk/repositories \
    && apk update && apk add git curl

RUN curl https://glide.sh/get | sh

VOLUME ["/go"]
