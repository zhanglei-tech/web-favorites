# 设置SSH免密码登录

![Untitled](../attachment/%E8%AE%BE%E7%BD%AESSH%E5%85%8D%E5%AF%86%E7%A0%81%E7%99%BB%E5%BD%95/Untitled.png)

```bash
//1、生成公钥和私钥
ssh-keygen -t rsa
//2、将公钥和私钥发送给其他主机
ssh-copy-id $hostname
```