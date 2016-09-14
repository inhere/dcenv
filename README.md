# PHP Dockerized

>Form [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized.git)

---------------

> Dockerized PHP development stack: Nginx, MySQL, MongoDB, PHP-FPM, Gearman, Memcached, Redis, Elasticsearch and RabbitMQ

[![Build Status](https://travis-ci.org/kasperisager/php-dockerized.svg)](https://travis-ci.org/kasperisager/php-dockerized)

PHP Dockerized gives you everything you need for developing PHP applications locally. The idea came from the need of having an OS-agnostic and virtualized alternative to the great [MNPP](https://github.com/jyr/MNPP) stack as regular LAMP stacks quite simply can't keep up with the Nginx + PHP-FPM/HHVM combo in terms of performance. I hope you'll find it as useful an addition to your dev-arsenal as I've found it!

## What's inside

* [Nginx](http://nginx.org/)
* [MySQL](http://www.mysql.com/)
* [MongoDB](http://www.mongodb.org/)
* [PHP-FPM](http://php-fpm.org/) -- 5.6/7.0
* ~~[HHVM](http://www.hhvm.com/)~~
* [Gearman](http://gearman.org/)
* [Memcached](http://memcached.org/)
* [Redis](http://redis.io/)
* [Elasticsearch](http://www.elasticsearch.org/)
* [RabbitMQ](https://www.rabbitmq.com/)

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

## use Docker Toolbox

windows 8/10 可以直接使用 `Docker For Windows`. 请跳过此节。

```sh
$ docker-machine start default # 可省略 default
$ git clone https://github.com/inhere/php-dockerized.git 
$ cd php-dockerized && git checkout my
$ docker-compose up
```

查看default虚拟机信息 得到虚拟机的ip `192.168.99.100`, 现在可通过 浏览器访问 `192.168.99.100`

```
$ docker-machine env [default] 
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/inhere/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env)
```


其他命令使用

```
$ eval $(docker-machine env default) # 连上机器，不然无法执行下面的命令
$ docker ps // 查看正在运行的容器列表

# 可以直接 curl 192.168.99.100:80
# 也可在 web 容器中运行 curl --HEAD localhost:80 检查php 是否运行成功
# phpdockerized_web_1 是正在运行的webapp容器(通过 Dockerfile 构建的镜像)
$ docker exec -ti phpdockerized_web_1 curl --HEAD localhost:80 
```

## use Docker For Windows/ Docker for Mac

需要先下载 `Docker For Windows` 或者 `Docker for Mac`。

> 需要较高的windows版本,并且需要开启 **Hyper-V**

- [官网下载](https://www.docker.com/products/docker)
- [daocloud下载](http://get.daocloud.io/#install-docker-for-mac-windows)

直接运行 `Docker For Windows` / `Docker for Mac`, 这个版本不需要 `docker-machine`.

```
$ git clone https://github.com/inhere/php-dockerized.git 
$ cd php-dockerized && git checkout my
$ docker-compose up
// $ docker-compose up -d
$ docker ps // 查看正在运行的容器列表

```

## 问题

### 若配置文件不是默认的名称`docker-compose.yml`

可使用`-f {filename}`参数.

```
$ docker-compose -f docker-compose-my.yml up -d
```

- `-f {filename}` 指定 compose 配置文件
- `-p {project name}` 指定项目名称，默认是文件夹的名称
- `-d` 后台运行

### 在windows下的 Docker Toolbox 搭建的环境有些问题，挂载的数据文件夹无法同步数据

需要先在 VirtualBox > 设置 > 共享文件夹 挂载windows下的文件夹到虚拟机内部 

```
E:\workenv ===> Users # 挂载本机的 E:\workenv 到虚拟机的 /Users 上
```

这样后 在docker-compose.yml 中配置挂载卷，就直接使用 `/Users/xxx` 这样的绝对路径，

```
mysql:
  image: mysql:5.6
  container_name: ug-mysql
  ports:
    - "3306:3306"
  volumes:
    # - ./data/volumes/mysql-56:/var/lib/mysql
    - /Users/php-dockerized/data/volumes/mysql-56:/var/lib/mysql
  environment:
    MYSQL_ROOT_PASSWORD: password
```

> 挂载点 `Users` 好像不能随意命名，否则可能会挂载不成功 
看这篇[文章](http://blog.csdn.net/jam_lee/article/details/40947429) 说是有几个固定的挂载点才可以用

## License

Licensed under the terms of the [MIT license](LICENSE.md).
