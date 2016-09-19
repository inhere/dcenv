FROM alpine:3.4

RUN { echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/"; cat /etc/apk/repositories; } \
    | tee /etc/apk/repositories && \
    echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache gearmand@testing

EXPOSE 4730

CMD gearmand -l /dev/stdout
# CMD gearmand --log-file=/usr/local/var/log/gearmand.log
