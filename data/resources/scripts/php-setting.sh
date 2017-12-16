#!/bin/bash
#
# the some setting for php
#

echo "date.timezone=$TIMEZONE" >> /usr/local/etc/php/conf.d/99-overrides.ini

# Open php-fpm pid file
sed -i '/^;pid\s*=\s*/s/\;//g' /usr/local/etc/php-fpm.conf && chmod +x /etc/init.d/php-fpm

# Get access to FPM-ping page /ping
sed -i '/^;ping\.path/s/^;//' /usr/local/etc/fpm/pool.d/www.conf

# Get access to FPM_Status page /status
sed -i '/^;pm\.status_path/s/^;//' /usr/local/etc/fpm/pool.d/www.conf
