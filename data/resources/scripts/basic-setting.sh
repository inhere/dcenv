#!/bin/bash
#
# the basic setting for system
#

##
# Basic config
# 1. change Timezone
# 2. open some command alias
##
RUN echo "${TIMEZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && sed -i 's/^# alias/alias/g' ~/.bashrc
