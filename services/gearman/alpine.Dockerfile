FROM alpine:3.4

RUN { echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/"; cat /etc/apk/repositories; } \
    | tee /etc/apk/repositories && \
    echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk update && apk add --no-cache gearmand@testing \
    && mkdir -p /var/log/gearmand && touch /var/log/gearmand/gearmand.log \
    && gearmand -V && echo "   \n    Gearman Install Successful.\n"

VOLUME [ "/data", "/var/log/gearmand"]

EXPOSE 4730

# open persistent queue for produce env.
# CMD gearmand -q libsqlite3 --libsqlite3-db /persistent-data.db3 -l /usr/local/var/log/gearmand.log

# if use for local test.
CMD gearmand -l /dev/stdout
