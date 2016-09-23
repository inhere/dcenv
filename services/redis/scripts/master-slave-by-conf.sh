#!/bin/bash
#
# file: master-slave-by-conf.sh
# use config for add a slave instance
#

redis-server /etc/redis/6379.conf --loglevel verbose
redis-server /etc/redis/6380.conf --loglevel verbose