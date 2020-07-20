# Docker Alpine Openresty

# 版本说明

* [1.17](https://github.com/seffeng/docker-openresty/tree/1.17)


## 环境

```
alpine: ^3.12
openresty: ^1.17
```

## 常用命令：

```sh
# 拉取镜像
$ docker pull seffeng/openresty

# 运行；若配合 php 使用，注意 <html-dir> 和 <tmp-dir> 与 php 一致
$ docker run --name nginx-test -d -p 80:80 -p 443:443 -v <html-dir>:/opt/websrv/data/wwwroot -v <conf-dir>:/opt/websrv/config/nginx/conf.d -v <cert-dir>:/opt/websrv/config/nginx/certs.d -v <log-dir>:/opt/websrv/logs -v <tmp-dir>:/opt/websrv/tmp seffeng/openresty

# 例子：
$ docker run --name nginx-alias1 -d -p 80:80 -p 443:443 -v /srv/websrv/data/wwwroot:/opt/websrv/data/wwwroot -v /srv/websrv/config/nginx/conf.d:/opt/websrv/config/nginx/conf.d -v /srv/websrv/config/nginx/certs.d:/opt/websrv/config/nginx/certs.d -v /srv/websrv/logs/nginx:/opt/websrv/logs -v /srv/websrv/tmp:/opt/websrv/tmp seffeng/openresty

# 查看正在运行的容器
$ docker ps

# 停止
$ docker stop [CONTAINER ID | NAMES]

# 启动
$ docker start [CONTAINER ID | NAMES]

# 进入终端
$ docker exec -it [CONTAINER ID | NAMES] sh

# 删除容器
$ docker rm [CONTAINER ID | NAMES]

# 镜像列表查看
$ docker images

# 删除镜像
$ docker rmi [IMAGE ID]

# 复制本机文件到容器
$ docker cp /root/file [CONTAINER ID]:/root/file

# 复制容器文件到本机
$ docker cp [CONTAINER ID]:/root/file /root/file
```

## 备注

```shell
# 网站配置请参考 conf/conf.d/_http.conf，修改以下配置：
listen: #删除 default_server;
server_name: #域名;
root: #网站根目录;
error_log: #错误日志，可替换 ip_error 为对应域名或增加域名目录（/opt/websrv/logs/domain/ip_error.log）;
access_log: #访问日志，可替换 ip_access 为对应域名或增加域名目录（/opt/websrv/logs/domain/ip_access.log）;
fastcgi_pass: #配合docker seffeng/php:版本（7.4-unix_php74_fpm, 7.3-unix_php73_fpm, 7.2-unix_php72_fpm, 7.1-unix_php71_fpm）
```
```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name nginx-alias1 --network network-01 --network-alias nginx-net1 -d -p 80:80 -p 443:443 -v /srv/websrv/data/wwwroot:/opt/websrv/data/wwwroot -v /srv/websrv/config/nginx/conf.d:/opt/websrv/config/nginx/conf.d -v /srv/websrv/config/nginx/certs.d:/opt/websrv/config/nginx/certs.d -v /srv/websrv/logs/nginx:/opt/websrv/logs -v /srv/websrv/tmp:/opt/websrv/tmp seffeng/openresty
```
