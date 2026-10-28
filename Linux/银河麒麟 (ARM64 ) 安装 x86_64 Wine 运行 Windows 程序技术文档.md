## 📌 1. 背景与核心原理

**环境说明：**
*   **操作系统**：银河麒麟桌面操作系统（ARM64/aarch64 架构，glibc 2.31）
*   **硬件平台**：基于 ARM64 架构的实体计算机
*   **目标**：运行 x86_64 架构的 `.exe` Windows 程序

**为什么不能直接用系统自带的 Wine？**
银河麒麟系统的官方源中提供的 `wine` 是 **ARM64 原生版本**。它只能处理 ARM 架构的 Windows 程序。运行常见的 x86_64 架构 `.exe` 会直接报错 `not supported on this system`。

**核心解决思路（套娃模式）：**
必须使用 **x86_64 (amd64) 架构的 Wine** 来处理 Windows 的 API，再通过 **Box64**（x86 到 ARM 的指令翻译器）来翻译 Wine 和程序的底层机器码。
> **工作流**：`Box64 (翻译指令) -> x86_64 Wine (翻译 Windows API) -> x86_64 Windows 程序 (.exe)`

---

## 🛠️ 2. 环境清理与准备

在开始前，必须彻底清理系统中原有的 ARM64 版本 Wine，避免架构冲突导致的死锁。

```bash
# 1. 卸载原生 ARM64 Wine 及相关冲突包
sudo apt purge --auto-remove wine wine64 wine-stable wine-pixelos

# 2. 如需彻底清理用户 Wine 前缀（可选）
sudo rm -rf ~/.wine
```

> ⚠️ **警告**：请勿手动删除 `/var/lib/dpkg/info/` 下的文件，这会损坏 dpkg 包管理器数据库，导致后续 apt/dpkg 操作异常。

---

## 📦 3. 安装 Box64

### 📦 推荐方式：通过 APT 源安装（最省心）

Box64 的官方文档推荐使用 **`@ryanfortner`** 维护的 APT 仓库，该仓库每 24 小时更新一次预编译的 deb 包。在银河麒麟上执行以下命令即可完成配置和安装：

```bash
# 1. 添加 Box64 的 APT 源
sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list

# 2. 导入仓库签名密钥
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg

# 3. 更新软件包列表并安装 Box64
sudo apt update
# 先确认真实包名（ryanfortner 仓库通常为 box64，而非 box64-arm64）
apt-cache search box64
sudo apt install box64 -y
```

安装完成后，直接验证版本即可：

```bash
box64 --version
```

银河麒麟的相关教程也确认了这套源配置方法在实际系统中可以正常使用。

### 📥 备选方式：手动下载 `.deb` 包

如果 APT 源因网络原因无法访问，也可以从 Debian/Ubuntu 的软件镜像站手动下载 ARM64 架构的 `.deb` 文件，再用 `dpkg` 安装。Debian 仓库中目前有 `box64_0.4.3-3+dfsg-1_arm64.deb` 可以直接下载。

下载后，在文件所在目录执行：

```bash
sudo dpkg -i box64_*_arm64.deb
```

如果提示缺少依赖，运行 `sudo apt --fix-broken install` 让系统补全即可。银河麒麟的实践教程也采用了直接 `dpkg -i box64.deb` 的方式来安装。

### ✅ 安装后的必要检查

Box64 依赖 Linux 内核的 `binfmt_misc` 机制来自动识别 x86_64 程序。**本文档全程使用 `box64` 显式前缀运行 Wine（如 `box64 wine ...`），不依赖 binfmt_misc 自动触发**，因此 `binfmt_misc` 不是本方案的必要步骤。如需确认系统机制状态，可执行：

```bash
cat /proc/sys/fs/binfmt_misc/status
```

如果输出不是 `enabled`，可手动触发：
```bash
sudo systemctl restart systemd-binfmt
```

完成以上任一方式的安装后，就可以按照文档继续后面的 Wine 安装步骤了。

---

## 🍷 4. 安装 x86_64 架构的 Wine

**关键痛点：** 银河麒麟 V10 的 glibc 版本通常为 **2.31**，而目前大多数最新版的 Debian/Ubuntu x86_64 Wine 包要求 `glibc >= 2.38`。直接强制安装会因为依赖不满足而失败。

**解决方案：** 使用专为较老 glibc 版本编译的第三方包，例如 **`wine-pixelos`**（专为 Debian glibc 2.31 构建）。

### 4.1 开启 amd64 多架构支持（必须）

在安装 amd64 版 Wine 之前，必须先向系统添加 amd64 架构，否则 apt 只会去 arm64 源中解析依赖，导致 `--fix-broken install` 安装错误的 arm64 库，Wine 无法启动。

```bash
# 1. 添加 amd64 架构
sudo dpkg --add-architecture amd64

# 2. 更新软件包列表
sudo apt update

# 3. 验证架构已添加
dpkg --print-foreign-architectures
```

> ⚠️ 这一步是强制安装 amd64 Wine 包的前提，请不要跳过。

### 4.2 解决基础依赖

麒麟系统的较新软件源中可能移除了旧版基础库，直接安装 x86 Wine 会报缺 `libncurses5` 和 `libtinfo5`。需先手动补齐 **amd64 架构**的库（x86_64 Wine 二进制需要 amd64 版共享库，arm64 版库无效）：

```bash
# 通过 amd64 源安装（推荐）
sudo apt install libncurses5:amd64 libtinfo5:amd64

# 或手动下载 amd64 版 deb 包后安装：
# sudo dpkg -i libncurses5_*_amd64.deb libtinfo5_*_amd64.deb
```

### 4.3 安装 x86_64 Wine 包

1. **下载 amd64 版 `.deb` 包**  
   前往 [PixelOS1/debian-wine-builds Releases 页面](https://github.com/PixelOS1/debian-wine-builds/releases)，下载适用于 **`amd64`** 架构的 Wine `.deb` 安装包，文件名通常形如 `wine-pixelos_<版本>_amd64.deb`。

   也可直接在终端使用 `wget` 下载（将 `<VERSION>` 替换为实际版本号）：
   ```bash
   wget https://github.com/PixelOS1/debian-wine-builds/releases/download/<VERSION>/wine-pixelos_<VERSION>_amd64.deb
   ```

2. 使用 `dpkg` 强制安装（忽略架构警告）：
   ```bash
   sudo dpkg --force-architecture -i wine-pixelos_*.deb
   ```
3. 修复可能缺失的依赖链：
   ```bash
   # 如果报错依赖缺失，使用 apt 自动修复
   sudo apt --fix-broken install
   ```

---

## ⚙️ 5. 初始化与运行测试

### 5.1 初始化 Wine 环境
**注意：** 由于安装的是 x86_64 架构的 Wine，**必须**显式调用 `box64` 才能启动，否则会报 `Exec format error`。建议首次运行前显式指定 64 位前缀架构：

```bash
# 显式指定 64 位 Wine 前缀
export WINEARCH=win64
export WINEPREFIX="$HOME/.wine"

# 初始化 Wine 配置（在用户目录创建 .wine 文件夹）
box64 wine winecfg
```
*操作提示：在弹出的窗口中，将 Windows 版本设置为 **Windows 10**，点击确定保存。*

### 5.2 运行 Windows 程序
使用终端进入 `.exe` 文件所在的目录，使用 `box64` 结合 `wine` 运行：

```bash
cd /path/to/your/windows/app/
box64 wine YourApp.exe
```
*(如果程序路径包含空格，请使用英文双引号将路径括起来)*

**日志排查：** 若程序启动失败，可开启 Wine 调试日志定位问题：
```bash
WINEDEBUG=+all box64 wine YourApp.exe 2>&1 | tee wine.log
```

**wineserver 异常处理：** Wine 依赖 `wineserver` 进程，Box64 下 wineserver 本身也是 x86_64 二进制，若出现服务器异常，可先终止旧进程再重试：
```bash
box64 wineserver -k
box64 wine YourApp.exe
```

---

## 🚨 6. 常见问题排错 (Troubleshooting)

| 报错信息                       | 原因分析                                                     | 解决方案                                                     |
| :----------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `Exec format error`            | 尝试直接执行了 x86_64 的二进制文件，或调用了系统默认的 ARM Wine。 | 必须使用 `box64 wine` 前缀运行。检查 `file $(which wine)` 确认当前 wine 的架构。 |
| `not supported on this system` | 用 ARM64 的 Wine 尝试运行 x86_64 的 exe。                    | 卸载原生 ARM64 Wine，确保安装的是 x86_64 (amd64) 架构的包。  |
| 依赖冲突，无法安装             | 系统中同时存在原生 Wine 和 x86 Wine 的依赖库。               | 彻底清理旧包，使用 `sudo apt --fix-broken install` 自动解决依赖链。 |
| 中文乱码                       | Wine 缺少中文字体映射。                                      | 将 Windows 的 `C:\Windows\Fonts` 下的字体（如 `msyh.ttc`）复制到 `~/.wine/drive_c/windows/Fonts/` 目录下。 |
| 缺少 DLL 或运行库              | 软件依赖 VC++ 或 .NET 环境。                                 | 安装 `winetricks`，执行 `box64 winetricks vcrun2019` 或 `dotnet48` 安装缺失组件。 |
| `error while loading shared libraries` | 缺少 amd64 版运行库，或错误安装了 arm64 版依赖库。 | 确保已执行 `dpkg --add-architecture amd64`，并通过 `:amd64` 后缀安装对应库。 |

---

## 💡 7. 进阶推荐：Hangover

手动配置 `Box64 + x86 Wine` 虽然在麒麟系统上能够跑通，但对于复杂的大型软件，兼容性和性能依然存在挑战。

**Hangover** 是一个深度集成了 Wine 和指令翻译器（如 FEX-Emu）的开源项目。它的核心优势在于**只翻译应用程序本身**，而不翻译整个 Wine 环境，运行效率极高。

如果 `wine-pixelos + box64` 方案在运行特定软件时遇到无法解决的崩溃问题，强烈建议前往 [Hangover GitHub 仓库](https://github.com/AndreRH/hangover/releases) 下载 arm64 版本的 `.deb` 包进行平替尝试。安装后通常可直接使用 `wine` 命令运行程序，无需手动加上 `box64` 前缀。

> ⚠️ **注意**：Hangover 依赖 FEX-Emu，与 Box64 不能混用。切换到 Hangover 前，建议先彻底卸载 Box64 和 x86_64 Wine，避免两套环境冲突。