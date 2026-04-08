# OPC和DCOM配置 - ioufev - 博客园
本文为[Java实现OPC通信](https://www.cnblogs.com/ioufev/p/9928971.html)的一部分

系统：使用win10 64位专业版

> PDF文件：
> 
> *   [本文](https://ioufev.lanzoui.com/iase3xi)，链接:  [百度网盘](https://pan.baidu.com/s/1445ecO3jvL4C4Kg9mKH2eg) 密码: reht，
> *   [Win7和Win7\_SP1网络OPC配置](https://ioufev.lanzoui.com/iase3hc)，链接:  [百度网盘](https://pan.baidu.com/s/1eh7kwAr14wVgHsWFRuGgwg) 密码: dhhc
> 
> 在线参考：英文的
> 
> *   [参考1](https://www.softwaretoolbox.com/dcom/html/dcom_for_windows_7-_10-_-_server_2008r2.html)
> *   [参考2](http://www.aggsoft.com/asdl-dcom-opc-config-windows-8-2012-1.htm)

1.准备
----

### 1.1 OPC运行库

KEPServer集成了OPC运行库，所以不需要单独安装

### 1.2 创建用户并赋予访问权限 ：计算机管理

创建用户：

    OPCUser

    123456

添加到DCOM组

说明：如果用户权限复杂，请用能登陆OPCServer的用户。

2.配置说明
------

### 2.1 防火墙关于 DCOM 和 OPC 的规则 ：高级安全 Windows Defender 防火墙

开放 DCOM 访问 ：DCOM（wmi）启用

135端口：只有一个计算机不需要设置

创建 OPC 程序规则 ：允许程序 OPCEnum（就是OPC运行库的程序）

　　位置："C:\\Windows\\SysWOW64\\OpcEnum.exe"

添加 OPC 服务器程序的规则：允许程序 KEPServer的server\_runtime

　　位置："C:\\Program Files (x 86) \\Kepware\\KEPServerEX 6\\server\_runtime.exe"

说明：如果使用了防火墙软件，请把这2条规则添加到白名单。

### 2.2 配置 DCOM 安全：组件服务

配置 COM 的安全设置：我的电脑--COM属性--安全--访问、激活 配置

配置 OPCEnum 的安全设置 ：OpcEnum的安全选项

配置 OPCServer 的安全设置 ：KEPServer的安全选项

### 2.3 配置本地安全策略 ：

本地安全策略 本地策略--网络访问--匿名 ：启用

### 2.4.关于Matrikon的DCOM配置

创建用户-->添加到DCOM组

高级安全 Windows Defender 防火墙：创建 OPC 程序规则 ：允许程序 OPCEnum

　　位置："C:\\Windows\\SysWOW64\\OpcEnum.exe"

如果还不行，可以将OPCSim加入防火墙

　　位置："C:\\Program Files (x86)\\Matrikon\\OPC\\Simulation\\OPCSim.exe"

其他不需要了。

3.用户
----

### 3.1 创建用户

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150214227-213513020.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150226575-1157935572.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150239646-1843482870.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150247595-1289559223.png)

### 3.2添加到DCOM组

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150257757-1906087088.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150305927-1911226469.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150313316-1418568002.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150322797-991561663.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150328677-23773298.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150336158-982569357.png)

 ![](https://img2018.cnblogs.com/blog/1049945/201906/1049945-20190612080856568-45807046.png)

4.防火墙
-----

### 4.1 配置防火墙规则：开放 DCOM 访问

**打开防火墙**

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150346719-992012715.png)

找到（DCOM-In）

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150355139-1977231227.png)

**右键属性--已启用**

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150404338-1397213223.png)

### 4.2 创建 OPC 程序规则 ：允许程序 OPCEnum

**新建入站规则--程序--找到OpcEnum.exe**

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150427969-997701455.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150436869-525192611.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150443929-1116056650.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150450592-897827052.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150458040-396448522.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150508960-2136460133.png)

### 4.3 添加 OPC 服务器程序的规则：允许程序 KEPServer的server\_runtime

**新建入站规则--程序--找到server\_runtime.exe**

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150517372-1269468718.png)

5.组件服务
------

### 5.1组件服务：配置 COM 的安全设置

**打开组件服务**

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150548192-1115719835.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150607631-1145943997.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150616753-471767266.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150624413-1302316481.png)

### 5.2组件服务：OpcEnum的安全选项

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150634878-58835740.png)

**详细信息**

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150531176-1329903269.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150654214-2079668875.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150643444-2044469299.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150702284-1907040866.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150709804-1416995601.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150717725-1057624058.png)

### 5.3组件服务：KEPServer的安全选项

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150725025-1356056267.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150730505-821408659.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150742126-1633576908.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150748277-1390914305.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150755657-122688539.png)

6.本地安全策略
--------

### 6.1本地安全策略 本地策略--网络访问--匿名 ：启用

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150802417-1246917294.png)

![](https://images2018.cnblogs.com/blog/1049945/201807/1049945-20180725150814088-542774022.png)

补充
--

> [#77楼](https://www.cnblogs.com/ioufev/p/9928971.html#4851192) 

> **测试 utgard 时，操作系统请使用 win10 1909 及以前的版本。** 
> 
> 测试可以通信
> 
> *   win10专业版 1903
> *   win10专业版 1909
> *   win11专业版 21H2

> 搜了一下原因  
> 是因为微软为了修补 DCOM 的安全漏洞，发了更新补丁。
> 
> 2021年6月8日，微软发布了针对DCOM的Windows安全更新KB5004442（CVE-2021-26414）——强制更改了Windows操作系统DCOM安全机制。该更新要求DCOM应用程序提供“数据包完整性”身份验证级别，否则可能会出现无法兼容的问题。
> 
> 分布式组件对象模型（DCOM）远程协议是一种使用远程过程调用（RPC）公开应用程序对象的协议，它支持远程过程调用，并且可用于网络设备的软件组件之间的通信。

[KB5004442](https://support.microsoft.com/zh-cn/topic/kb5004442-%E7%AE%A1%E7%90%86-windows-dcom-server-%E5%AE%89%E5%85%A8%E5%8A%9F%E8%83%BD%E6%97%81%E8%B7%AF-cve-2021-26414-%E7%9A%84%E6%9B%B4%E6%94%B9-f1400b52-c141-43d2-941e-37ed901c769c)

会受影响操作系统版本

> 可用性
> 
> 这些错误事件仅适用于 Windows 版本的子集;请参阅下表。

| **Windows 版本** | **可在这些日期或之后使用** |
| --- | --- |
| Windows Server 2022 | 2021 年 9 月 27 日[KB5005619](https://support.microsoft.com/zh-cn/topic/2021-%E5%B9%B4-9-%E6%9C%88-27-%E6%97%A5-kb5005619-os-%E5%86%85%E9%83%A8%E7%89%88%E6%9C%AC-20348-261-%E9%A2%84%E8%A7%88%E7%89%88-d5416d34-e4b7-4680-8747-7e995515c791) |
| Windows 10版本 2004、Windows 10、版本 20H2、Windows 10、版本 21H1 | 2021 年 9 月 1 日[KB5005101](https://support.microsoft.com/zh-cn/topic/2021-%E5%B9%B4-9-%E6%9C%88-1-%E6%97%A5-kb5005101-os-%E5%86%85%E9%83%A8%E7%89%88%E6%9C%AC-19041-1202-19042-1202-%E5%92%8C-19043-1202-%E9%A2%84%E8%A7%88%E7%89%88-82a50f27-a56f-4212-96ce-1554e8058dc1) |
| Windows 10 版本 1909 | 2021 年 8 月 26 日[KB5005103](https://support.microsoft.com/zh-cn/topic/2021-%E5%B9%B4-8-%E6%9C%88-26-%E6%97%A5-kb5005103-os-%E5%86%85%E9%83%A8%E7%89%88%E6%9C%AC-18363-1766-%E9%A2%84%E8%A7%88%E7%89%88-4e23362c-5e43-4d8f-95e5-9fdade60605f) |
| Windows Server 2019、Windows 10 版本 1809 | 2021 年 8 月 26 日[KB5005102](https://support.microsoft.com/zh-cn/topic/2021-%E5%B9%B4-8-%E6%9C%88-26-%E6%97%A5-kb5005102-os-%E5%86%85%E9%83%A8%E7%89%88%E6%9C%AC-17763-2145-%E9%A2%84%E8%A7%88%E7%89%88-84c556d7-4a14-49d9-b1ba-35690209acd3) |
| Windows Server 2016、Windows 10 版本 1607 | 2021 年 9 月 14 日[KB5005573](https://support.microsoft.com/zh-cn/topic/2021-%E5%B9%B4-9-%E6%9C%88-14-%E6%97%A5-kb5005573-os-%E5%86%85%E9%83%A8%E7%89%88%E6%9C%AC-14393-4651-48853795-3857-4485-a2bf-f15b39464b41) |
| Windows Server 2012 R2 和 Windows 8.1 | 2021 年 10 月 12 日[KB5006714](https://support.microsoft.com/zh-cn/topic/2021-%E5%B9%B4-10-%E6%9C%88-12-%E6%97%A5-kb5006714-%E6%9C%88%E5%BA%A6%E6%B1%87%E6%80%BB-4dc4a2cd-677c-477b-8079-dcfef2bda09e) |
| Windows 11版本 22H2 | 2022 年 9 月 30 日[KB5017389](https://support.microsoft.com/zh-cn/topic/2022-%E5%B9%B4-9-%E6%9C%88-30-%E6%97%A5-kb5017389-os-%E5%86%85%E9%83%A8%E7%89%88%E6%9C%AC-22621-608-%E9%A2%84%E8%A7%88%E7%89%88-62f353a0-696a-49d8-a78f-a14910f30ae3) |