# PHP Dockerized

>Forked form [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized.git)

---------------

> Dockerized PHP development stack: Nginx, MySQL, MongoDB, PHP-FPM, HHVM, Memcached, Redis, Elasticsearch and RabbitMQ

[![Build Status](https://travis-ci.org/kasperisager/php-dockerized.svg)](https://travis-ci.org/kasperisager/php-dockerized)

PHP Dockerized gives you everything you need for developing PHP applications locally. The idea came from the need of having an OS-agnostic and virtualized alternative to the great [MNPP](https://github.com/jyr/MNPP) stack as regular LAMP stacks quite simply can't keep up with the Nginx + PHP-FPM/HHVM combo in terms of performance. I hope you'll find it as useful an addition to your dev-arsenal as I've found it!

## What's inside

* [Nginx](http://nginx.org/)
* [MySQL](http://www.mysql.com/)
* [MongoDB](http://www.mongodb.org/)
* [PHP-FPM](http://php-fpm.org/) -- 5.6
* ~~[HHVM](http://www.hhvm.com/)~~
* [Memcached](http://memcached.org/)
* [Redis](http://redis.io/)
* [Elasticsearch](http://www.elasticsearch.org/)
* ~~[RabbitMQ](https://www.rabbitmq.com/)~~

## Requirements

* [Docker Engine](https://docs.docker.com/installation/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Machine](https://docs.docker.com/machine/) (Mac and Windows only)

## Running

Set up a Docker Machine and then run:

```sh
$ docker-compose up
```

That's it! You can now access your configured sites via the IP address of the Docker Machine or locally if you're running a Linux flavour and using Docker natively.

我的:

```sh
$ docker-machine start default # 可省略 default
$ docker-compose up
# 若配置文件不是默认的名称`docker-compose.yml`,可使用`-f {filename}`参数。`-d` 后台运行
# docker-compose -f docker-compose-my.yml up -d
$ docker-machine env [default] # 查看default虚拟机信息 得到虚拟机的ip 192.168.99.100
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/inhere/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env)

# 现在可通过 浏览器访问 192.168.99.100

## 其他命名使用

$ eval $(docker-machine env default) # 连上机器，不然无法执行下面的命令
$ docker ps // 查看正在运行的容器列表

# 在 web 容器中运行 curl --HEAD localhost:80 检查php 是否运行成功
# phpdockerized_web_1 是正在运行的web容器(通过 Dockerfile 构建的镜像)
$ docker exec -ti phpdockerized_web_1 curl --HEAD localhost:80 
```


## License

Copyright &copy; 2014-2016 [Kasper Kronborg Isager](http://github.com/kasperisager). Licensed under the terms of the [MIT license](LICENSE.md).
