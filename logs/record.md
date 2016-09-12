```
docker-machine ssh default "echo 'EXTRA_ARGS=\"--registry-mirror=https://cbiol22u.mirror.aliyuncs.com\"' | sudo tee -a /var/lib/boot2docker/profile"

docker-machine restart default
```