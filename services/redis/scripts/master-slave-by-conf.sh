#!/bin/bash
#
# file: master-slave-by-conf.sh
# use config for add a slave instance
#

CONF_PATH=/etc/redis/
BASE_PATH=/data/
PORT_LIST=$*

if [ -z "$PORT_LIST" ]; then
    echo 'Please provide port list. like: redis-start.sh 6379 [6380 ...]'
fi

# NOTICE: must be create dir before start the redis-server

for PORT in $@; do
    [ ! -d $BASE_PATH$PORT ] && mkdir $BASE_PATH$PORT

    redis-server ${CONF_PATH}${PORT}.conf
done

if [[ $?==0 ]]; then
    echo "  Redis server [$PORT_LIST] start successful!"
    echo "New, will run: tail -f /var/log/redis/$1.log"
    tail -f /var/log/redis/$1.log
else
    echo "  Redis server [$PORT_LIST] start failure!"
fi