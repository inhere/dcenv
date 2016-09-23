#!/bin/bash
#
# file: master-slave-by-conf.sh
# use config for add a slave instance
#

# NOTICE: must be create dir before start the redis-server
mkdir /data/6379 /data/6380

redis-server /etc/redis/6379.conf --loglevel verbose
redis-server /etc/redis/6380.conf --loglevel verbose