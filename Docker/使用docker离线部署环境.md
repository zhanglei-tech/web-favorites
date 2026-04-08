# 使用docker离线部署环境

# 离线镜像准备

## 安装docker

### 安装docker

```bash
yum install docker
```

### 启动docker

```bash
systemctl start docker
```

# 离线环境部署

## 安装docker

```bash
docker load < ./rabbitmq.tar
docker run -d --restart=always -p 5672:5672 -p 15672:15672 --name rabbitmq rabbitmq:management
docker load < ./redis.tar
docker run -d --restart=always -p 6379:6379 --name redis redis
```

## 安装php-apache

```bash
docker load < ./php-apache.tar
docker run -d --restart=always -v /mnt/data/webroot:/var/www/html -p 80:80 --name php-apache php:7.2-apache

# 进入容器
docker exec -it test-php /bin/bash

# 安装 mysql 扩展
cd /usr/local/bin
./docker-php-ext-install pdo_mysql
./docker-php-ext-install mysqli
apt-get update && apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
./docker-php-ext-install zip
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
apt-get update -y && apt-get install -y libpng-dev
./docker-php-ext-install gd

apt-get update -y && apt-get install -y freetype*
apt-get update -y && apt-get install -y libjpeg*

apt-get update && apt-get install libgd3 libgd-dev && rm -rf /var/lib/apt/lists/*
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
docker-php-ext-install -j$(nproc) gd

docker import php-apache.tar php:7.2-apache
docker run -d --restart=always -v /mnt/data/webroot:/var/www/html -p 80:80 --name php-apache php:7.2-apache sh -c "docker-php-entrypoint apache2-foreground"
```

## 安装mariadb

```bash
docker load < ./mariadb.tar
mkdir -p /mnt/data/mariadb
mkdir -p /mnt/data/my.cnf.d
docker run -d --restart=always -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -v /mnt/data/my.cnf.d:/etc/mysql/conf.d -v /mnt/data/mariadb:/var/lib/mysql --name mariadb mariadb sh -c "docker-entrypoint.sh mariadbd"

docker run --restart=always -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mariadb -d mariadb

docker run --restart=always -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --privileged=true --name mariadb -d mariadb

```

```bash
docker ps --no-trunc
```