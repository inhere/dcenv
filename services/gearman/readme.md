
gearmand packages form:

```
wget https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz
```

## testing

- worker

```
$ docker exec -ti webapp bash
root@b52c06a9bbe0:/# cd var/www/default/
root@b52c06a9bbe0:/var/www/default# php gearman-worker.php
Version 1.0.6
Waiting for job...
```

- client

```
$ docker exec -ti webapp bash
root@b52c06a9bbe0:/# cd var/www/default/
root@b52c06a9bbe0:/var/www/default# php gearman-client.php
Sending job
Success: !olleH
```

## 异步同步数据

reference [通过Gearman实现MySQL到Redis的数据复制](http://avnpc.com/pages/mysql-replication-to-redis-by-gearman)


## gearman 持久化队列启动示例

- sqlite 示例

```
$ gearmand -l /usr/local/var/log/trace2.log --verbose INFO -p 4830 -q libsqlite3 --libsqlite3-db /usr/local/sqlite/bin/gearman.db3 --libsqlite3-table gearman_queue -d
```

```
$ gearmand -q libsqlite3 --libsqlite3-db /var/lib/gearman/data.sqlite3 -l /dev/stdout
```

- mysql 示例

```
$ gearmand -q libdrizzle --libdrizzle-host=127.0.0.1 --libdrizzle-user=gearman --libdrizzle-password=password --libdrizzle-db=gearman --libdrizzle-table=gearman_queue --libdrizzle-mysql
```

## doc - gearman+mysql实现持久化队列

创建数据库和表

```
create database gearman
create table `gearman_queue` (
`unique_key` varchar(64) NOT NULL,
`function_name` varchar(255) NOT NULL,
`priority` int(11) NOT NULL,
`data` LONGBLOB NOT NULL,
`when_to_run` INT, PRIMARY KEY  (`unique_key`)
)
```

启动gearmand

```
gearmand -q libdrizzle --libdrizzle-host=127.0.0.1 --libdrizzle-user=gearman --libdrizzle-password=password --libdrizzle-db=gearman --libdrizzle-table=gearman_queue --libdrizzle-mysql
```

创建一个后台job

```
gearman -f testqueue -b xx00
```

查看队列

```
select * from gearman.gearman_queue
```

执行队列中的job

```
gearman -f testqueue -w
```

查看队列

```
select * from gearman.gearman_queue  //这条job删除掉了
```