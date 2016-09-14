
packages form:

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
