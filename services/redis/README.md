# redis

## single machine sluster

配置： `single-machine-cluster.Dockerfile`

单机器多实例的redis集群
创建6个redis实例，3主3从

```
------------------Container---------------------------
|       .......        .......        .......        |
|       :  M  :        :  M  :        :  M  :        |
|       .......        .......        .......        |
|          |              |              |           |
|          ^              ^              ^           |
|       .......        .......        .......        |
|       :  S  :        :  S  :        :  S  :        |
|       .......        .......        .......        |
|                                                    | 
------------------------------------------------------
```

## 一些工具库

### RedisLive (python)

一个用来监控redis实例， 通过monitor获取信息, 分析查询语句并且有web界面的监控工具，python编写。

在 `services/redis/scripts/` 提供了安装脚本 `install-RedisLive.sh`

### redis-stat (ruby)

[redis-stat](https://github.com/junegunn/redis-stat)

  一个用ruby写成的监控redis的程序，基于info命令获取信息，而不是通过monitor获取信息，性能应该比monitor要好。
