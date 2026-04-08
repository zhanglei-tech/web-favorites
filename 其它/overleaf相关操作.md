# overleaf相关操作

# 基本信息

## 服务器信息

服务器IP：192.168.10.159

远程联机端口：22

用户名：root

密码：yundait@2022

连接方式：ssh

## overleaf文件路径

/opt/overleaf-src：overleaf源文件

/opt/overleaf-toolkit：overleaf部署工具

## overleaf源码

### overleaf源码地址

https://github.com/overleaf/overleaf.git

### overleaf部署工具地址

[https://github.com/overleaf/toolkit.git](https://github.com/overleaf/toolkit.git) 

# docker相关操作

## 查看docker容器

```bash
# 查看运行中的容器
docker ps
# 查看所有容器
docker ps -a
```

## 查看docker镜像

```bash
docker images
```

## 进入docker容器

```bash
# docker exec -it <容器名> bash
docker exec -it sharelatex bash
```

## 复制文件到容器中

```bash
# docker cp <本地文件路径> <容器名>:<容器内文件路径>
docker cp /opt/cls_slsyhgxy.txt sharelatex:/overleaf/cls_slsyhgxy.txt
```

## 启动和停止overleaf服务

```bash
# 启动overleaf
cd /opt/overleaf-toolkit
bin/start

# 停止overleaf
cd /opt/overleaf-toolkit
bin/stop
```

## 编译overleaf镜像

```bash
# 停止overleaf
cd /opt/overleaf-toolkit
bin/stop

# 删除原镜像
docker rmi yundait-latex

# 编译镜像
cd /opt/overleaf-src
docker build -t yundait-latex:latest -f ./server-ce/Dockerfile .

# 启动overleaf
cd /opt/overleaf-toolkit
bin/up -d
```