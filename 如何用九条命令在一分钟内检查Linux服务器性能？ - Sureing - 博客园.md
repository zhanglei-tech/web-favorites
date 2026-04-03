# 如何用九条命令在一分钟内检查Linux服务器性能？ - Sureing - 博客园
**一、uptime命令**
--------------

**\# uptime**

```
[root@centos7 ~]# uptime 
 14:17:46 up  3:58,  3 users,  load average: 0.00, 0.01, 0.05 
```

这个命令可以快速查看机器的**负载情况**。在Linux系统中，这些数据表示等待CPU资源的进程和阻塞在不可中断IO进程（进程状态为D）的数量。这些数据可以让我们对系统资源使用有一个宏观的了解。

命令的输出分别表示1分钟、5分钟、15分钟的平均负载情况。通过这三个数据，可以了解服务器负载是在趋于紧张还是趋于缓解。如果1分钟平均负载很高，而15分钟平均负载很低，说明服务器正在命令高负载情况，需要进一步排查CPU资源都消耗在了哪里。反之，如果15分钟平均负载很高，1分钟平均负载较低，则有可能是CPU资源紧张时刻已经过去。

上面例子中的输出，可以看见最近1分钟的平均负载非常高，且远高于最近15分钟负载，因此我们需要继续排查当前系统中有什么进程消耗了大量的资源。可以通过下文将会介绍的vmstat、mpstat等命令进一步排查。

**二、dmesg命令**
-------------

**\# dmesg | tail**

```
[root@centos7 ~]# dmesg |tail
[   23.844720] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.848463] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   23.857935] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   23.861629] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[ 1248.092396] ISO 9660 Extensions: Microsoft Joliet Level 3
[ 1248.112365] ISO 9660 Extensions: RRIP_1991A
[ 2368.001986] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[ 2368.005495] Bridge firewalling registered
[ 2368.027379] nf_conntrack version 0.5.0 (7812 buckets, 31248 max)
[ 2368.237314] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready 
```

该命令会输出**系统日志**的最后10行。示例中的输出，可以看见一次内核的oom kill和一次TCP丢包。这些日志可以帮助排查性能问题。千万不要忘了这一步。

**三、vmstat命令**
--------------

**\# vmstat 1**

```
[root@centos7 ~]# vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 467048    948 417452    0    0    14    14   37   78  0  0 99  0  0
 0  0      0 467032    948 417452    0    0     0     0   51  111  0  0 100  0  0
 0  0      0 467032    948 417452    0    0     0     0   59  114  0  0 100  0  0
 0  0      0 467032    948 417452    0    0     0     0   48   99  0  1 99  0  0
 0  0      0 467032    948 417452    0    0     0    33   58  119  0  0 100  0  0
^C 
```

vmstat(8) 命令，每行会输出一些**系统核心指标**，这些指标可以让我们更详细的了解系统状态。后面跟的参数1，表示每秒输出一次统计信息，表头提示了每一列的含义，这几介绍一些和性能调优相关的列：

*   **r**：等待在CPU资源的**进程数**。这个数据比平均负载更加能够体现CPU负载情况，数据中不包含等待IO的进程。如果这个数值大于机器CPU核数，那么机器的CPU资源已经饱和。
*   **free**：系统可用**内存数**（以千字节为单位），如果剩余内存不足，也会导致系统性能问题。下文介绍到的free命令，可以更详细的了解系统内存的使用情况。
*   **si，so**：交换区**写入和读取的数量**。如果这个数据不为0，说明系统已经在使用交换区（swap），机器物理内存已经不足。
*   **us, sy, id, wa, st**：这些都代表了**CPU时间的消耗**，它们分别表示用户时间（user）、系统（内核）时间（sys）、空闲时间（idle）、IO等待时间（wait）和被偷走的时间（stolen，一般被其他虚拟机消耗）。

上述这些CPU时间，可以让我们很快了解CPU是否出于繁忙状态。一般情况下，如果用户时间和系统时间相加非常大，CPU出于忙于执行指令。如果IO等待时间很长，那么系统的瓶颈可能在磁盘IO。

示例命令的输出可以看见，大量CPU时间消耗在用户态，也就是用户应用程序消耗了CPU时间。这不一定是性能问题，需要结合r队列，一起分析。

**四、mpstat命令**
--------------

1、下载此命令

\[root@centos7 ~\]# yum -y install sysstat

2、命令用法展示

**\# mpstat -P ALL 1**

```
[root@centos7 ~]# mpstat -P ALL 1
Linux 3.10.0-514.el7.x86_64 (centos7)     05/15/2018     _x86_64_    (1 CPU)

02:23:08 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
02:23:09 PM  all    0.00    0.00    0.99    0.00    0.00    0.00    0.00    0.00    0.00   99.01
02:23:09 PM    0    0.00    0.00    0.99    0.00    0.00    0.00    0.00    0.00    0.00   99.01

02:23:09 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
02:23:10 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
02:23:10 PM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00

02:23:10 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
02:23:11 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
02:23:11 PM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00 
```

该命令可以显示**每个CPU的占用情况**，如果有一个CPU占用率特别高，那么有可能是一个单线程应用程序引起的。

**五、pidstat命令**
---------------

**\# pidstat 1**

```
[root@centos7 ~]# pidstat 1
Linux 3.10.0-514.el7.x86_64 (centos7)     05/15/2018     _x86_64_    (1 CPU)

02:23:40 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:23:41 PM     0     14039    0.00    0.98    0.00    0.98     0  pidstat

02:23:41 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:23:42 PM     0     14039    0.00    1.01    0.00    1.01     0  pidstat

02:23:42 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command

02:23:43 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:23:44 PM     0       592    1.03    0.00    0.00    1.03     0  vmtoolsd
02:23:44 PM     0     14039    0.00    1.03    0.00    1.03     0  pidstat

02:23:44 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:23:45 PM     0      2178    0.00    1.00    0.00    1.00     0  kworker/0:1
02:23:45 PM     0     14039    0.00    1.00    0.00    1.00     0  pidstat

02:23:45 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:23:46 PM     0     14039    1.01    1.01    0.00    2.02     0  pidstat

02:23:46 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:23:47 PM     0     14039    0.00    0.99    0.00    0.99     0  pidstat

02:23:47 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:23:48 PM     0       894    1.02    0.00    0.00    1.02     0  tuned 
```

pidstat命令输出**进程的CPU占用率**，该命令会持续输出，并且不会覆盖之前的数据，可以方便观察系统动态。如上的输出，可以看见两个JAVA进程占用了将近1600%的CPU时间，既消耗了大约16个CPU核心的运算资源。

**六、iostat命令**
--------------

**\# iostat -xz 1**

```
[root@centos7 ~]# iostat -xz 1
Linux 3.10.0-514.el7.x86_64 (centos7)     05/15/2018     _x86_64_    (1 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.17    0.01    0.29    0.12    0.00   99.41

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.17    0.69    0.31    13.46    14.49    56.25     0.04   35.65    5.14  104.52   3.59   0.36
scd0              0.00     0.00    0.10    0.00     0.40     0.00     7.99     0.00    1.32    1.32    0.00   1.31   0.01
dm-0              0.00     0.00    0.54    0.48    12.99    14.35    53.99     0.06   55.24    4.36  112.41   2.38   0.24
dm-1              0.00     0.00    0.01    0.00     0.07     0.00    16.69     0.00    0.23    0.23    0.00   0.23   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.00    0.00    0.00  100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.99    0.00    0.00   99.01

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.00    0.00    0.00  100.00 
```

*   **r/s, w/s, rkB/s, wkB/s**：分别表示**每秒读写次数和每秒读写数据量**（千字节）。读写量过大，可能会引起性能问题。
*   **await**：**IO操作的平均等待时间**，单位是毫秒。这是应用程序在和磁盘交互时，需要消耗的时间，包括IO等待和实际操作的耗时。如果这个数值过大，可能是硬件设备遇到了瓶颈或者出现故障。
*   **avgqu-sz**：向设备发出的**请求平均数量**。如果这个数值大于1，可能是硬件设备已经饱和（部分前端硬件设备支持并行写入）。
*   **%util：设备利用率**。这个数值表示设备的繁忙程度，经验值是如果超过60，可能会影响IO性能（可以参照IO操作平均等待时间）。如果到达100%，说明硬件设备已经饱和。

如果显示的是逻辑设备的数据，那么设备利用率不代表后端实际的硬件设备已经饱和。值得注意的是，即使IO性能不理想，也不一定意味这应用程序性能会不好，可以利用诸如预读取、写缓存等策略提升应用性能。

**七、free命令**
------------

**\# free -m**

```
[root@centos7 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:            976         112         451          18         412         648
Swap:          2047           0        2047 
```

free命令可以查看**系统内存**的使用情况，-m参数表示按照兆字节展示。最后两列分别表示用于IO缓存的内存数，和用于文件系统页缓存的内存数。需要注意的是，第二行-/+ buffers/cache，看上去缓存占用了大量内存空间。

这是Linux系统的内存使用策略，尽可能的利用内存，如果应用程序需要内存，这部分内存会立即被回收并分配给应用程序。因此，这部分内存一般也被当成是可用内存。

如果可用内存非常少，系统可能会动用交换区（如果配置了的话），这样会增加IO开销（可以在iostat命令中提现），降低系统性能。

**八、sar命令**
-----------

**1、# sar -n DEV 1**

```
[root@centos7 ~]# sar -n DEV 1
Linux 3.10.0-514.el7.x86_64 (centos7)     05/15/2018     _x86_64_    (1 CPU)

02:25:38 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
02:25:39 PM      eth0      1.00      1.00      0.06      0.18      0.00      0.00      0.00
02:25:39 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:39 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:39 PM   docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00

02:25:39 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
02:25:40 PM      eth0      1.02      1.02      0.06      0.58      0.00      0.00      0.00
02:25:40 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:40 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:40 PM   docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00

02:25:40 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
02:25:41 PM      eth0      1.01      1.01      0.06      0.58      0.00      0.00      0.00
02:25:41 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:41 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:41 PM   docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00

02:25:41 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
02:25:42 PM      eth0      0.99      0.99      0.06      0.57      0.00      0.00      0.00
02:25:42 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:42 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
02:25:42 PM   docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00 
```

sar命令在这里可以查看**网络设备的吞吐率**。在排查性能问题时，可以通过网络设备的吞吐量，判断网络设备是否已经饱和。如示例输出中，eth0网卡设备，吞吐率大概在22 Mbytes/s，既176 Mbits/sec，没有达到1Gbit/sec的硬件上限。

**2、# sar -n TCP,ETCP 1**

```
[root@centos7 ~]# sar -n TCP,ETCP 1
Linux 3.10.0-514.el7.x86_64 (centos7)     05/15/2018     _x86_64_    (1 CPU)

02:26:21 PM  active/s passive/s    iseg/s    oseg/s
02:26:22 PM      0.00      0.00      1.01      1.01

02:26:21 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
02:26:22 PM      0.00      0.00      0.00      0.00      0.00

02:26:22 PM  active/s passive/s    iseg/s    oseg/s
02:26:23 PM      0.00      0.00      0.99      0.99

02:26:22 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
02:26:23 PM      0.00      0.00      0.00      0.00      0.00

02:26:23 PM  active/s passive/s    iseg/s    oseg/s
02:26:24 PM      0.00      0.00      1.01      1.01

02:26:23 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
02:26:24 PM      0.00      0.00      0.00      0.00      0.00

02:26:24 PM  active/s passive/s    iseg/s    oseg/s
02:26:25 PM      0.00      0.00      1.02      1.02 
```

sar命令在这里用于查看**TCP连接状态**，其中包括：

*   active/s：每秒本地发起的TCP连接数，既通过connect调用创建的TCP连接；
*   passive/s：每秒远程发起的TCP连接数，即通过accept调用创建的TCP连接；
*   retrans/s：每秒TCP重传数量；

TCP连接数可以用来判断性能问题是否由于建立了过多的连接，进一步可以判断是主动发起的连接，还是被动接受的连接。TCP重传可能是因为网络环境恶劣，或者服务器压

**九、top命令**
-----------

**\# top**

```
[root@centos7 ~]# top
top - 14:28:13 up  4:08,  3 users,  load average: 0.00, 0.01, 0.05
Tasks:  94 total,   1 running,  93 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.2 us,  0.3 sy,  0.0 ni, 99.4 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :   999936 total,   463864 free,   115036 used,   421036 buff/cache
KiB Swap:  2097148 total,  2097148 free,        0 used.   664372 avail Mem 

   PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND                                                        
  2178 root      20   0       0      0      0 S  6.2  0.0   0:18.69 kworker/0:1                                                    
     1 root      20   0  125160   3700   2416 S  0.0  0.4   0:01.68 systemd                                                        
     2 root      20   0       0      0      0 S  0.0  0.0   0:00.00 kthreadd                                                       
     3 root      20   0       0      0      0 S  0.0  0.0   0:00.73 ksoftirqd/0                                                    
     6 root      20   0       0      0      0 S  0.0  0.0   0:00.90 kworker/u256:0                                                 
     7 root      rt   0       0      0      0 S  0.0  0.0   0:00.00 migration/0                                                    
     8 root      20   0       0      0      0 S  0.0  0.0   0:00.00 rcu_bh                                                         
     9 root      20   0       0      0      0 S  0.0  0.0   0:00.60 rcu_sched                                                      
    10 root      rt   0       0      0      0 S  0.0  0.0   0:00.13 watchdog/0                                                     
    12 root       0 -20       0      0      0 S  0.0  0.0   0:00.00 khelper                                                        
    13 root      20   0       0      0      0 S  0.0  0.0   0:00.00 kdevtmpfs                                                      
    14 root       0 -20       0      0      0 S  0.0  0.0   0:00.00 netns                                                          
    15 root      20   0       0      0      0 S  0.0  0.0   0:00.00 khungtaskd                                                     
    16 root       0 -20       0      0      0 S  0.0  0.0   0:00.00 writeback                                                      
    17 root       0 -20       0      0      0 S  0.0  0.0   0:00.00 kintegrityd                                                    
    18 root       0 -20       0      0      0 S  0.0  0.0   0:00.00 bioset 
```

top命令包含了前面好几个命令的检查的内容。比如系统负载情况（uptime）、系统内存使用情况（free）、系统CPU使用情况（vmstat）等。因此通过这个命令，可以相对**全面的查看系统负载的来源**。同时，top命令支持排序，可以按照不同的列排序，方便查找出诸如内存占用最多的进程、CPU占用率最高的进程等。

但是，top命令相对于前面一些命令，输出是一个瞬间值，如果不持续盯着，可能会错过一些线索。这时可能需要暂停top命令刷新，来记录和比对数据。

转载自 [http://blog.51cto.com/mageedu/1979332](http://blog.51cto.com/mageedu/1979332) 马哥Linux