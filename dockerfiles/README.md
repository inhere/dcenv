# service folder

复制tar包文件时，使用的Docker指令是COPY而不是ADD，这是由于ADD指令会自动解压tar文件。

```
COPY packages/redis.tgz /tmp/redis.tgz
RUN pecl install /tmp/redis.tgz && echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
```

## 运行指定的单个服务

```
$ docker-compose run web bash
```

## 更换debain软件源

在 Dockerfile 中添加

拷贝配置：

```bash
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY data/resources/debian8.sources    /etc/apt/sources.list
```

直接替换：

```bash
sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list; \
    sed -i 's/security.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list;
```

也可完整的重新写入：

- debian 8:

```bash
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

- debian 9:

```bash
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
&& { \
echo "deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib"; \
echo "deb http://mirrors.aliyun.com/debian/ stretch-proposed-updates main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian/ stretch-proposed-updates main non-free contrib"; \
echo "deb http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib"; \
} | tee /etc/apt/sources.list
```

## 更换(alpine)软件源

拷贝配置：

```bash
RUN mv /etc/apk/repositories /etc/apk/repositories.bak
COPY data/resources/alpine.repositories /etc/apk/repositories
```

也可直接写入：

```sh 
RUN mv /etc/apk/repositories /etc/apk/repositories.bak \
    && { \
    echo "http://mirrors.aliyun.com/alpine/edge/main"; \
    echo "http://mirrors.aliyun.com/alpine/edge/community"; \
    echo "http://mirrors.aliyun.com/alpine/edge/testing"; \
    } | tee /etc/apk/repositories
```

> 使用 `edge`, 里面的软件包更丰富版本也更新

也可不用 `edge` 下的, 仍使用原来版本下的：

```sh
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
```

## supervisor 管理进程

```
[program:php-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /home/forge/app.com/artisan queue:work sqs --sleep=3 --tries=3 --daemon
autostart=true
autorestart=true
user=forge
numprocs=8
redirect_stderr=true
stdout_logfile=/home/forge/app.com/worker.log
```

manager:

```
sudo supervisorctl reread

sudo supervisorctl update

sudo supervisorctl start php-worker:*
```
