# CentOS7 LAMP环境部署

# 准备工作

## 工具准备

1. 安装vim

```bash
yum install vim -y
```

1. 安装wget

```bash
yum install wget -y
```

## 防火墙设置

1. 关闭SELinux
- 打开配置文件

```bash
vim /etc/selinux/config
```

- 编辑以下内容并保存

```bash
# SELINUX=enforcing #注释掉
# SELINUXTYPE=targeted #注释掉
SELINUX=disabled #增加
```

- 使配置立即生效

```bash
setenforce 0
```

1. 配置firewall
- 启动firewall

```bash
systemctl start firewalld
```

- 设置开机启动firewall

```bash
systemctl enable firewalld
```

- 添加ssh端口，默认端口22，需要修改为非默认端口

```bash
firewall-cmd --add-port=22/tcp --permanent
```

- 添加MariaDB端口，默认端口3306，需要修改为非默认端口

```bash
firewall-cmd --add-port=3306/tcp --permanent
```

- 添加80端口

```bash
firewall-cmd --add-port=80/tcp --permanent
```

- 刷新firewall规则

```bash
firewall-cmd --reload
```

## 配置第三方源

1. 备份系统默认源

```bash
cd /etc/yum.repos.d
mkdir backup
mv *.repo ./backup/
```

1. 安装第三方国内源

CentOS7 官方源连接的是境外地址，在国内网络环境下可能会访问慢甚至无法访问，所以换成国内第三方源，加快访问速度。除了阿里云源，也可以选择163源，**二者选一个安装即可**。

- 阿里云

```bash
cd /etc/yum.repos.d
wget http://mirrors.aliyun.com/repo/Centos-7.repo
```

- 163

```bash
cd /etc/yum.repos.d
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
```

1. 安装epel源

EPEL是基于Fedora的一个项目，为“红帽系”的操作系统提供额外的软件包

```bash
yum install epel-release -y
```

1. 安装remi源

CentOS7 自带源默认PHP版本为5.4，remi源用于安装高版本PHP。安装过程中由于网络原因可能会失败，如果失败，需要多执行几次，直至成功安装。

```bash
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
```

1. 安装CodeIT源

CentOS7 自带源默认apache版本为2.4.6，nginx版本为1.12.2，版本陈旧，存在安全漏洞，CodeIT源中包含新版本的apache和nginx。

```bash
cd /etc/yum.repos.d
wget https://repo.codeit.guru/codeit.el7.repo
```

1. 安装MariaDB源

CentOS7 自带MariaDB版本为5.5.56，无法使用MariaDB的新版本特性。

创建源配置文件

```bash
cd /etc/yum.repos.d
cat <<EOF | sudo tee /etc/yum.repos.d/mariadb.repo
# MariaDB 10.7 CentOS repository list - created 2022-04-27 09:38 UTC
# https://mariadb.org/download/
[mariadb]
name = MariaDB
baseurl = https://mirrors.aliyun.com/mariadb/yum/10.7/centos7-amd64
gpgkey=https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
```

1. 重建yum缓存

```bash
yum clean all
yum makecache
```

1. 升级系统自带软件包

升级系统自带软件包可以修复一些因为版本问题引发的安全漏洞

```bash
yum update -y
```

# 修改ssh端口

- 打开配置文件

```bash
vim /etc/ssh/sshd_config
```

- 修改端口号，与防火墙设置一致

```bash
# Port 22
改为
Port 22
```

- 重启ssh

```bash
systemctl restart sshd
```

# 安装MariaDB

## 安装MariaDB

```bash
yum install MariaDB-server MariaDB-client -y
```

## 启动MariaDB

```bash
systemctl start mariadb
```

## 设置密码以及完成初始化

```bash
/usr/bin/mariadb-secure-installation
```

接下来按照提示为root设置密码，删除匿名用户，删除test数据库，然后刷新权限！此时就可以使用新密码登录了。 回车，根据提示输入Y 输入2次密码，回车 根据提示一路输入Y 最后出现：Thanks for using MySQL!

## 重新启动 MariaDB

```bash
systemctl restart mariadb
```

## 开启远程访问

```sql
mysql -uroot -p
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'yundait@2022' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

注意：远程访问的密码与前面设置的密码可以不同，远程访问时以远程访问密码为准**

## 修改配置

```bash
vim /etc/my.cnf.d/server.cnf
```

在[server]下添加如下内容，第二行的端口号改为非默认端口，与防火墙设置一致

```bash
max_allowed_packet = 32M                              # MySQL可接受的数据包大小
port = 3306                                           # MySQL端口号
lower_case_table_names=1                              # 所有表名小写
innodb_flush_log_at_trx_commit=2                      # innodb硬盘刷新机制
character-set-server=utf8mb4                          # 默认字符集
collation-server=utf8mb4_general_ci                   # 默认字符描述规则
sql_mode=NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION   # 更改校验模式
```

重启MariaDB

```bash
systemctl restart mariadb
```

## 设置开机启动MariaDB

```bash
systemctl enable mariadb
```

# 安装PHP

## 安装PHP 7.2

```bash
yum install --enablerepo=remi --enablerepo=remi-php73 php php-cli php-common php-devel php-embedded php-fpm php-gd php-mbstring php-mysqlnd php-opcache php-pdo php-xml php-process php-mcrypt php-pecl-zip -y
```

## 启动php-fpm

```bash
systemctl start php-fpm
```

## 设置开机启动php-fpm

```bash
systemctl enable php-fpm
```

## 设置php.ini

- 打开配置文件

```bash
vim /etc/php.ini
```

- 修改配置

```bash
expose_php = On
改为
expose_php = Off
```

# 安装apache

## 安装apache

在php安装过程中将会安装apache，也可以执行如下语句安装

```bash
yum install httpd -y
```

## 修改apache配置

- 打开apache配置文件

```bash
vim /etc/httpd/conf/httpd.conf
```

- 修改配置文件

| **修改前** | **修改后** | **说明** |
| --- | --- | --- |
| AllowOverride None | AllowOverride All | 允许.htaccess |
| DirectoryIndex index.html | DirectoryIndex index.html index.php | 设置默认首页文件，增加index.php |
| 新增 | TraceEnable off | 关闭TraceEnable |
| 新增 | ServerTokens Prod ServerSignature off | 关闭apache版本显示 |
| 注释 | <Directory "/var/www/cgi-bin"> AllowOverride All Options None Require all granted | 取消/cgi-bin路径的浏览 |
- 打开apache autoindex配置文件

```bash
vim /etc/httpd/conf.d/autoindex.conf
```

- 修改配置文件
- 注释

```bash
Alias /icons/ "/usr/share/httpd/icons/"
<Directory "/usr/share/httpd/icons">
    Options Indexes MultiViews FollowSymlinks
    AllowOverride None
    Require all granted
</Directory>
```

## 重启apache

```bash
systemctl restart httpd
```

## 设置开机启动apache

```bash
systemctl enable httpd
```

# 安装nginx

nginx与apache同为web容器，两者安装一个即可，如果确实有需要同时安装，需要修改默认端口号

## 安装nginx

```bash
yum install nginx -y
```

## 编辑配置文件

- 打开配置文件

```bash
vim /etc/nginx/nginx.conf
```

- 修改配置文件

在http标签最后添加如下内容

```bash
server {
    listen       80 default_server;
    listen       [::]:80 default_server;

    # 这里改动了，也可以写你的域名
    server_name  localhost;
    root         /usr/share/nginx/html;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;
    location / {
        # 这里改动了定义首页索引文件的名称
        index index.php index.html index.htm;
    }
    error_page 404 /404.html;
    location = /40x.html {
    }
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
    }

    # 这里新加的
    # PHP 脚本请求全部转发到 FastCGI处理. 使用FastCGI协议默认配置.
    # Fastcgi服务器和程序(PHP,Python)沟通的协议.
    location ~ \.php$ {
        # 设置监听端口
        fastcgi_pass   127.0.0.1:9000;

        # 设置nginx的默认首页文件(上面已经设置过了，可以删除)
        fastcgi_index  index.php;

        # 设置脚本文件请求的路径
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;

        # 引入fastcgi的配置文件
        include        fastcgi_params;
    }
}
```

## 重启nginx

```bash
systemctl restart nginx
```

## 设置开机启动nginx

```bash
systemctl enable nginx
```

# 安装redis

## 安装redis

```bash
yum install redis -y
```

# 安装Java

## 安装openjdk

```bash
yum install java-1.8.0-openjdk -y
```