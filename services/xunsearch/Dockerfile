FROM debian:jessie

MAINTAINER inhere<cloud798@126.com>

# @form https://github.com/hightman/xunsearch/blob/master/Dockerfile
# docker run -d --name xunsearch -p 8383:8383 -p 8384:8384 -v /var/xunsearch/data:/usr/local/xunsearch/data xunsearch:latest
#

# Install required packages
RUN apt-get update -qq && apt-get install -qy --no-install-recommends wget make gcc g++ bzip2 zlib1g-dev

# Download & Install xunsearch-latest
RUN cd /root && wget -qO - http://www.xunsearch.com/download/xunsearch-full-latest.tar.bz2 | tar xj
RUN cd /root/xunsearch-full-latest && sh setup.sh --prefix=/usr/local/xunsearch

RUN echo '' >> /usr/local/xunsearch/bin/xs-ctl.sh \
    && echo 'tail -f /dev/null' >> /usr/local/xunsearch/bin/xs-ctl.sh

# Configure it
#VOLUME ["/usr/local/xunsearch/data"]
EXPOSE 8383
EXPOSE 8384

WORKDIR /usr/local/xunsearch

RUN echo "#!/bin/sh" > bin/xs-docker.sh \
    && echo "rm -f tmp/pid.*" >> bin/xs-docker.sh \
    && echo "echo -n > tmp/docker.log" >> bin/xs-docker.sh \
    && echo "bin/xs-indexd -l tmp/docker.log -k start" >> bin/xs-docker.sh \
    && echo "sleep 1" >> bin/xs-docker.sh \
    && echo "bin/xs-searchd -l tmp/docker.log -k start" >> bin/xs-docker.sh \
    && echo "sleep 1" >> bin/xs-docker.sh \
    && echo "tail -f tmp/docker.log" >> bin/xs-docker.sh

ENTRYPOINT ["sh"]
CMD ["bin/xs-docker.sh"]
