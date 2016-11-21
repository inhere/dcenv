#!/bin/bash

set -xe

# If user don't provide any command
# Start the ELK server
# Run as user "elk"
if [[ "$1" == "" ]]; then
    echo "Starting elasticsearch 5.x"
    echo "Have to run Docker with privileged mode, i.e:"
    echo "docker run -it --privileged nguoianphu/docker-elk:5 /bin/bash"
    echo "So that you can change the Alpine OS system configuration"
	# java -Xms40g -version
	# export ES_JAVA_OPTS="-Xms2g -Xmx2g"
	# In ES 5.x, as soon as you configure a network setting like network.host, Elasticsearch assumes that you are moving to production and will upgrade the above warnings to exceptions.  
	# https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html
	# sysctl -w vm.max_map_count=262144
    # exec gosu elk elasticsearch -Edefault.network.host=0.0.0.0 &
    # exec gosu elk elasticsearch -Ees.network.host=0.0.0.0 &
    # exec gosu elk elasticsearch -d -p /opt/elasticsearch/elasticsearch.pid -Edefault.network.host=0.0.0.0 &
    exec gosu elk elasticsearch -p /opt/elasticsearch/elasticsearch.pid -Edefault.network.host=0.0.0.0 &
    # kill `cat /opt/elasticsearch/elasticsearch.pid`
    sleep 60
    echo "Starting logstash"
    exec gosu elk logstash -f /opt/logstash/config &
    # exec gosu elk logstash -f /opt/logstash/config &
    # kill `ps ux | grep logstash | grep java | grep agent | awk '{ print $2}'`
    echo "Starting kibana"

    cd ${KIBANA_HOME}
    exec gosu elk node ./src/cli
    
    # exec gosu elk tini -- ${KIBANA_HOME}/node/bin/node ${KIBANA_HOME}/src/cli    
    # exec gosu elk tini -- kibana
    # exec gosu elk ${KIBANA_HOME}/bin/kibana
else
    # Else allow the user to run arbitrarily commands like bash
    exec "$@"
fi
