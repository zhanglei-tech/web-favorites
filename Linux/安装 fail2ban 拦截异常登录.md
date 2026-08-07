# ubuantu系统安装fail2ban
```shell
apt install fail2ban
```
# 创建 jail.local
```shell
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
Fail2ban 在启动时，会先读取 `jail.conf` 中的默认设置，然后再读取 `jail.local` 中的设置。如果在这两个文件中发现了相同的配置项，系统会优先使用 `jail.local` 里的设置。只需要在 `jail.local` 中写入你希望改变的那部分参数即可，其余未修改的参数会自动继承 `jail.conf` 的默认值，既安全又方便管理。
# 添加 ssh规则
编辑 `jail.local`，添加或修改以下内容：
```shell
[sshd] 
enabled = true 
port = 22222 # 如果你改了端口，这里要对应修改 
filter = sshd 
logpath = /var/log/auth.log # CentOS 可能是 /var/log/secure 
maxretry = 5 # 允许输错5次 
bantime = 3600 # 封禁时间(秒)，这里设为1小时 
findtime = 600 # 检测时间窗口(秒)
```
bantime 可以设置为