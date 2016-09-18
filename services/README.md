# service folder

## 运行指定的单个服务

```
$ docker-compose run web bash
```

## 更换(debain 8)软件源

在 Dockerfile 中添加

拷贝配置：

```
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources    /etc/apt/sources.list
```

也可直接写入：

```
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
&& { \
echo "deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib"; \
echo "deb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib"; \
echo "deb http://mirrors.aliyun.com/debian-security/ jessie/updates main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian-security/ jessie/updates main non-free contrib"; \
} | tee /etc/apt/sources.list
```


复制tar包文件时，使用的Docker指令是COPY而不是ADD，这是由于ADD指令会自动解压tar文件。

```
COPY packages/redis.tgz /tmp/redis.tgz
RUN pecl install /tmp/redis.tgz && echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
```

```
ADD tools/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
```


```
#关闭php-fpm
kill -INT `cat /usr/local/php/var/run/php-fpm.pid`
 
#重启php-fpm
kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
```

## 继承基础php镜像的一些信息

### php 5.6

- php execute file: `/usr/local/bin/php`
- php-fpm execute file: `/usr/local/sbin/php-fpm`
- php-fpm conf: `/usr/local/etc/php-fpm.conf`
- php源码目录：`/usr/src` -- 运行 `docker-php-source extract` 可解压出来
- 扩展编译配置：`/usr/local/etc/php/conf.d/`
- 扩展编译目录：`/usr/local/lib/php/extensions/no-debug-non-zts-20131226/`

