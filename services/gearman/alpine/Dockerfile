FROM alpine:3.4

RUN \
    echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache gearmand@testing

EXPOSE 4730

CMD ["gearmand"]