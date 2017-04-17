# Dockerenv

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
* [Docker Machine](https://docs.docker.com/machine/) (If use Docker Toolbox)

## Running

Set up a Docker Machine and then run:

```sh
$ docker-compose up
```

That's it! You can now access your configured sites via the IP address of the Docker Machine or locally if you're running a Linux flavour and using Docker natively.

## use Docker For Windows/ Docker for Mac

需要先下载 `Docker For Windows` 或者 `Docker for Mac`。

- [官网下载](https://www.docker.com/products/docker)
- [daocloud下载](http://get.daocloud.io/#install-docker-for-mac-windows)

> 需要windows 10 x64版本,并且需要开启 **Hyper-V**. Mac 则需要 OS X 10.10.3 或者更高版本

直接运行 `Docker For Windows` / `Docker for Mac`, 这个版本不需要 `docker-machine`.

```
$ git clone https://github.com/inhere/php-dockerized.git 
$ cd php-dockerized && git checkout my
$ cp docker-compose.56.yml docker-compose.yml # 拷贝需要的配置
$ docker-compose up
// $ docker-compose up -d
$ docker ps // 查看正在运行的容器列表

```

## Services exposed outside your environment

You can access your application via **`localhost`**, if you're running the containers directly, or through **`192.168.33.152`** when run on a vm. nginx and mailhog both respond to any hostname, in case you want to add your own hostname on your `/etc/hosts` 

Service|Address outside containers|Address outside VM
------|---------|-----------
Webserver|[localhost](http://localhost)|[192.168.33.152](http://192.168.33.152)

## Hosts within your environment

You'll need to configure your application to use any services you enabled:

Service|Hostname|Port number
------|---------|-----------
webapp(php-fpm)|webapp|`9000`
webserver(nginx)|webserver|`80` (http) / `443` (ssl)
MySQL|mysql|`3306` (default)
Gearman|gearman|`4730` (default)
Memcached|memcached|`11211` (default)
Redis|redis|`6379` (default)
Elasticsearch|elasticsearch|`9200` (HTTP default) / `9300` (ES transport default)

## 一些有用的

- bash alias 

in the `~/.bashrc`

```
alias dcm=docker-machine
alias dcc=docker-compose
# 指定了配置的 docker-compose
alias dccloc='docker-compose -f docker-compose.loc.yml -p ugirls'
# 杀死所有正在运行的容器.
alias dockerkill='docker kill $(docker ps -a -q)'
# 删除所有已经停止的容器.
alias dockercleanc='docker rm $(docker ps -a -q)'
# 删除所有未打标签的镜像.
alias dockercleani='docker rmi $(docker images -q -f dangling=true)'
```

- 添加 `.dockerignore` 文件

推荐添加 `.dockerignore` 文件,定义忽略文件/夹

因为 docker build 时会发送 `context` 目录的所有文件到 Docker daemon, 
若context目录下有很多文件会造成花费时间很长，甚至程序卡死。

e.g 

```
node_modules/
.git/
www/
# data/
logs/
# tools/
# services/
Dockerfile
*.Dockerfile
*.tar.gz
*.tgz
*.zip
*.md
```

> 注意：若文件夹中有文件被 Dockerfile 使用，则不能将此文件夹加入忽略，否则 docker 构建时会报找不到文件

## Questions - 问题

- compose v3 版本不在支持 `extends` 项

### 配置文件不是默认的名称

若要使用配置文件不是默认名称`docker-compose.yml`的，除了拷贝重命名为默认名称 `docker-compose.yml` 外，
也可使用`-f {filename}`参数.

```
$ docker-compose -f docker-compose.70.yml up -d
```

- `-f {filename}` 指定 compose 配置文件
- `-p {project name}` 指定项目名称，默认是文件夹的名称
- `-d` 后台运行

### nginx 站点配置

若使用的是nginx和php分开的服务容器，注意站点配置中

```
    fastcgi_pass  unix:/var/run/php5-fpm.sock;
```

要换成访问php容器的9000端口

```
    fastcgi_pass  webapp:9000;
```

## License

Licensed under the terms of the [MIT license](LICENSE.md).
