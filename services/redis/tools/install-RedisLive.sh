#!/bin/bash
#
# file: install-RedisLive.sh
# install redis monitor tool: RedisLive
#

apt-get update && apt-get install -y python python-setuptools zip unzip

# download pip8
wget -c https://pypi.python.org/packages/e7/a8/7556133689add8d1a54c0b14aeff0acb03c64707ce100ecd53934da1aa13/pip-8.1.2.tar.gz#md5=87083c0b9867963b29f7aba3613e8f4a -O /usr/src/pip-8.1.2.tar.gz \

# download RedisLive
wget -c https://github.com/nkrode/RedisLive/archive/master.zip -O /usr/src/redisLive-master.zip \

# do install pip
cd /usr/src && tar zxvf pip-8.1.2.tar.gz && cd pip-8.1.2 && python setup.py install \

# install RedisLive dependeny
pip install tornado redis python-dateutil \

# do install RedisLive
cd /usr/src && tar unzip redisLive-master.zip -C redisLive && cd redisLive

echo '  Now, please cp redis-live.conf.example to redis-live.conf and config it.'
echo 'Then, you can run [redis-monitor.py] to monitor redis.'
echo 'Last, you can run [redis-python.py] to start service, please open url [locahost:8888].'