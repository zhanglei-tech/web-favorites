# CentOS7安装vsftp

# 准备工作

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

- 添加修改后的ftp端口

```bash
firewall-cmd --add-port=32021/tcp --permanent
```

- 刷新firewall规则

```bash
firewall-cmd --reload
```

# 安装vsftp编辑本段

## 安装vsftp

```bash
yum install -y vsftpd
```

## 安装vsftpd虚拟用户配置依赖包

```bash
yum install -y psmisc net-tools systemd-devel libdb-devel perl-DBI
```

# 配置vsftp

## 备份配置文件

```bash
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf-bak
```

## 设置配置文件

```bash
sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#chown_uploads=YES/chown_uploads=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#async_abor_enable=YES/async_abor_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_upload_enable=YES/ascii_upload_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_download_enable=YES/ascii_download_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to FTP service./g" '/etc/vsftpd/vsftpd.conf'
echo -e "use_localtime=YES\n" >> /etc/vsftpd/vsftpd.conf
echo -e "listen_port=32021\n" >> /etc/vsftpd/vsftpd.conf
echo -e "chroot_local_user=YES\n" >> /etc/vsftpd/vsftpd.conf
echo -e "idle_session_timeout=300\n" >> /etc/vsftpd/vsftpd.conf
echo -e "data_connection_timeout=1\n" >> /etc/vsftpd/vsftpd.conf
echo -e "guest_enable=YES\n" >> /etc/vsftpd/vsftpd.conf
echo -e "guest_username=apache\n" >> /etc/vsftpd/vsftpd.conf
echo -e "user_config_dir=/etc/vsftpd/vconf\n" >> /etc/vsftpd/vsftpd.conf
echo -e "virtual_use_local_privs=YES\n" >> /etc/vsftpd/vsftpd.conf
echo -e "allow_writeable_chroot=YES\n" >> /etc/vsftpd/vsftpd.conf
echo -e "pasv_min_port=40000\n" >> /etc/vsftpd/vsftpd.conf
echo -e "pasv_max_port=41000\n" >> /etc/vsftpd/vsftpd.conf
echo -e "accept_timeout=5\n" >> /etc/vsftpd/vsftpd.conf
echo -e "connect_timeout=1" >> /etc/vsftpd/vsftpd.conf
```

# 虚拟用户配置

## 建立虚拟用户名单文件

```bash
touch /etc/vsftpd/virtusers
```

## 编辑虚拟用户名单文件

### 打开配置文件

```bash
vim /etc/vsfptd/virtusers
```

### 配置虚拟用户

第一行账号，第二行密码，注意：不能使用root做用户名，系统保留

```
web
123456
```

### 生成虚拟用户数据文件

```bash
db_load -T -t hash -f /etc/vsftpd/virtusers /etc/vsftpd/virtusers.db
chmod 600 /etc/vsftpd/virtusers.db
```

### 备份pam中vsftpd

```bash
cp /etc/pam.d/vsftpd /etc/pam.d/vsftpdbak
```

### 修改pam中vsftpd

```bash
vim /etc/pam.d/vsftpd
```

- 在文件头部加入以下信息

```bash
auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusersaccount sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusers
```

## 建立虚拟用户个人配置文件

```bash
mkdir /etc/vsftpd/vconf
cd /etc/vsftpd/vconf
touch web #每个虚拟用户创建一个配置文件
vim web
```

- 编辑用户web的配置文件，其他的跟这个配置文件类似

```
local_root=/var/www/html/
write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
allow_writeable_chroot=YES
```

# 启动vsftp

```bash
systemctl start vsftpd
```

# 设置开机启动vsftp

```bash
systemctl enable vsftpd
```