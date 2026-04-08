# Ubuntu基础环境搭建

# 安装必要软件

```bash
sudo apt install apt-transport-https curl
```

# 安装docker engine

## 安装签名文件

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

## 安装源

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

## 安装docker engine

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

# 安装Nginx

## 安装签名文件

```bash
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
```

## 安装源

```bash
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
```

## 安装Nginx

```bash
sudo apt update
sudo apt install nginx
```

## 部署配置文件

将部署包中`nginx配置文件`内的配置文件上传到`/etc/nginx/conf.d`目录下

## 重启nginx

```bash
sudo systemctl restart nginx
```

## 设置开机启动nginx

```bash
sudo systemctl enable nginx
```

# 安装Mariadb

## 安装密钥

```bash
sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
```

## 安装源

```bash
sudo sh -c "echo 'deb https://mirrors.xtom.com.hk/mariadb/repo/10.6/ubuntu jammy main' >>/etc/apt/sources.list"
```

## 安装Mariadb

```bash
sudo apt update
sudo apt install mariadb-server
```

## 设置密码以及完成初始化

```bash
sudo /usr/bin/mariadb-secure-installation
```

回车，根据提示输入Y

输入2次密码`yundait@2022`，回车，注意：linux输入密码时没有回显

根据提示一路输入Y

最后出现：Thanks for using MySQL!

接下来按照提示为root设置密码，删除匿名用户，删除test数据库，然后刷新权限！此时就可以使用新密码登录了。

## 开启远程访问

```bash
sudo mysql -uroot -p
```

```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'yundait@2025' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

## 重新启动 MariaDB

```bash
sudo systemctl restart mariadb
```

## 设置开机启动MariaDB

```bash
sudo systemctl enable mariadb
```

## 修改绑定地址

```bash
vim /etc/mysql/mariadb.conf.d/50-server.cnf
```

找到 “bind-address = 127.0.0.1”，在前面加"#"，注释该行

# 安装redis

## 安装redis

```bash
sudo apt install redis
```

## 设置redis开机启动

```bash
sudo systemctl start redis
```

## 启动redis

```bash
sudo systemctl enable redis-server
```

# 安装Java

## 安装openjdk

```bash
sudo apt install openjdk-8-jdk-headless
```

# 开启root用户远程登录

## 修改root用户密码

```bash
sudo passwd root
```

## 开启root用户远程登录

```bash
sudo vim /etc/ssh/sshd_config
```

找到以下内容修改

```bash
#PermitRootLogin yes
改为
PermitRootLogin yes
```