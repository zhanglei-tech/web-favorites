# CentOS7新增磁盘分区、格式化、挂载

- CentOS7新增磁盘分区、格式化、挂载
- 在对新增加的硬盘分区之前，先查看硬盘信息
- 可以看到有两块硬盘/dev/sda和/dev/sdb
- 其中/dev/sdb是我们新增的第二块硬盘。

```bash
[root@moonyun ~]# fdisk -l

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000ea002

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    41943039    19921920   8e  Linux LVM

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/mapper/cl-root: 18.2 GB, 18249416704 bytes, 35643392 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/mapper/cl-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

[root@moonyun ~]#

```

下面进行分区的相关操作

### 1.创建分区

```bash
[root@moonyun ~]# fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x0e2b08bb.

```

1）创建新分区

2）选择分区类型，创建主分区

3）选择分区编号

4）选择默认初始磁柱编号2048

5）选择默认截止磁柱编号+10G

6）查看新建分区的详细信息

7）更改分区类型

8）将分区结果写入分区表中

```bash
Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended

Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-41943039, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): +10G
Partition 1 of type Linux and of size 10 GiB is set

Command (m for help): p

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0e2b08bb

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    20973567    10485760   83  Linux

Command (m for help): t
Partition number (1,2, default 2): 1
Hex code (type L to list all codes): L

 0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden C:  c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx
 5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data
 6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt
 9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access
 a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi eb  BeOS fs
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         ee  GPT
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ef  EFI (FAT-12/16/
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        f0  Linux/PA-RISC b
11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f1  SpeedStor
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f4  SpeedStor
14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f2  DOS secondary
16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      fb  VMware VMFS
17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE
18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fd  Linux raid auto
1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fe  LANstep
1c  Hidden W95 FAT3 75  PC/IX           be  Solaris boot    ff  BBT
1e  Hidden W95 FAT1 80  Old Minix
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@moonyun ~]#

```

### 2.激活分区

```bash
[root@moonyun ~]# partprobe /dev/sdb
[root@moonyun ~]#

```

### 3.格式化分区

```bash
[root@moonyun ~]# mkfs
mkfs         mkfs.cramfs  mkfs.ext3    mkfs.fat     mkfs.msdos   mkfs.xfs

mkfs.btrfs   mkfs.ext2    mkfs.ext4    mkfs.minix   mkfs.vfat

[root@moonyun ~]# mkfs.xfs /dev/sdb1
meta-data=/dev/sdb1              isize=512    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@moonyun ~]#

```

### 4.建立挂载点

```bash
[root@moonyun ~]# mkdir /mydata

```

### 5.进行挂载并查看

```bash
[root@moonyun /]# mount /dev/sdb1 /mydata
[root@moonyun /]#
[root@moonyun /]# df -TH
Filesystem          Type      Size  Used Avail Use% Mounted on
/dev/mapper/cl-root xfs        19G  4.6G   14G  25% /
devtmpfs            devtmpfs  496M     0  496M   0% /dev
tmpfs               tmpfs     512M  144k  512M   1% /dev/shm
tmpfs               tmpfs     512M  7.5M  505M   2% /run
tmpfs               tmpfs     512M     0  512M   0% /sys/fs/cgroup
/dev/sda1           xfs       1.1G  181M  883M  18% /boot
tmpfs               tmpfs     103M   37k  103M   1% /run/user/0
/dev/sdb1           xfs        11G   34M   11G   1% /mydata
[root@moonyun /]#

```

表示新建分区“/dev/sdb1”已挂载至“/mydata”。

### 6.设置开机自动挂载磁盘

1）查询磁盘UUID

```bash
[root@moonyun /]# blkid /dev/sdb1
/dev/sdb1: UUID="3a6a067d-f28f-495c-9651-d5df6e13072d" TYPE="xfs"
[root@moonyun /]#

```

2）vim编辑/etc/fstab

UUID=3a6a067d-f28f-495c-9651-d5df6e13072d /mydata xfs defaults 0 2

保存退出。

### 7.重启服务器测试

```bash
[root@moonyun /]# df -TH
Filesystem          Type      Size  Used Avail Use% Mounted on
/dev/mapper/cl-root xfs        19G  4.6G   14G  25% /
devtmpfs            devtmpfs  496M     0  496M   0% /dev
tmpfs               tmpfs     512M  144k  512M   1% /dev/shm
tmpfs               tmpfs     512M  7.5M  505M   2% /run
tmpfs               tmpfs     512M     0  512M   0% /sys/fs/cgroup
/dev/sda1           xfs       1.1G  181M  883M  18% /boot
tmpfs               tmpfs     103M   37k  103M   1% /run/user/0
/dev/sdb1           xfs        11G   34M   11G   1% /mydata
[root@moonyun /]#

```

可以看出已经自动挂载了。

附：自动挂载的两种方式UUID和/dev/sdb1，倒数第二行和第一行重复，做注。

```bash
#
# /etc/fstab
# Created by anaconda on Thu Mar 29 07:31:38 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/cl-root     /                       xfs     defaults        0 0
UUID=d91cdedb-618a-46d6-8daa-f8c0d071c272 /boot                   xfs     defaults        0 0
/dev/mapper/cl-swap     swap                    swap    defaults        0 0
#UUID=3a6a067d-f28f-495c-9651-d5df6e13072d /mydata xfs defaults 0 2
/dev/sdb1  /mydata xfs defaults 0 2

```