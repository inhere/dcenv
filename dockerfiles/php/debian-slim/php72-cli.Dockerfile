########################################
#
# contents is from php:7.2-fpm
# refer image
# - https://github.com/docker-library/php/blob/master/7.2/buster/cli/Dockerfile
# - info: size=366M layer=6
########################################

# slim image size ~=50M
FROM debian:buster-slim

# If you'd like to be able to use this container on a docker-compose environment as a quiescent PHP CLI container
# you can /bin/bash into, override CMD with the following - bear in mind that this will make docker-compose stop
# slow on such a container, docker-compose kill might do if you're in a hurry
# CMD ["tail", "-f", "/dev/null"]
