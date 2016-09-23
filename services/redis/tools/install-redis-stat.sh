#!/bin/bash
#
# file: install-redis-stat.sh
# install redis monitor tool: redis-stat
#
#

apt-update && apt-get install ruby rubygems
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem install redis-stat
echo '  redis-stat install successful!'
redis-stat --help