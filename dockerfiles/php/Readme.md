# PHP service

## 基于alpine的环境

- 构建基础镜像

```sh
cd services/php
docker build . -f alphp-base.Dockerfile -t alphp:base
```

- 添加额外扩展

ext: `swoole, mongodb`

```sh
docker build . -f alphp-cli.Dockerfile -t alphp:cli

// 在alphp:cli 的基础上，含有 nginx php-fpm
docker build . -f alphp-fpm.Dockerfile -t alphp:fpm

// 在alphp:cli 的基础上，含有 nginx php-fpm 额外包含一些常用工具： vim wget git zip telnet ab 等
docker build . -f alphp-dev.Dockerfile -t alphp:dev
```

## 更改时区

```
Asia/Shanghai
RUN sed -i "s/;date.timezone =.*/date.timezone = America\/New_York/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = America\/New_York/" /etc/php5/cli/php.ini
```

## 额外扩展

```
memcache
memcached
redis
gearman -- 队列任务处理
seaslog -- 日志扩展
swoole -- 异步事件扩展
xhprof -- 性能分析
xdebug -- 调试工具
yac -- 快速的用户数据共享内存缓存
yar -- 快速并发的rpc
msgpack  -- MessagePack 数据格式实现
yaconf  -- 持久配置容器(php7+)
```

## add composer tool

```
ADD tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
```

## some tool use

- how to operate php-fpm by command

```
#关闭php-fpm
kill -INT `cat /usr/local/php/var/run/php-fpm.pid`

#重启php-fpm
kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
```

## 一些信息

继承自基础php镜像创建的容器中的php，与通过系统安装的php有些不太一样的地方。

**继承基础php镜像的php**

- php execute file: `/usr/local/bin/php`
- php-fpm execute file: `/usr/local/sbin/php-fpm`
- php-fpm conf: `/usr/local/etc/php-fpm.conf`
- php源码目录：`/usr/src` -- 运行 `docker-php-source extract` 可解压出来
- 扩展编译配置：`/usr/local/etc/php/conf.d/`
- 扩展编译目录：`/usr/local/lib/php/extensions/no-debug-non-zts-20131226/`

## some command

```
// install php by command(apt-get).
service php5-fpm reload
// if from base php image
service php-fpm reload

service nginx reload
```

## debian

```bash
apt -y install software-properties-common apt-transport-https lsb-release ca-certificates; \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://mirror.xtom.com.hk/sury/php/apt.gpg; \
    sh -c 'echo "deb https://mirror.xtom.com.hk/sury/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'; 
```

```bash
# 更换(debian 8)软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD data/resources/debian8.sources /etc/apt/sources.list
```

```bash
sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list
```

## 工具

show docker layer info:

```bash
docker history IMAGE
```

### 端口檢測 lsof

```
apt-get install lsof
```

### ab 压力测试

安装

```
// ubuntu
apt-get install apache2-utils
// centos
yum install httpd-tools
```
