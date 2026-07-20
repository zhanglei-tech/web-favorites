# 1. 安装docker

创建 shell 脚本

```shell
#!/bin/bash

# 添加docker官方签名
apt-get update
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# 设置docker-ce源，使用阿里云源
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# 安装docker
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 开机自启
systemctl enable docker

# 设置docker镜像源
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://hub.rat.dev"
  ]
}
EOF

# 重启docker
systemctl daemon-reload
systemctl restart docker

# 安装完成，显示docker信息
docker info
```
# 2. 安装nvidia-container-toolkit

执行 shell 命令

```shell
# 下载 NVIDIA GPG 密钥
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey -o /tmp/nvidia-gpgkey

# 解除 GPG 密钥的 armor 并保存
gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg /tmp/nvidia-gpgkey

# 下载 NVIDIA 容器工具包列表文件
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list -o /tmp/nvidia-list

# 修改列表文件以包含签名
sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' /tmp/nvidia-list > /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 更新包数据库
apt-get update

# 安装 nvidia-container-toolkit
apt install nvidia-container-toolkit -f
```
# 3. 配置 Docker以支持 NVIDIA

执行 shell 命令

```shell
# 配置 Docker 运行时以使用 NVIDIA Container Toolkit
nvidia-ctk runtime configure --runtime=docker

# 重启 docker 服务
systemctl restart docker
```
# 4. 查看显卡运行情况

执行 shell 命令

```shell
nvidia-smi
```