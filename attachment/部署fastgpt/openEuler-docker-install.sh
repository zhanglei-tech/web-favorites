#!/bin/bash
# Usage：自动安装 Docker

set -e

# 关闭SELinux
# 检查 SELinux 是否已禁用
SELINUX_STATUS=$(sestatus | grep "SELinux status" | awk '{print $3}')

if [ "$SELINUX_STATUS" == "disabled" ]; then
    echo "SELinux is already disabled. Skipping disabling steps."
else
    # 关闭 SELinux
    sed -i '/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    echo "SELinux has been disabled."
fi

# 设置docker-ce源，使用清华大学centos7源
curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo
sed -i 's#https://download.docker.com#https://mirrors.tuna.tsinghua.edu.cn/docker-ce#' /etc/yum.repos.d/docker-ce.repo
sed -i 's#$releasever#7#g' /etc/yum.repos.d/docker-ce.repo

# 安装docker
yum install docker-ce docker-ce-cli docker-ce-rootless-extras containerd.io docker-buildx-plugin docker-compose-plugin -y

# 开机自启
systemctl enable docker

# 设置docker镜像源
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.yundait.cn"]
}
EOF

# 重启docker
systemctl daemon-reload
systemctl restart docker

# 安装完成，显示docker信息
docker info