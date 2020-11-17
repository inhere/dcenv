# tools

## docker php scripts

- https://raw.githubusercontent.com/docker-library/php/master/docker-php-entrypoint
- https://raw.githubusercontent.com/docker-library/php/master/docker-php-ext-configure
- https://raw.githubusercontent.com/docker-library/php/master/docker-php-ext-enable
- https://raw.githubusercontent.com/docker-library/php/master/docker-php-ext-disable

curl fetch:

```
curl -o docker-php-ext-enable https://raw.githubusercontent.com/docker-library/php/master/docker-php-ext-enable
```

## opcache

```ini
zend_extension=opcache.so

opcache.max_accelerated_files = 10000
opcache.memory_consumption = 256
opcache.interned_string_buffer = 16
```

## vhosts

```
server {
    listen       59420;
    server_name _;

    # 2 处理静态文件请求
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|ttf|woff2|woff|map)$ {
        root   /var/www/web/;
        expires       max;
        access_log    off;
    }

    location / {
        root   /var/www/;
        # try_files $uri $uri/ /index.php$is_args$args;
        try_files $uri $uri/ /uem.phar$is_args$args;

        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  uem.phar;

        include        fastcgi.conf;
    }
}
```

## 库推荐

- [workerman](https://github.com/walkor/workerman)
- [workerman-statistics](https://github.com/walkor/workerman-statistics)
- [swoole](https://github.com/swoole/swoole-src)

### GearmanManager(php)

[GearmanManager](https://github.com/brianlmoon/GearmanManager)

运行Gearman的Worker是项比较让人讨厌的任务。千篇一律的代码...GearmanManager的目标是让运行worker成为一项运维性任务而不是开发任务。
文件名直接对应于Gearmand服务器中的function，这种方式极大简化了function在worker中的注册。

[中文介绍](http://www.cnblogs.com/x3d/p/gearman-worker-manager.html)

### solariumphp/solarium

[solariumphp/solarium](https://github.com/solariumphp/solarium)

搜索引擎solr的php客户端

### elastic/elasticsearch-php

[elastic/elasticsearch-php](https://github.com/elastic/elasticsearch-php)

搜索引擎elasticsearch的官方php客户端

## 工具列表

- composer 包管理
- phpunit 单元测试
- phpmd 代码检查
- apigen API文档生成
- phpDocumentor API文档生成
- sami API文档生成
- [deployer](https://deployer.org/releases/v4.0.1/deployer.phar) 一个用PHP编写的部署工具支持流行的框架

### 重新生成 composer autoload

```
composer up nothing
```

## 下载安装xhprof

from http://www.open-open.com/lib/view/open1453899928714.html

- 下载编译安装的命令如下：

```
$ wget https://github.com/phacility/xhprof/archive/master.zip
$ unzip ./xhprof_master.zip
$ cd ./xhprof_master/extension
$ /usr/local/php/bin/phpize
$ ./configure --with-php-config=/usr/local/php/bin/php-config
$ make
$ make install
```

- 启用 xhprof 扩展， 检查安装 `php -m`

- 拷贝xhprof相关程序到指定目录:

```
$ mkdir -p /www/sites/xhprof
$ cp -r ./xhprof_master/xhprof_html /www/sites/xhprof
$ cp -r ./xhprof_master/xhprof_lib /www/sites/xhprof
```

- 修改nginx配置，以便通过url访问性能数据:

在nginx中增加如下代码：

```
server {
    listen  8999;
    root    /opt/sites/xhprof/;
    index  index.php index.html;
    location ~ .*\.php$ {
        add_header  Cache-Control "no-cache, no-store, max-age=0, must-revalidate";
        add_header  Pragma  no-cache;
        add_header Access-Control-Allow-Origin *;
        add_header      Via "1.0 xgs-150";
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        include fastcgi.conf;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }
}
```

## install swoole

官网 swoole.com
安装相关扩展 redis, zip, mbstring, inotify, pdo_mysql

### 相关库

- hiredis https://github.com/redis/hiredis
- nghttp2 https://github.com/tatsuhiro-t/nghttp2

### 编译命令

```
# phpize
# ./configure --enable-swoole-debug --enable-async-redis --enable-openssl --enable-sockets --enable-coroutine --with-php-config=/usr/local/bin/php-config
# make clean
# make -j
# make install
```

### 更多选项说明

使用 `./configure -h` 可以看到全部的选项

- `--enable-swoole-debug`  // 打开调试日志，开启此选项后swoole将打印各类细节的调试日志。生产环境不要启用。
- `--enable-sockets`       // 增加对sockets资源的支持，依赖sockets扩展
- `--enable-async-redis`   // 增加异步Redis客户端支持， 依赖hiredis库
- `--enable-openssl`       // 启用SSL支持
- `--enable-http2`         // 增加对HTTP2的支持，依赖nghttp2库. 必须开启openssl
- `--enable-coroutine`       // 启用协程能力


## internal api generate

### 使用 apigen

```
$ ./vendor/bin/apigen.phar -V
$ ./vendor/bin/apigen.phar generate --help
$ ./vendor/bin/apigen.phar generate -s {source code dir} -d {doc generate dir}
```

### 使用phpDocumentor

```
$ ./vendor/bin/phpDocumentor.phar -V
phpDocumentor version v2.9.0
$ ./vendor/bin/phpDocumentor.phar run -d {source code dir} -t {doc generate dir}
```

### 使用 sami

```
$ ./vendor/bin/sami.phar -V

// The parse command parses a project and generates a database
$ php ./vendor/bin/sami.phar parse config/symfony.php

// The render command renders a project as a static set of HTML files
$ php ./vendor/bin/sami.phar render config/symfony.php
```

use:

```
$ php ./vendor/bin/sami.phar update build/sami.conf.php
```
