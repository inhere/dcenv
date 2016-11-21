FROM golang:alpine

MAINTAINER inhere<cloud798@126.com>

RUN { echo "http://mirrors.aliyun.com/alpine/latest-stable/main"; \
    echo "http://mirrors.aliyun.com/alpine/edge/testing/"; \
    echo "http://mirrors.aliyun.com/alpine/edge/community/"; } \
    | tee /etc/apk/repositories \
    && apk update && apk add git \
    && git clone https://github.com/Masterminds/glide $GOPATH/src/github.com/Masterminds/glide \
    && cd $GOPATH/src/github.com/Masterminds/glide && go install glide

VOLUME ["/go"]
