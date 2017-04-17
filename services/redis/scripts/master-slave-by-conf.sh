#!/bin/bash
#
# file: master-slave-by-conf.sh
# use config for add a slave instance
#

CONF_PATH=/etc/redis/
DATA_PATH=/data/

if [ -z "$SLAVES_PORT" ]; then
    echo 'Please provide slaves port list by $SLAVES_PORT. like: redis-start.sh 6380 [6381 ...]'
fi

# NOTICE: must be create dir before start the redis-server

# --daemonize no
echo "Now, will start redis master server. RUN: redis-server /etc/redis/${MASTER_PORT}.conf"
[ ! -d $DATA_PATH$MASTER_PORT ] && mkdir $DATA_PATH$MASTER_PORT
redis-server ${CONF_PATH}${MASTER_PORT}.conf

echo "Now, will start redis slaves server. slaves: $SLAVES_PORT"
# PORTS=$(echo $SLAVES_PORT|tr " " "\n")

for PORT in $SLAVES_PORT; do
    [ ! -d $DATA_PATH$PORT ] && mkdir $DATA_PATH$PORT

    echo "RUN: redis-server ${CONF_PATH}${PORT}.conf --slaveof 127.0.0.1 ${MASTER_PORT}"
    redis-server ${CONF_PATH}${PORT}.conf --slaveof 127.0.0.1 ${MASTER_PORT}
done

# start sentinel
# echo "Now, will start redis sentinel server. RUN: redis-server ${CONF_PATH}sentinel.conf  --sentinel"
# redis-server ${CONF_PATH}sentinel.conf  --sentinel

if [[ $?==0 ]]; then
    echo "Redis server start successful! master: ${MASTER_PORT} slaves: [$SLAVES_PORT]"
    echo "Now, will watch master log, by RUN: tail -f /var/log/redis/${MASTER_PORT}.log"
    tail -f /var/log/redis/${MASTER_PORT}.log
else
    echo "Redis server start failure!"
fi

