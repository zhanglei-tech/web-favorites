# CentOS7通过ISO文件制作yum源

# 步骤1：文件及文件夹准备

```bash
mkdir /media/CentOS7
```

上传文件到Linux文件系统中：/usr/installDir/iso/

# 步骤2：文件挂载

```bash
mount -t iso9660 -o loop /usr/installDir/iso/CentOS-7-x86_64-DVD-1708.iso /media/CentOS7
```

# 步骤3：修改fstab文件

```bash
vim /etc/fstab
```

```bash
#
# /etc/fstab
# Created by anaconda on Sun Nov  6 17:30:45 2016
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/centos-root                        /               xfs     defaults        0 0
UUID=7d81e893-ae46-4303-bd04-3573cb5b433e      /boot           xfs     defaults        0 0
/dev/mapper/centos-swap                        swap            swap    defaults        0 0
/usr/install/iso/CentOS-7-x86_64-DVD-1708.iso  /media/CentOS7/ xfs     defaults        0 0
```

# 步骤4：修改/etc/yum.repos.d/CentOS-Media.repo文件

## 操作1：修改CentOS-Media.repo

```bash
vim CentOS-Media.repo
```

```bash
# CentOS-Media.repo
#
#  This repo can be used with mounted DVD media, verify the mount point for
#  CentOS-7.  You can use this repo and yum to install items directly off the
#  DVD ISO that we release.
#
# To use this repo, put in your DVD and use it with the other repos too:
#  yum --enablerepo=c7-media [command]
#
# or for ONLY the media repo, do this:
#
#  yum --disablerepo=\* --enablerepo=c7-media [command]

[c7-media]
name=CentOS-$releasever - Media
baseurl=file:///media/CentOS7/
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

## 操作2：将其他xx.repo移动到backup文件夹

最后执行以下命令：

```bash
cd /etc/yum.repos.d
mkdir backup
mv *.repo ./backup/
mv ./backup/CentOS-Media.repo ./
```

```bash
yum clean all
yum update all
```

# 步骤5：安装测试

```bash
yum install -y gcc
```