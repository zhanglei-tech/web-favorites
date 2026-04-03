# 群晖 NAS Docker 部署 OpenClaw优雅实践 - 知乎
前言

[OpenClaw](https://link.zhihu.com/?target=https%3A//github.com/openclaw/openclaw) 官方提供了完整的 Docker 部署方案（从源码构建镜像），但对于 NAS 家庭用户来说偏重了。

本文记录了我在**群晖 NAS** 上用 Docker 容器部署 OpenClaw 的完整过程，包括方案设计、踩过的坑、最终的配置文件，以及与官方方案的对比。希望能帮助同样想在 NAS 上跑 AI 助手的朋友少走弯路。

* * *

### 一、方案选型：为什么不用官方 Docker 方案？

官方 Docker 方案功能全面，包含：

*   从源码构建完整镜像（需要 pnpm、bun 等构建工具）
*   独立的 CLI 辅助容器
*   Agent Sandbox（[Docker-in-Docker](https://zhida.zhihu.com/search?content_id=271515988&content_type=Article&match_order=1&q=Docker-in-Docker&zhida_source=entity)）
*   完整的安全加固（[cap\_drop](https://zhida.zhihu.com/search?content_id=271515988&content_type=Article&match_order=1&q=cap_drop&zhida_source=entity)、网络隔离等）

但对于 **NAS / 家庭服务器** 场景：

| 痛点 | 说明 |
| --- | --- |
| 构建成本高 | 需要 clone 源码、安装 pnpm + bun，构建一次耗时长 |
| 更新频率高 | OpenClaw 迭代快，每次更新都要重新 build 镜像 |
| 镜像体积大 | 构建产物几百 MB，拉取/推送耗时 |
| 功能过剩 | 个人使用不需要 Agent Sandbox、CLI 容器等企业级功能 |

### 💡 我的方案：把 [Node.js](https://zhida.zhihu.com/search?content_id=271515988&content_type=Article&match_order=1&q=Node.js&zhida_source=entity) 官方镜像当运行时，OpenClaw 当应用装在外面

核心思路很简单：

```text
官方 Node.js 镜像（只提供运行环境）
  + npm install -g openclaw（应用安装在挂载目录）
  = 零构建、秒级更新的容器化部署
```

### 核心优势

**零构建，开箱即用** 不需要 clone 源码、不需要 `docker build`、不需要 Dockerfile。一个 `docker-compose.yml` + 两条命令搞定。

**更新不碰镜像** OpenClaw 更新只需 `npm install -g openclaw@latest` + 重启容器。不用重新拉镜像、不用重新构建，秒级完成。

**代码和数据完全持久化** 只需挂载一个目录（`/home/node`），OpenClaw 代码和运行数据全部在宿主机上。容器可以随时删除重建，不丢任何东西。

**Node.js 升级解耦** 想升级 Node.js？改一下 image tag，`docker compose up -d`，完事。OpenClaw 代码已经在外面，不受影响。

**首次启动全自动** 容器启动时自动检测 OpenClaw 是否已安装，未安装则自动 `npm install`，无需手动进容器操作。

### 方案对比

| 特性 | 官方（从源码构建） | 本方案（npm 安装） |
| --- | --- | --- |
| 镜像 | 自建 / [http://ghcr.io](https://link.zhihu.com/?target=http%3A//ghcr.io) 预构建 | 直接用 Node.js 官方镜像 |
| 首次部署 | clone + build（分钟级） | npm install（分钟级） |
| 更新方式 | 重新 build 或 pull 镜像 | npm install -g openclaw@latest |
| 更新耗时 | 分钟级 | 秒级 |
| CLI 容器 | 独立辅助容器 | 直接 docker exec |
| Agent Sandbox | 支持（Docker-in-Docker） | 不含（按需扩展） |
| 安全加固 | ✅ cap\_drop + no-new-privileges | ✅ no-new-privileges |
| 健康检查 | curl /healthz | node /healthz（不依赖 curl） |
| 资源限制 | ✅ | ✅ mem + pids |
| 适合场景 | VPS、企业、多用户 | NAS、家庭、个人 |

* * *

### 二、架构设计

```vgl
┌──────────────────────────────────────────────┐
│  Docker Container (node:25-bookworm)         │
│  user: node (uid=1000)                       │
│                                              │
│  /home/node/  ← 挂载宿主机目录               │
│    ├── .npm-global/                          │
│    │   ├── bin/openclaw (软链，npm 自动创建)   │
│    │   └── lib/node_modules/openclaw (包体)   │
│    └── .openclaw/                            │
│        ├── openclaw.json (配置)               │
│        ├── workspace/ (工作区)                │
│        └── agents/ (会话数据)                 │
│                                              │
│  openclaw gateway run --allow-unconfigured   │
└──────────────────────────────────────────────┘
         │ network_mode: host
         ▼
    宿主机网络 → http://<NAS-IP>:1111 (WebUI)
```

### 关键设计决策

1.  **挂载整个 `/home/node`**：而不是分别挂载 `.npm-global` 和 `.openclaw`。这样更简单，npm 和 openclaw 自动创建所有子目录，不需要手动建文件夹。
2.  **`network_mode: host`**：直接使用宿主机网络，省去端口映射的麻烦，也让 mDNS / Bonjour 设备发现正常工作。
3.  **`[npm_config_prefix](https://zhida.zhihu.com/search?content_id=271515988&content_type=Article&match_order=1&q=npm_config_prefix&zhida_source=entity)` 环境变量**：把 npm 全局安装路径指向 `/home/node/.npm-global`（在挂载目录内），这样安装的包持久化在宿主机上。
4.  **init-permissions 初始化容器**：一次性修复挂载目录权限，确保 node 用户可写。

* * *

### 三、完整配置文件

### docker-compose.yml

```text
services:
  # 一次性修复挂载目录权限（跑完自动退出，不会常驻）
  init-permissions:
    image: node:25-bookworm
    platform: linux/amd64
    user: root
    volumes:
      - /volume2/docker/openclaw/node:/home/node
    command: chown -R node:node /home/node
    restart: "no"

  openclaw:
    image: node:25-bookworm
    platform: linux/amd64
    container_name: openclaw
    restart: unless-stopped
    network_mode: host
    user: "node"
    depends_on:
      init-permissions:
        condition: service_completed_successfully

    environment:
      - HOME=/home/node
      - OPENCLAW_STATE_DIR=/home/node/.openclaw
      - npm_config_prefix=/home/node/.npm-global
      - PATH=/home/node/.npm-global/bin:/usr/local/bin:/usr/bin:/bin
      - TERM=xterm-256color
      - OPENCLAW_GATEWAY_PORT=1111

    volumes:
      - /volume2/docker/openclaw/node:/home/node

    security_opt:
      - no-new-privileges:true

    mem_limit: 6g
    memswap_limit: 8g
    pids_limit: 256

    tmpfs:
      - /tmp:size=512m
      - /var/tmp:size=256m
      - /run:size=64m

    healthcheck:
      test: >-
        node -e "
          const path = '/home/node/.npm-global/bin/openclaw';
          if (!require('fs').existsSync(path)) process.exit(0);
          const http = require('http');
          const req = http.get('http://127.0.0.1:1111/healthz', (res) => {
            process.exit(res.statusCode === 200 ? 0 : 1);
          });
          req.on('error', () => process.exit(1));
          req.setTimeout(3000, () => { req.destroy(); process.exit(1); });
        "
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 120s

    logging:
      driver: json-file
      options:
        max-size: "50m"
        max-file: "3"

    entrypoint: ["/bin/sh", "-c"]
    command:
      - |
        if command -v openclaw >/dev/null 2>&1; then
          echo "✅ openclaw found, starting gateway..."
          exec openclaw gateway run --allow-unconfigured
        else
          echo "⏳ openclaw not found, auto-installing..."
          npm install -g openclaw@latest

          if command -v openclaw >/dev/null 2>&1; then
            echo "✅ installed successfully, waiting for configuration..."
            echo "💡 please run:"
            echo "   docker exec -it openclaw openclaw init"
            echo "   then: docker compose restart"
            exec tail -f /dev/null
          else
            echo "❌ install failed, container idle for debugging..."
            echo "   docker exec -it openclaw bash"
            exec tail -f /dev/null
          fi
        fi
```

### 目录结构

```text
/volume2/docker/openclaw/
├── docker-compose.yml
└── node/                    # → /home/node（一个挂载搞定）
    ├── .npm-global/         #   npm 自动创建
    │   ├── bin/             #   可执行文件软链（openclaw）
    │   └── lib/node_modules/#   openclaw 包体 + 依赖
    └── .openclaw/           #   openclaw 运行数据
        ├── openclaw.json    #   配置文件
        ├── workspace/       #   agent workspace
        └── agents/          #   会话数据
```

> 📌 所有子目录都由 npm 和 openclaw 自动创建，**不需要手动建子文件夹**。只需要创建最外层的 `node/` 目录。

* * *

### 四、部署步骤

### 1\. 创建数据目录

```text
# 在群晖上（通过 SSH 或任务计划）
mkdir -p /volume2/docker/openclaw/node
chown -R 1000:1000 /volume2/docker/openclaw/node
```

> 💡 如果没有 SSH 权限也没关系，`init-permissions` 容器会以 root 身份自动修复权限。

### 2\. 上传 docker-compose.yml

将上面的 `docker-compose.yml` 放到 `/volume2/docker/openclaw/` 目录下。

### 3\. 启动容器

通过群晖 Container Manager（容器管理器）创建项目，选择 `docker-compose.yml` 所在目录。或者通过 SSH：

```text
cd /volume2/docker/openclaw
docker compose up -d
```

### 4\. 查看安装进度

首次启动会自动安装 OpenClaw，根据网络情况需要 1-5 分钟。

### 5\. 初始化配置

```text
# 初始化 OpenClaw（生成基本配置）
docker exec -it openclaw openclaw init

# 设置局域网访问
docker exec -it openclaw openclaw config set gateway.bind lan

# 重启容器使配置生效
docker compose restart
```

### 6\. 访问 WebUI

浏览器打开 `http://<NAS内网IP>:1111`，即可看到 OpenClaw 的 Web 界面。

* * *

### 五、踩坑记录 🕳️

### 坑 1：群晖内核不支持 CPU CFS 调度器

**现象**：

```text
NanoCPUs can not be set, as your kernel does not support CPU CFS scheduler
or the cgroup is not mounted
```

**原因**：群晖的 Linux 内核可能没有编译 `CONFIG_CFS_BANDWIDTH` 选项，不支持 Docker 的 `cpus` 限制。

**解决**：去掉 docker-compose.yml 中的 `cpus` 配置，只保留内存和进程数限制。CPU 限制在 NAS 上影响不大，反正就你自己用。

* * *

### 坑 2：镜像平台不匹配（arm64 vs amd64）

**现象**：

```text
The requested image's platform (linux/arm64/v8) does not match the detected
host platform (linux/amd64/v2) and no specific platform was requested
```

**原因**：Docker 拉取镜像时默认按宿主机架构选择，但有时会拉错。群晖 NAS 大多是 x86（amd64）架构。

**解决**：在 docker-compose.yml 中显式指定平台：

> 💡 如果你的 NAS 是 ARM 架构（如某些新款群晖），改为 `linux/arm64`。

* * *

### 坑 3：bookworm-slim 缺少编译工具

**现象**：npm install 时部分原生模块编译失败。

**原因**：`node:xx-bookworm-slim` 精简了很多系统包，缺少 `gcc`、`make`、`python3` 等编译工具。OpenClaw 有些依赖需要编译原生模块。

**解决**：换用完整版 `node:25-bookworm`（非 slim）。镜像大了约 400MB，但省心很多。

```text
# ❌ slim 版缺少编译工具
image: node:25-bookworm-slim

# ✅ 完整版，一步到位
image: node:25-bookworm
```

* * *

### 坑 4：`openclaw gateway start --foreground` 不存在

**现象**：

```text
error: unknown option '--foreground'
```

**原因**：OpenClaw 的前台运行命令不是 `start --foreground`。

**解决**：使用 `openclaw gateway run`，这是前台阻塞运行模式，适合 Docker 容器：

```text
# ❌ 错误
openclaw gateway start --foreground

# ✅ 正确
openclaw gateway run --allow-unconfigured
```

> `--allow-unconfigured` 允许在没有完成 setup 的情况下启动，首次安装后可以先启动再配置。

* * *

### 坑 5：`Missing config` 导致容器退出

**现象**：

```text
Missing config. Run `openclaw setup` or set gateway.mode=local
```

容器反复重启。

**原因**：OpenClaw 首次运行没有配置文件，`gateway run` 会直接报错退出。容器 `restart: unless-stopped` 策略导致反复重启。

**解决**：在启动命令中加入 `--allow-unconfigured` 参数，允许无配置启动。然后进容器完成初始化：

```text
docker exec -it openclaw openclaw init
docker exec -it openclaw openclaw config set gateway.bind lan
docker compose restart
```

* * *

### 坑 6：没有群晖 SSH 权限，无法 chown 数据目录

**现象**：OpenClaw 容器以 `node` 用户（uid=1000）运行，挂载的目录权限不对，各种写入失败。

**解决**：用 `init-permissions` 初始化容器，以 root 身份自动修复权限：

```text
init-permissions:
  image: node:25-bookworm
  user: root
  volumes:
    - /volume2/docker/openclaw/node:/home/node
  command: chown -R node:node /home/node
  restart: "no"
```

这个容器跑完就自动退出，不占资源。主容器通过 `depends_on` + `service_completed_successfully` 确保权限修复完成后再启动。

* * *

### 坑 7：健康检查在安装阶段误报 unhealthy

**现象**：OpenClaw 还在安装中（npm install），健康检查就开始报失败，容器被标记为 unhealthy。

**解决**：健康检查采用**智能判断逻辑**——先检测 openclaw 是否已安装（软链是否存在），未安装则直接返回成功：

```text
const path = '/home/node/.npm-global/bin/openclaw';
if (!require('fs').existsSync(path)) process.exit(0); // 未安装，跳过检查
// 已安装，检查 /healthz 端点
```

配合 `start_period: 120s` 宽限期，覆盖安装阶段。

| 容器阶段 | 检查行为 | 结果 |
| --- | --- | --- |
| npm install 中 | 检测到软链不存在，跳过 | ✅ healthy |
| openclaw 启动中 | start\_period 宽限期 | 不判定 |
| 正常运行 | 请求 /healthz 返回 200 | ✅ healthy |
| 进程挂掉 | /healthz 请求失败 | ❌ unhealthy |

* * *

### 坑 8：为什么用 node 做健康检查而不是 curl

**原因**：`bookworm-slim` 不含 curl，即使换了完整版 bookworm，用 node 做 HTTP 请求也更可靠——毕竟容器里一定有 node。

```text
# ❌ 依赖 curl（slim 版没有）
test: curl -f http://127.0.0.1:1111/healthz

# ✅ 用 node 内置 http 模块（一定存在）
test: node -e "const http = require('http'); ..."
```

* * *

### 六、日常运维

### 更新 OpenClaw

```text
docker exec -it openclaw npm install -g openclaw@latest
docker compose restart
```

就这两条命令，秒级完成。不需要重新拉镜像、不需要重新构建。

### 回滚到指定版本

```text
docker exec -it openclaw npm install -g openclaw@<version>
docker compose restart
```

### 升级 Node.js

改 docker-compose.yml 中的 image tag（如 `node:26-bookworm`），然后：

数据都在挂载目录里，不会丢。

### 查看状态

```text
# Docker 健康状态
docker inspect --format='{{.State.Health.Status}}' openclaw

# OpenClaw 状态
docker exec openclaw openclaw status

# 实时日志
docker logs -f openclaw

# 最近 100 行日志
docker logs --tail 100 openclaw
```

### 备份

只需备份 `/volume2/docker/openclaw/node/` 目录即可，包含：

*   OpenClaw 代码（`.npm-global/`）
*   配置文件（`.openclaw/openclaw.json`）
*   工作区（`.openclaw/workspace/`）
*   会话数据（`.openclaw/agents/`）

* * *

### 七、技术要点说明

### npm\_config\_prefix 的作用

默认情况下，`npm install -g` 会把包装到 `/usr/local/lib/node_modules/`，这个路径在容器内，容器删除就没了。

通过设置 `npm_config_prefix=/home/node/.npm-global`，npm 全局安装的包会放到挂载目录内：

```text
/home/node/.npm-global/
├── bin/openclaw          → 软链，指向 lib 下的实际文件
└── lib/node_modules/
    └── openclaw/         → OpenClaw 完整包体 + 所有依赖
```

配合 `PATH` 环境变量把 `.npm-global/bin` 加到前面，容器就能找到 `openclaw` 命令。

> ⚠️ 这个方案不会影响容器内已有的系统级 npm 包（它们在 `/usr/local/`），只是新增了一个全局安装路径。

### network\_mode: host 的取舍

使用 `host` 网络模式：

*   ✅ 不需要端口映射，直接通过宿主机 IP + 端口访问
*   ✅ mDNS / Bonjour 设备发现正常工作
*   ✅ 网络性能最好，无 NAT 开销
*   ❌ 容器和宿主机共享网络命名空间，隔离性较弱

对于 NAS 个人使用场景，host 模式是最简单的选择。

### entrypoint 的启动逻辑

容器启动时执行一段 shell 脚本，实现**安装与运行的自动切换**：

```text
启动 → openclaw 命令是否存在？
  ├── 是 → exec openclaw gateway run（前台运行）
  └── 否 → npm install -g openclaw@latest
            ├── 安装成功 → tail -f /dev/null（等待手动配置）
            └── 安装失败 → tail -f /dev/null（等待排查）
```

注意这里用了 `exec`：它会用 openclaw 进程替换当前 shell 进程，这样：

1.  openclaw 成为 PID 1，能正确接收 Docker 的 SIGTERM 信号
2.  容器停止时 openclaw 能优雅退出

### 为什么不用 `openclaw gateway start`

`openclaw gateway start` 是**后台守护进程模式**——它启动后会 fork 子进程然后主进程退出。在 Docker 中，主进程退出 = 容器退出。

`openclaw gateway run` 是**前台阻塞模式**——进程保持在前台运行，适合 Docker 容器。

### init 和 setup 的区别

| 命令 | 作用 | 适用场景 |
| --- | --- | --- |
| openclaw init | 生成最小配置文件（openclaw.json），快速可用 | 快速开始，后续手动调整 |
| openclaw setup / openclaw onboard | 交互式向导，引导完成完整配置 | 首次部署，需要配置模型、渠道等 |

对于 Docker 部署，推荐先 `init` 让服务跑起来，再根据需要逐步配置。

* * *

### 八、资源限制参考

根据 NAS 的硬件配置调整：

| 资源 | 我的配置 | 说明 |
| --- | --- | --- |
| 内存 | 6GB（swap 8GB） | NAS 20G 总内存，分配 6G |
| 进程数 | 256 | 防止 fork 炸弹 |
| /tmp | 512MB tmpfs | 临时文件走内存，性能好且不写磁盘 |
| /var/tmp | 256MB tmpfs |  |
| /run | 64MB tmpfs |  |
| CPU | 未限制 | 群晖内核可能不支持 CPU CFS 调度器 |

> 如果你的 NAS 内存较小（如 8G），建议分配 2-4G。OpenClaw 日常运行内存占用约 200-500MB，峰值（处理复杂任务时）可能到 1-2G。

* * *

### 九、安全说明

*   `no-new-privileges: true`：禁止容器内进程提权
*   `user: "node"`：以非 root 用户运行
*   日志轮转：单文件最大 50MB，保留 3 个文件，总上限 150MB，防止磁盘爆炸
*   `pids_limit: 256`：限制进程数，防止 fork 炸弹
*   tmpfs 挂载：临时文件不写入磁盘，容器重建后自动清理

* * *

### 十、写在最后

这个方案的核心理念是**把容器当运行时，把应用装在外面**。这在传统的容器化最佳实践中可能不太”正统”，但对于 NAS 个人用户来说，它带来了实实在在的便利：

*   **更新快**：`npm install` 秒级完成 vs 重新构建镜像分钟级
*   **维护简单**：一个挂载目录搞定一切，备份/迁移/回滚都很直观
*   **门槛低**：不需要 git、不需要 pnpm、不需要理解构建流程
*   **灵活**：Node.js 版本和 OpenClaw 版本完全解耦，各自独立升级，特别是面对openclaw如此高频的更新频率下。

**Happy Hacking! 🦞**

* * *

### 相关资源

*   [OpenClaw 官方文档](https://link.zhihu.com/?target=https%3A//docs.openclaw.ai/)
*   [OpenClaw GitHub](https://link.zhihu.com/?target=https%3A//github.com/openclaw/openclaw)
*   [OpenClaw Docker 官方文档](https://link.zhihu.com/?target=https%3A//docs.openclaw.ai/install/docker)
*   [OpenClaw Discord 社区](https://link.zhihu.com/?target=https%3A//discord.gg/clawd)

本文内容由我的龙虾“老六”根据我们创建容器过程中的问题整理而成。