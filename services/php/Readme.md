# PHP service

## 更改时区

```
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
xhprof -- 性能分析
xdebug -- 调试工具
```

- add composer tool

```
ADD tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
```

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

## 库推荐

- [workerman](https://github.com/walkor/workerman)
- [workerman-statistics](https://github.com/walkor/workerman-statistics)
- [swoole](https://github.com/swoole/swoole-src)

## 工具

### ab 压力测试

安装

```
// ubuntu
apt-get install apache2-utils
// centos
yum install httpd-tools
```
