# Ubuntu 安装 fail2ban 拦截 SSH 异常登录

适用场景：Ubuntu 或 Debian 服务器，通过 fail2ban 自动封禁 SSH 暴力破解来源 IP。

## 安装

```shell
sudo apt update
sudo apt install -y fail2ban
```

## 创建本地配置

不建议直接改 `/etc/fail2ban/jail.conf`。更稳妥的做法是新建 `/etc/fail2ban/jail.local`，只写你需要覆盖的参数，方便后续升级和排查。

```shell
sudo nano /etc/fail2ban/jail.local
```

写入以下内容：

```ini
[DEFAULT]
# 白名单 IP，多个地址用空格分隔
ignoreip = 127.0.0.1/8 ::1

# 10 分钟内失败 5 次则封禁 1 小时
findtime = 10m
maxretry = 5
bantime = 1h

[sshd]
enabled = true
port = 22222
filter = sshd
logpath = /var/log/auth.log
```

说明：

- `port` 要和 `/etc/ssh/sshd_config` 里的实际 SSH 端口一致。
- Ubuntu/Debian 通常使用 `/var/log/auth.log`。
- 如果系统没有这个日志文件，可以改为使用 systemd 日志：

```ini
[sshd]
enabled = true
port = 22222
backend = systemd
```

## 启动并设置开机自启

```shell
sudo systemctl enable --now fail2ban
sudo systemctl restart fail2ban
```

## 检查配置是否生效

```shell
sudo fail2ban-client ping
sudo fail2ban-client status
sudo fail2ban-client status sshd
sudo systemctl status fail2ban
```

重点关注：

- `Status` 中是否能看到 `sshd` jail。
- `Currently banned` 是否大于 `0`。
- `Banned IP list` 中是否出现被封禁的来源地址。

## 添加 IP 白名单

在 `/etc/fail2ban/jail.local` 的 `[DEFAULT]` 段里追加自己的固定出口 IP，避免误封：

```ini
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1 1.2.3.4
```

如果有多个白名单 IP，继续用空格分隔：

```ini
ignoreip = 127.0.0.1/8 ::1 1.2.3.4 5.6.7.8
```

修改后重启：

```shell
sudo systemctl restart fail2ban
```

## 常用命令

查看 `sshd` 规则状态：

```shell
sudo fail2ban-client status sshd
```

手动解封某个 IP：

```shell
sudo fail2ban-client set sshd unbanip 1.2.3.4
```

重新加载配置：

```shell
sudo fail2ban-client reload
```

## 参数说明

- `findtime = 10m`：统计失败次数的时间窗口是 10 分钟。
- `maxretry = 5`：10 分钟内失败 5 次就会触发封禁。
- `bantime = 1h`：封禁 1 小时。
- `bantime = -1`：永久封禁。

注意：

- `1m` 表示 1 分钟，不是 1 个月。
- 如果要表示 1 个月，建议写成 `1mo`。
- 常见写法还有 `30m`、`12h`、`1d`、`1w`。
