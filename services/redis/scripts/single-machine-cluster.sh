#!/bin/bash
#
# file: single-machine-sluster.sh
#
# single machine redis cluster
#

# simple add slave redis instance by command
# redis-server --port 7001 --daemonize yes
# redis-server --port 7002 --daemonize yes --slaveof 127.0.0.1 7001
# redis-server --port 7003 --daemonize yes
# redis-server --port 7004 --daemonize yes --slaveof 127.0.0.1 7003
# redis-server --port 7005 --daemonize yes
# redis-server --port 7006 --daemonize yes --slaveof 127.0.0.1 7005

# by config file

redis-server /etc/redis/cluster/7001.conf
redis-server /etc/redis/cluster/7002.conf
redis-server /etc/redis/cluster/7003.conf
redis-server /etc/redis/cluster/7004.conf
redis-server /etc/redis/cluster/7005.conf
redis-server /etc/redis/cluster/7006.conf