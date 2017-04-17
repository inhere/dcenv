#!/bin/bash
#
# file: master-slave-by-cmd.sh
# simple add a slave redis instance
#

redis-server --port 6379 --daemonize yes && \
redis-server --port 6380 --daemonize yes --slaveof 127.0.0.1 6379 && \
redis-server --port 6381 --daemonize yes --slaveof 127.0.0.1 6379
tail -f /var/log/redis/${MASTER_PORT}.log
