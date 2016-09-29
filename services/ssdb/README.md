# ssdb 

SSDB 是一个 C/C++ 语言开发的高性能 NoSQL 数据库, 
支持 zset(sorted set), map(hash), kv, list 等数据结构, 用来替代或者与 Redis 配合存储十亿级别的列表数据. 

项目主页: [github](https://github.com/ideawu/ssdb)
Blog: http://www.ideawu.net/blog/ssdb

## 主要特点:

- 支持 zset, map/hash, list, kv 数据结构, 可替代 Redis(比redis少了set,pub/sub)
- 特别适合存储大量集合数据, 支持丰富的数据结构: key-value, key-map, key-zset, key-list.
- 使用 Google LevelDB 作为存储引擎
- 支持主从同步, 多主同步
- 客户端支持 [PHP][php_client], C++, Python, Lua, Java, Ruby, nodejs, Go 等
- 内存占用极少
- 图形化界面管理工具 [phpssdbadmin](https://github.com/ssdb/phpssdbadmin)


[php_client]:https://github.com/ideawu/ssdb/tree/master/api/php