# Dockerenv

>Form [kasperisager/php-dockerized](https://github.com/kasperisager/php-dockerized.git)

---------------

> PHP development stack: Nginx, MySQL, MongoDB, PHP-FPM, Gearman, Memcached, Redis, Elasticsearch and RabbitMQ

完整的一整套php开发环境。以及一些扩展的环境

## 包含容器

* [Nginx](http://nginx.org/)
* [MySQL](http://www.mysql.com/)
* [MongoDB](http://www.mongodb.org/)
* [PHP-FPM](http://php-fpm.org/) -- 5.6/7
* ~~[HHVM](http://www.hhvm.com/)~~
* [Gearman](http://gearman.org/)
* [Memcached](http://memcached.org/)
* [Redis](http://redis.io/)
* [Elasticsearch](http://www.elasticsearch.org/)
* [RabbitMQ](https://www.rabbitmq.com/)
* 更多请查看 `services` 的子目录

## 运行需求

* [Docker Engine](https://docs.docker.com/installation/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Machine](https://docs.docker.com/machine/) (If use Docker Toolbox)

## 获取 

```sh
$ git clone https://github.com/inhere/dockerenv.git  
```

## 运行 

### use Docker For Windows/ Docker for Mac

需要先下载 `Docker For Windows` 或者 `Docker for Mac`。

- [官网下载](https://www.docker.com/products/docker)
- [daocloud下载](http://get.daocloud.io/#install-docker-for-mac-windows)

> 需要windows 10 x64版本,并且需要开启 **Hyper-V**. Mac 则需要 OS X 10.10.3 或者更高版本

直接运行 `Docker For Windows` / `Docker for Mac`, 这个版本不需要 `docker-machine`.

启动docker，然后运行:

```sh
$ cp docker-compose.56.yml docker-compose.yml # 拷贝需要的配置
$ docker-compose up
// $ docker-compose up -d // 后台运行
$ docker ps // 查看正在运行的容器列表

```

## Questions - 问题

- compose v3 版本不在支持 `extends` 项

### 自定义构建参数

大部分自定义容器都添加了自定义构建参数，需要传入. 如：

```yml
php7:
  build:
    context: .
    dockerfile: ./services/php/Dockerfile
    args:
      fpmport: "9001"
      timezone: Asia/Shanghai 
```


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

## 一些容器默认信息

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

## License

Licensed under the terms of the [MIT license](LICENSE.md).
