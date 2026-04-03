# 群晖上用Docker部署Mihomo实录 | 老苏的blog
`metacubex/mihomo` 是目前最主流的 `Mihomo` (原 `Clash Meta`) `Docker` 镜像，由官方维护，更新非常迅速。

在群晖上以 Docker 方式安装。

涉及到两个镜像

*   `metacubex/mihomo:latest`：对应的版本是 `v1.19.20`；这是 `MetaCubeX` 官方维护的 `Mihomo` 主程序内核镜像（`Mihomo Core / Meta Kernel`），负责实际的代理转发、规则处理、`TUN` 模式等所有网络代理功能。更新最及时（`Alpha` 版每天都有新构建）

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603031743215.png)

*   `ghcr.io/metacubex/metacubexd:latest`：对应的版本是 `v1.241.3`；这是 `MetaCubeX` 的官方 `Web` 仪表盘（`Dashboard`）镜像，也叫 `MetacubeXD` 或 `XD`（`The Official One`, `XD`）。

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603031544103.png)

[](#创建目录 "创建目录")创建目录
--------------------

通过 `SSH` 登录到您的群晖，执行下面的命令，创建用于存放配置文件的目录，并下载最新的 `Geo` 数据文件

```bash

mkdir -p /volume1/docker/mihomo/{config,data}


cd /volume1/docker/mihomo/data


wget -O geoip.dat    https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
wget -O geosite.dat  https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
wget -O country.mmdb https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country-lite.mmdb


wget -O geoip.dat https://gh-proxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
wget -O geosite.dat https://gh-proxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
wget -O country.mmdb https://gh-proxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country-lite.mmdb
```

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603031755376.png)

现在的目录是这样的

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603041035058.png)

[](#config-yaml "config.yaml")config.yaml
-----------------------------------------

这是一个支持订阅的最简可用版本，放入 `data` 目录中，内容示例如下（请务必替换为自己的订阅链接）：

```yaml
mixed-port: 7890
allow-lan: true
bind-address: "*"
mode: rule
log-level: info

external-controller: 0.0.0.0:9090
secret: "123456"                  

tun:
  enable: true
  stack: mixed
  auto-route: true
  auto-detect-interface: true
  dns-hijack:
    - any:53
    - tcp://any:53

dns:
  enable: true
  ipv6: false
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  nameserver:
    - 114.114.114.114
    - 223.5.5.5
  fallback:
    - tls://8.8.8.8:853
    - tls://1.1.1.1:853

proxy-providers:
  airport1:                     
    type: http
    url: "https://机场1的订阅链接"          
    path: ./airport1.yaml
    interval: 86400             
    health-check:
      enable: true
      url: "https://www.gstatic.com/generate_204"
      interval: 300

  airport2:
    type: http
    url: "https://机场2的订阅链接"          
    path: ./airport2.yaml
    interval: 86400
    health-check:
      enable: true
      url: "https://www.gstatic.com/generate_204"
      interval: 300

proxy-groups:
  
  - name: "主出口"
    type: select                  
    proxies:
      - "机场1-自动"
      - "机场2-自动"
      - DIRECT
      - REJECT

  
  - name: "机场1-自动"
    type: url-test
    use:
      - airport1                
    url: "http://www.gstatic.com/generate_204"
    interval: 300
    tolerance: 50               

  - name: "机场2-自动"
    type: url-test
    use:
      - airport2
    url: "http://www.gstatic.com/generate_204"
    interval: 300

  
  - name: "全部-最低延迟"
    type: url-test
    use:
      - airport1
      - airport2
    url: "http://www.gstatic.com/generate_204"
    interval: 300
    tolerance: 100

rules:
  - GEOIP,LAN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,主出口           
```

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603041037173.png)

如果需要更完整或包含复杂分流规则的版本，可以参考 `MetaCubeX` 官方提供的示例

*   [https://wiki.metacubex.one/en/example/conf](https://wiki.metacubex.one/en/example/conf)

这是官方 `wiki` 的 “快捷配置” 示例页，更新及时，覆盖 `TUN`、`DNS` 劫持、多机场、多规则集等场景。直接复制 `config.yaml` 部分即可用。

*   [https://github.com/MetaCubeX/mihomo/blob/Alpha/docs/config.yaml](https://github.com/MetaCubeX/mihomo/blob/Alpha/docs/config.yaml)

这是 `Mihomo` 源码仓库里的官方示例文件，直接来自开发者。

[](#docker-compose-yml "docker-compose.yml")docker-compose.yml
--------------------------------------------------------------

下面的配置支持 `TUN` 模式、全局代理以及 `metacubexd` 控制面板，能够满足绝大多数常见的使用需求。

将以下内容保存为 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  mihomo:
    container_name: mihomo-core
    
    
    image: docker.1ms.run/metacubex/mihomo:latest
    restart: unless-stopped
    network_mode: host
    pid: host
    ipc: host
    cap_add:
      - NET_ADMIN                         
    security_opt:
      - apparmor=unconfined               
    volumes:
      - ./data:/root/.config/mihomo       
      - /dev/net/tun:/dev/net/tun         
      - /etc/localtime:/etc/localtime:ro  
    depends_on:
      - metacubexd

  metacubexd:                         
    container_name: mihomo-web
    
    
    image: ghcr.1ms.run/metacubex/metacubexd:latest
    restart: unless-stopped
    network_mode: bridge              
    ports:
      - "9091:80"                     
    volumes:
      - ./config:/config/caddy        
      - /etc/localtime:/etc/localtime:ro
```

> 为了支持 `TUN` 模式（虚拟网卡），容器必须拥有网络管理权限。所以在配置中加入了 `cap_add: NET_ADMIN` 和 `devices: /dev/net/tun`，这是实现透明代理的关键。

**Mihomo (Clash Meta) TUN 模式** 的核心权限需求主要是：

*   创建/配置虚拟 `TUN` 设备（`/dev/net/tun`）
*   修改路由表（`auto-route: true`）
*   设置网络接口（`auto-detect-interface`）
*   `DNS` 劫持（`dns-hijack`）

加 `--security-opt: apparmor=unconfined` 相当于告诉 `Docker`：“这个容器不要套用任何 `AppArmor` 策略”，让它像 `privileged` 一样自由访问内核资源

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603041041077.png)

[](#启动 "启动")启动
--------------

现在的目录结构如下：

```text
/volume1/docker/mihomo
├── config/
├── data/
│   ├── config.yaml
│   ├── country.mmdb
│   ├── geoip.dat
│   └── geosite.dat
└── docker-compose.yml
```

在 `mihomo` 根目录中执行启动命令

```bash

cd /volume1/docker/mihomo


docker-compose up -d
```

在浏览器中输入 `http://群晖IP:9091` 就能看到 `metacubexd` 的登录界面

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603032004862.png)

因为我们在 `config.yaml` 中设置如下

```yaml
external-controller: 0.0.0.0:9090
secret: "123456" 
```

所以

*   `后端地址`：改为 `http://群晖IP:9090`
*   `密钥` ：输入 `secret` 的值 `123456`

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603032007359.png)

登录成功后的主界面

![](https://cdn.jsdelivr.net/gh/wbsu2003/images2026@main/picgo/2026/02/202603032010553.png)

| 情况 | 解决办法 |
| --- | --- |
| `TUN` 模式不起作用 | 确认已正确映射 `/dev/net/tun` 并添加了 `cap_add: NET_ADMIN`, 如果不行，可以尝试 `cap_add: ALL` |
| 容器启动后立即退出，返回 `code 1` | 通常是 `config.yaml` 语法错误，请通过 `docker logs mihomo` 查看日志，关注 `yaml: line xx` 错误提示 |
| 控制面板无法连接到 `mihomo` | 确认 `config.yaml` 中的 `external-controller` 设置为 `0.0.0.0:9090` |
| 国内节点延迟非常高 | 尝试更换 `geox-url` 使用 `gh-proxy` 加速，或使用 `lite` 版的 Geo 数据文件 |
| `Alpha` 版本不稳定 | 将镜像标签从 `:Alpha` 更换为 `:latest` 或具体的稳定版本号，例如 `:v1.19.20` |

> MetaCubeX/mihomo: A simple Python Pydantic model for Honkai: Star Rail parsed data from the Mihomo API.  
> 地址：[https://github.com/MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo)
> 
> MetaCubeX/metacubexd: Mihomo Dashboard, The Official One, XD  
> 地址：[https://github.com/MetaCubeX/metacubexd](https://github.com/MetaCubeX/metacubexd)
> 
> metacubex/mihomo - Docker Image  
> 地址：[https://hub.docker.com/r/metacubex/mihomo](https://hub.docker.com/r/metacubex/mihomo)
> 
> mihomo + metacubexd + docker compose + nginx 反代教程 · MetaCubeX/metacubexd · Discussion #638  
> 地址：[https://github.com/MetaCubeX/metacubexd/discussions/638](https://github.com/MetaCubeX/metacubexd/discussions/638)
> 
> Docker 部署 Mihomo 核心 + WebUI 指南 - 开发调优 - LINUX DO  
> 地址：[https://linux.do/t/topic/1327214](https://linux.do/t/topic/1327214)