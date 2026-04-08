# CentOS7 服务器之间NFS文件共享挂载

# 目的

因为服务器设置了负载均衡，多服务器的文件上传必然要同步，这里的目的把服务器1设置为主文件服务器

服务器1：192.168.1.100（共享）

服务器2：192.168.1.20（挂载）

# 步骤

## 1、两台服务器都需要安装nfs以及依赖

- 安装nfs服务

```bash
yum install nfs-utils
```

- 开机启动服务

```bash
systemctl enable rpcbind.service
systemctl enable nfs.service
```

- 启动服务

```bash
systemctl start rpcbind.service
systemctl start nfs.service
```

## 2、在共享服务器中共享文件夹192.168.1.100（共享）

- 创建共享目录

```bash
mkdir /usr/local/test
```

- 编辑配置文件

```bash
vi /etc/exports
```

- 将这行添加到配置文件中保存

```bash
/usr/local/test/ 192.168.1.20(rw,no_root_squash,no_all_squash,sync)
```

- 重新启动rpcbind服务

```bash
systemctl restart rpcbind.service
```

设置固定端口：NFS每次启动的时候都是随机端口，这样可能被防火墙拦截，我们可以将其设置为固定端口，并放行：

- 编辑配置文件

```bash
vim /etc/sysconfig/nfs
```

- 将下面的内容添加到配置文件末尾

```bash
RQUOTAD_PORT="875"
LOCKD_TCPPORT="32803"
LOCKD_UDPPORT="32769"
MOUNTD_PORT="892"
```

- 端口设置好之后输入命令重启相关服务：

```bash
systemctl restart rpcbind.service
systemctl restart nfs.service
```

## 3、挂载服务器设置 192.168.1.20（挂载）

- 创建挂载目录

```bash
mkdir /usr/local/test
```

- 测试挂载

```bash
showmount -e 192.168.1.100
```

- 挂载

```bash
mount -t nfs 192.168.1.100:/usr/local/test /usr/local/test
```

## 4、开机自动挂载

如果需要设置开机自动挂载，那么将下面的信息添加到：/etc/fstab

- 编辑配置文件

```bash
vim /etc/fstab
```

- 将下面规则加入，IP和目录请自行调整

```bash
192.168.1.100:/usr/local/test   /usr/local/test   nfs  defaults  1  1
```