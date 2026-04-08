# 部署fastgpt

# 安装docker

[centos-docker-install.sh](../attachment/%E9%83%A8%E7%BD%B2fastgpt/centos-docker-install.sh)

[openEuler-docker-install.sh](../attachment/%E9%83%A8%E7%BD%B2fastgpt/openEuler-docker-install.sh)

[ubuntu-docker-install.sh](../attachment/%E9%83%A8%E7%BD%B2fastgpt/ubuntu-docker-install.sh)

# 部署fastgpt

```bash
cd /opt
mkdir fastgpt
cd fastgpt

curl -O https://raw.githubusercontent.com/labring/FastGPT/main/projects/app/data/config.json

# pgvector 版本(测试推荐，简单快捷)
curl -o docker-compose.yml https://raw.githubusercontent.com/labring/FastGPT/main/files/docker/docker-compose-pgvector.yml

docker compose up -d
```

# 安装m3e

```bash
#查看网络 
docker network ls

# GPU模式启动，并把m3e加载到fastgpt同一个网络
docker run -d -p 6008:6008 --restart=always --gpus all --name m3e --network docker_fastgpt stawky/m3e-large-api

# CPU模式启动，并把m3e加载到fastgpt同一个网络
docker run -d -p 6008:6008 --restart=always --name m3e --network docker_fastgpt stawky/m3e-large-api
```

# 安装ollama

## **CPU only**

```bash
docker run -d -v ./ollama:/root/.ollama -p 11434:11434 --restart=always --name ollama --network docker_fastgpt ollama/ollama
```

## **Nvidia GPU**

### **Install with Apt**

1. Configure the repository

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
```

2. Install the NVIDIA Container Toolkit packages

```bash
sudo apt-get install -y nvidia-container-toolkit
```

### **Install with Yum or Dnf**

1. Configure the repository

```
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
```

2. Install the NVIDIA Container Toolkit packages

```bash
sudo yum install -y nvidia-container-toolkit
```

### **Configure Docker to use Nvidia driver**

```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### **Start the container**

```bash
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --restart=always --name ollama --network docker_fastgpt ollama/ollama
```

## **AMD GPU**

To run Ollama using Docker with AMD GPUs, use the `rocm` tag and the following command:

```bash
docker run -d --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --restart=always --name ollama --network fastgpt_fastgpt ollama/ollama:rocm
```

## 安装glm4

```bash
docker exec -it ollama ollama pull glm4
```

# 配置oneapi

## 修改密码

登录oneapi，默认地址为http://[IP]:3001，用户名root，密码123456，登录后修改密码

## 添加令牌

在令牌菜单，点击添加新的令牌

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image.png)

输入令牌名称，点击永不过期，点击设为无限额度，提交

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%201.png)

复制令牌：点击复制按钮，复制上方输入框中显示的令牌字符串，**后面要用**

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%202.png)

## 配置m3e渠道

在渠道菜单，点击添加新的渠道

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%203.png)

渠道类型选择**自定义渠道**

Base Url填写**http://m3e:6008**

名称为**m3e**

删除模型中默认的所有模型，在自定义模型名称中输入**m3e**，点击填入

密钥填写**sk-aaabbbcccdddeeefffggghhhiiijjjkkk**

点击提交

创建成功后，在列表中点击测试，验证是否可以正常访问

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%204.png)

## 配置ollama渠道

在渠道菜单，点击添加新的渠道

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%203.png)

渠道类型选择**自定义渠道**

Base Url填写**http://ollama:11434**

名称为ollama

删除模型中默认的所有模型，在自定义模型名称中输入**glm4**，点击填入

密钥填写在令牌中复制的密钥

点击提交

创建成功后，在列表中点击测试，验证是否可以正常访问

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%205.png)

# 修改配置

## 修改config.json

[config.json](../attachment/%E9%83%A8%E7%BD%B2fastgpt/config.json)

llmModels部分修改，删掉多余的大模型，根据提示修改model和name属性

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%206.png)

vectorModels部分修改，删掉多余的向量模型，根据提示修改model和name属性

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%207.png)

## 修改docker-compose.yml文件

找到fastgpt的CHAT_API_KEY属性，修改为one-api中新添加的令牌

![image.png](../attachment/%E9%83%A8%E7%BD%B2fastgpt/image%208.png)

# 重启fastgpt

修改完配置后，重启fastgpt

```bash
docker compose down
docker compose up -d
```

登录fastgpt，默认用户root，密码1234