FROM mongo

MAINTAINER inhere<cloud798@126.com>

ARG timezone
ENV TIMEZONE=$timezone

##
# Basic config
# 1. change Timezone
# 2. open some command alias
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc

# extends parent
# VOLUME /data/db /data/configdb
