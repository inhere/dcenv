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
