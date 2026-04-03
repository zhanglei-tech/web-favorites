# windows远程桌面连接服务默认3389端口修改教程 - 知乎
w‌indows自带的[远程桌面连接](https://zhida.zhihu.com/search?content_id=262224439&content_type=Article&match_order=1&q=%E8%BF%9C%E7%A8%8B%E6%A1%8C%E9%9D%A2%E8%BF%9E%E6%8E%A5&zhida_source=entity)功能是比较常用的，远程访问管理另一台计算机操作，就像是本地操作一样，本身不用多余安装配置，非常方便管理计算机。默认远程桌面连接使用的是3389，如果长期开放远程使用的，建议修改其他端口号，避免被网络机器人扫描等风险。

修改Windows远程桌面端口的完整流程包含注册表调整、防火墙规则更新和远程服务重启‌，建议采用微软官方推荐的注册表修改方式确保系统兼容性。‌

一、‌远程桌面端口修改步骤‌
--------------

### 1、‌注册表配置‌

按下Win+R输入regedit打开[注册表编辑器](https://zhida.zhihu.com/search?content_id=262224439&content_type=Article&match_order=1&q=%E6%B3%A8%E5%86%8C%E8%A1%A8%E7%BC%96%E8%BE%91%E5%99%A8&zhida_source=entity)。

定位到以下两个路径并修改PortNumber值为新端口（如13389）：

HKEY\_LOCAL\_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\Wds\\rdpwd\\Tds\\tcp

HKEY\_LOCAL\_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\WinStations\\RDP-Tcp

修改时需确保选择「十进制」格式，端口号范围建议在1024-65535之间。‌‌

### 2、‌防火墙规则调整‌

打开「高级安全Windows Defender防火墙」。

禁用原3389端口的入站规则（若存在预定义规则）。

新建入站规则：选择「端口」→「TCP」→输入新端口号→允许连接→命名规则（如"远程桌面13389"）。‌‌

### 3、‌服务生效与验证‌

重启计算机或通过服务管理器重启[Remote Desktop Services](https://zhida.zhihu.com/search?content_id=262224439&content_type=Article&match_order=1&q=Remote+Desktop+Services&zhida_source=entity)服务。

使用命令netstat -ano | findstr :新端口号验证端口状态。

远程连接时需附加端口号（如192.168.1.100:13389）。‌‌

二、‌修改远程桌面端口注意事项‌
----------------

修改前需确认新端口未被其他服务占用（可通过netstat -ano检测）。

Windows Server 2019/2022及Windows 11需管理员权限操作注册表。

使用第三方工具（如系统远程端口修改器）时，应选择数字签名验证的官方版本，避免安全风险。‌‌

### 若修改后无法连接，可检查：

防火墙入站规则是否启用新端口。

注册表两处路径是否同步修改。

远程桌面服务是否正常启动。

### 端口安全强化‌：

避免使用3389、80、443等常见端口。

建议使用5位数的非常用端口（如54321）。

三、‌外网电脑远程桌面连接内网计算机
------------------

如果需要将本地计算机的远程桌面连接提供外地电脑远程访问，则需要配置对应路由器设置或[端口映射工具](https://zhida.zhihu.com/search?content_id=262224439&content_type=Article&match_order=1&q=%E7%AB%AF%E5%8F%A3%E6%98%A0%E5%B0%84%E5%B7%A5%E5%85%B7&zhida_source=entity)实现。

### 方法一，路由转发让外地远程桌面连接进来

当本地有路由权限，且有公网IP时，需在路由器配置端口映射，将公网端口（如23389）映射到内网新端口。‌‌

1.登录路由器管理界面（通常地址为192.168.1.1）。

2.在“虚拟服务器”或“端口转发”中添加规则：

外部端口（如33890）映射到内网IP（如192.168.1.100）的远程桌面端口（默认3389或自定义端口）。

3.‌外网连接‌：需通过公网IP和映射端口（如<公网IP>:33890）。

### 方法二，端口映射工具自定义域名端口绑定远程端口

原理是借助端口映射软件，将远程连接的内网IP转换成公网地址。以大众化[nat123](https://zhida.zhihu.com/search?content_id=262224439&content_type=Article&match_order=1&q=nat123&zhida_source=entity)映射工具为示例，操作步骤如下参考：

1.测试内网远程。确保在局域网内可以正常远程访问。

2.内网映射设置。在目标内网计算机本地使用nat123客户端添加映射，选择非网站类型，并自定义好对应内外网地址。通常可以使用自己域名或自动生成的二级域名，来作为外网地址。

3.外网远程连接。在异地其他网络下，打开远程桌面界面时，输入对应映射域名和外网端口号，进行远程登录操作。