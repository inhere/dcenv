# Docker ELK 5.x

From: https://github.com/nguoianphu/docker-elk

ELK (Elasticsearch Logstash Kibana) 5.x Docker image. Alpine OS 3.x.

[![Build Status](https://travis-ci.org/nguoianphu/docker-elk.svg?branch=master)](https://travis-ci.org/nguoianphu/docker-elk) [![Image size](https://images.microbadger.com/badges/image/nguoianphu/docker-elk.svg)](https://microbadger.com/images/nguoianphu/docker-elk "Get your own image badge on microbadger.com")

- Elasticsearch 5.0.1
- Logstash 5.0.1
- Kibana 5.0.1
- OS is Alpine 3.4 64bit


## Docker host virtual memory
[https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html)

### On Linux (the host to run Docker engine, not the Docker container)
You can increase the limits by running the following command as ```root```:

    sysctl -w vm.max_map_count=262144

To set this value permanently, update the ```vm.max_map_count=262144``` setting in ```/etc/sysctl.conf```. To verify after ```rebooting```, run:

    sysctl vm.max_map_count

### On Windows and Docker Toolbox (boot2docker)
    
    # the default machine
    docker-machine ssh default
    sudo sysctl -w vm.max_map_count=262144
    # it will be re-set after you re-boot your Windows host
    
    # To make the setting persistent
    sudo vi /var/lib/boot2docker/bootlocal.sh
    # Add this line into the profile file
    sysctl -w vm.max_map_count=262144
    
    # Then re-start the Docker VM to check
    sudo chmod +x /var/lib/boot2docker/bootlocal.sh
    exit
    docker-machine restart
    docker-machine ssh default "sysctl vm.max_map_count" 

    
## Build and run
   
    docker build -t "elk" .
    docker run -d -p 9200:9200 -p 5601:5601 -p 5044:5044 --name my-elk elk
    
### or just run
    
    docker run -d -p 9200:9200 -p 5601:5601 -p 5044:5044 --name my-elk nguoianphu/docker-elk

ports

    # 9200 Elasticsearch HTTP JSON interface
    # 9300 Elasticsearch TCP transport port
    # 5044 Logstash Beats interface, receives logs from Beats such as Filebeat, Packetbeat
    # 5601 Kibana web interface

---
    
# Docker ELK 2.x

Please checkout ```2``` branch at  [![Build Status](https://travis-ci.org/nguoianphu/docker-elk.svg?branch=2)](https://github.com/nguoianphu/docker-elk/tree/2)
