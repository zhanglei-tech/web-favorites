# CentOS7虚拟机扩磁盘

# 1、 虚拟机硬盘容量修改

虚拟机关机

[](https://eaae8z1e9oq.feishu.cn/space/api/box/stream/download/asynccode/?code=MGM2ZDFiZDQ0ODM4NmQ5M2YzNWVkOWFiZjhkYzRjZDZfNVQ2QjZEYkxlY082NUdRUkQ1VHRnUHZWUXRRVkpZWTJfVG9rZW46Q3d1eWJhbVRQbzQ2VW54ZFVvRmNZMVpjbnJjXzE3MDk3OTkxODM6MTcwOTgwMjc4M19WNA)

# 2、CentOS7扩容

## 1、 虚拟机硬盘容量修改

不同的软件有些不同这里不做说明

注意：此方法需要先删除所有快照，修改完硬盘大小重新做个快照，万一操作出错好恢复

## 2、centos7扩容

完成第一步后进系统查看空间使用情况

```bash
df -lH
```

可以看到可用容量并没有改变，用lsblk查看磁盘使用情况

这里要做的是扩充sda2的容量，网络上找到的一般是新增一个分区，然后扩容，我不太喜欢分区太多，所以只想简单的对sda2进行扩容。

扩容步骤 先删除sda2分区再重新创建，操作步骤如下：

### 修改分区表

fdisk /dev/sda

删除分区2：输入d回车=>2回车

创建分区2：输入n回车=>p回车=>2回车=>回车=>回车

输入w回车保存退出

### 更新内核内存分区表

partx -u /dev/sda

### 调整物理体积

pvresize /dev/sda2

重新lsblk进行查看，可以看到sda2已经扩容完成

### 调整LV和文件系统扩容

lvextend -r centos/root /dev/sda2

[](https://eaae8z1e9oq.feishu.cn/space/api/box/stream/download/asynccode/?code=ZmY1OTdlOTcxYzFiMTdmNGY1NzkwMDhhMDQ1NWViM2ZfeWVFak1sUUdQY3RtczFwaFpFT1h2czVuZ3p4MXZMUnpfVG9rZW46QjZqUWJJSkl2b3JWQWp4QVFZS2Mxa2w5bkpoXzE3MDk3OTkxODM6MTcwOTgwMjc4M19WNA)

lsblk查看可以看到centos-root已经扩容完成

[](https://eaae8z1e9oq.feishu.cn/space/api/box/stream/download/asynccode/?code=NzZlZjIzMDA0OGE1ZDJhYmE5NzQ4MDYyOTc0OTUwYzRfS0JNWlNnQVFHWmRoeFUwUkU1T2JGQmd3MlYzZFJxcEtfVG9rZW46RkVVNmJwQ0xub1BtT1Z4S2RucWNFeWlqbm5nXzE3MDk3OTkxODM6MTcwOTgwMjc4M19WNA)

df -lH 确认完成扩容

[](https://eaae8z1e9oq.feishu.cn/space/api/box/stream/download/asynccode/?code=NWQ0ODYxODdiN2EzNzA0NTExMWY5MTMzNTVlYTA3ZTBfYkZPTzJBRkh4UUo5eTFwZ1NxY3d6NFhzcXBrdGVXczNfVG9rZW46QmZnQmJYeklyb0IyNnN4ZHJIa2NnQ2xobmtoXzE3MDk3OTkxODM6MTcwOTgwMjc4M19WNA)