# readme

```
# docker build 
docker run -ti -v "./www/golang:/go" -p "8080:8080" --name go-env golang:alpine sh
# 使用golang官方镜像
docker run -ti -v "./www/golang:/go" -p "8080:8080" --name go-env golang bash
# on windows, must is a absolute path.
docker run -ti -v "e:/workenv/php-dockerized/www/golang:/go" -p "8080:8080" --name go-env golang bash
```
