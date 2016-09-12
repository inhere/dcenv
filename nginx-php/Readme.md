## 更换(debain 8)软件源

在 Dockerfile 中添加

拷贝配置：

```
ADD conf/sources.list    /etc/apt/sources.list
```

也可直接写入：

```
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
&& { \
echo "deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib"; \
echo "deb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib"; \
echo "deb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib"; \
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
