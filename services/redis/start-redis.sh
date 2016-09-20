#!/bin/bash
#
# Call: start.sh 7001 7002 7003 7004
#

CONF_DIR=/etc/redis

echo "Run script: $0"

for name in $@
do
    echo "Run redis-server by config file: ${CONF_DIR}/${name}.conf"
    redis-server ${CONF_DIR}/${name}.conf
done