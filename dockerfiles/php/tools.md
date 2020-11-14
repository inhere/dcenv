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
