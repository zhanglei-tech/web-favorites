# 技术知识库

这是一个以 Obsidian 为主、Git 为辅维护的个人技术知识库，内容覆盖 AI、大模型部署、Linux 运维、Docker、开发环境、业务系统认知等方向。当前仓库包含 `39` 篇 Markdown 文档，附件统一存放在 `attachment/` 目录。

## 仓库概览

| 分类                         |  数量 | 说明                           |
| -------------------------- | --: | ---------------------------- |
| [AI](./AI)                 |   5 | 大模型部署、问答平台、Dify、运行环境         |
| [Docker](./Docker)         |   2 | 离线部署与容器应用                    |
| [Git](./Git)               |   2 | Git Flow 与 CI/CD 自动化部署       |
| [Linux](./Linux)           |  14 | 服务器初始化、存储、JDK、Neo4j、SSH、安全加固 |
| [MacOS](./MacOS)           |   1 | iTerm2 与 oh-my-zsh 配置        |
| [windows](./windows)       |   1 | 远程桌面端口调整                     |
| [业务知识](./业务知识)             |   4 | MES、ERP、SCM 等工业与企业系统知识       |
| [开发技术](./开发技术)             |   3 | RTSP、fastjson、代码命名规范         |
| [开发环境](./开发环境)             |   3 | GB28181/WVP、npm 镜像源、OPC/DCOM |
| [群辉](./群辉)                 |   2 | 群晖 Docker 部署实践               |
| [其它](./其它)                 |   2 | Overleaf 使用相关                |
| [attachment](./attachment) |  附件 | 图片、脚本和配置文件                   |

## 推荐入口

如果你是第一次看这份知识库，建议先从这些文档开始：

- [Ubuntu基础环境搭建](./Linux/Ubuntu基础环境搭建.md)
- [安装 fail2ban 拦截异常登录](./Linux/%E5%AE%89%E8%A3%85%20fail2ban%20%E6%8B%A6%E6%88%AA%E5%BC%82%E5%B8%B8%E7%99%BB%E5%BD%95.md)
- [设置SSH免密码登录](./Linux/%E8%AE%BE%E7%BD%AESSH%E5%85%8D%E5%AF%86%E7%A0%81%E7%99%BB%E5%BD%95.md)
- [大模型部署手册](./AI/%E5%A4%A7%E6%A8%A1%E5%9E%8B%E9%83%A8%E7%BD%B2%E6%89%8B%E5%86%8C.md)
- [部署fastgpt](./AI/%E9%83%A8%E7%BD%B2fastgpt.md)
- [使用docker离线部署环境](./Docker/%E4%BD%BF%E7%94%A8docker%E7%A6%BB%E7%BA%BF%E9%83%A8%E7%BD%B2%E7%8E%AF%E5%A2%83.md)

## 全量索引

### AI

- [Dify实战（二）：LLM × text2SQL](./AI/Dify%E5%AE%9E%E6%88%98%EF%BC%88%E4%BA%8C%EF%BC%89%EF%BC%9ALLM%20%C3%97%20text2SQL.md)
- [Ubuntu 系统大模型运行环境](./AI/Ubuntu%20%E7%B3%BB%E7%BB%9F%E5%A4%A7%E6%A8%A1%E5%9E%8B%E8%BF%90%E8%A1%8C%E7%8E%AF%E5%A2%83.md)
- [大模型知识问答平台操作](./AI/%E5%A4%A7%E6%A8%A1%E5%9E%8B%E7%9F%A5%E8%AF%86%E9%97%AE%E7%AD%94%E5%B9%B3%E5%8F%B0%E6%93%8D%E4%BD%9C.md)
- [大模型部署手册](./AI/%E5%A4%A7%E6%A8%A1%E5%9E%8B%E9%83%A8%E7%BD%B2%E6%89%8B%E5%86%8C.md)
- [部署fastgpt](./AI/%E9%83%A8%E7%BD%B2fastgpt.md)

### Docker

- [使用docker离线部署环境](./Docker/%E4%BD%BF%E7%94%A8docker%E7%A6%BB%E7%BA%BF%E9%83%A8%E7%BD%B2%E7%8E%AF%E5%A2%83.md)
- [应用容器部署](./Docker/%E5%BA%94%E7%94%A8%E5%AE%B9%E5%99%A8%E9%83%A8%E7%BD%B2.md)

### Git

- [Git + Maven + Jenkins 实现自动化部署 - JMCui - 博客园](./Git/Git%20%2B%20Maven%20%2B%20Jenkins%20%E5%AE%9E%E7%8E%B0%E8%87%AA%E5%8A%A8%E5%8C%96%E9%83%A8%E7%BD%B2%20-%20JMCui%20-%20%E5%8D%9A%E5%AE%A2%E5%9B%AD.md)
- [Git 在团队中的最佳实践--如何正确使用Git Flow - wish123 - 博客园](./Git/Git%20%E5%9C%A8%E5%9B%A2%E9%98%9F%E4%B8%AD%E7%9A%84%E6%9C%80%E4%BD%B3%E5%AE%9E%E8%B7%B5--%E5%A6%82%E4%BD%95%E6%AD%A3%E7%A1%AE%E4%BD%BF%E7%94%A8Git%20Flow%20-%20wish123%20-%20%E5%8D%9A%E5%AE%A2%E5%9B%AD.md)

### Linux

- [CentOS7 LAMP环境部署](./Linux/CentOS7%20LAMP%E7%8E%AF%E5%A2%83%E9%83%A8%E7%BD%B2.md)
- [CentOS7 服务器之间NFS文件共享挂载](./Linux/CentOS7%20%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B9%8B%E9%97%B4NFS%E6%96%87%E4%BB%B6%E5%85%B1%E4%BA%AB%E6%8C%82%E8%BD%BD.md)
- [CentOS7切换多版本jdk](./Linux/CentOS7%E5%88%87%E6%8D%A2%E5%A4%9A%E7%89%88%E6%9C%ACjdk.md)
- [CentOS7安装vsftp](./Linux/CentOS7%E5%AE%89%E8%A3%85vsftp.md)
- [CentOS7忘记密码怎么办-CSDN博客](./Linux/CentOS7%E5%BF%98%E8%AE%B0%E5%AF%86%E7%A0%81%E6%80%8E%E4%B9%88%E5%8A%9E-CSDN%E5%8D%9A%E5%AE%A2.md)
- [CentOS7新增磁盘分区、格式化、挂载](./Linux/CentOS7%E6%96%B0%E5%A2%9E%E7%A3%81%E7%9B%98%E5%88%86%E5%8C%BA%E3%80%81%E6%A0%BC%E5%BC%8F%E5%8C%96%E3%80%81%E6%8C%82%E8%BD%BD.md)
- [CentOS7虚拟机扩磁盘](./Linux/CentOS7%E8%99%9A%E6%8B%9F%E6%9C%BA%E6%89%A9%E7%A3%81%E7%9B%98.md)
- [CentOS7通过ISO文件制作yum源](./Linux/CentOS7%E9%80%9A%E8%BF%87ISO%E6%96%87%E4%BB%B6%E5%88%B6%E4%BD%9Cyum%E6%BA%90.md)
- [CentOS安装InfluxDB](./Linux/CentOS%E5%AE%89%E8%A3%85InfluxDB.md)
- [Linux安装Neo4j](./Linux/Linux%E5%AE%89%E8%A3%85Neo4j.md)
- [Ubuntu基础环境搭建](./Linux/Ubuntu%E5%9F%BA%E7%A1%80%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA.md)
- [如何用九条命令在一分钟内检查Linux服务器性能？ - Sureing - 博客园](./Linux/%E5%A6%82%E4%BD%95%E7%94%A8%E4%B9%9D%E6%9D%A1%E5%91%BD%E4%BB%A4%E5%9C%A8%E4%B8%80%E5%88%86%E9%92%9F%E5%86%85%E6%A3%80%E6%9F%A5Linux%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%80%A7%E8%83%BD%EF%BC%9F%20-%20Sureing%20-%20%E5%8D%9A%E5%AE%A2%E5%9B%AD.md)
- [安装 fail2ban 拦截异常登录](./Linux/%E5%AE%89%E8%A3%85%20fail2ban%20%E6%8B%A6%E6%88%AA%E5%BC%82%E5%B8%B8%E7%99%BB%E5%BD%95.md)
- [设置SSH免密码登录](./Linux/%E8%AE%BE%E7%BD%AESSH%E5%85%8D%E5%AF%86%E7%A0%81%E7%99%BB%E5%BD%95.md)

### MacOS

- [Mac下安装iTerm2+oh-my-zsh+配色（详细教程） - Tsingke - 博客园](./MacOS/Mac%E4%B8%8B%E5%AE%89%E8%A3%85iTerm2%2Boh-my-zsh%2B%E9%85%8D%E8%89%B2%EF%BC%88%E8%AF%A6%E7%BB%86%E6%95%99%E7%A8%8B%EF%BC%89%20-%20Tsingke%20-%20%E5%8D%9A%E5%AE%A2%E5%9B%AD.md)

### windows

- [windows远程桌面连接服务默认3389端口修改教程 - 知乎](./windows/windows%E8%BF%9C%E7%A8%8B%E6%A1%8C%E9%9D%A2%E8%BF%9E%E6%8E%A5%E6%9C%8D%E5%8A%A1%E9%BB%98%E8%AE%A43389%E7%AB%AF%E5%8F%A3%E4%BF%AE%E6%94%B9%E6%95%99%E7%A8%8B%20-%20%E7%9F%A5%E4%B9%8E.md)

### 业务知识

- [2小时，我搭了一套智能可视化工程项目管理系统！140个业务报表](./%E4%B8%9A%E5%8A%A1%E7%9F%A5%E8%AF%86/2%E5%B0%8F%E6%97%B6%EF%BC%8C%E6%88%91%E6%90%AD%E4%BA%86%E4%B8%80%E5%A5%97%E6%99%BA%E8%83%BD%E5%8F%AF%E8%A7%86%E5%8C%96%E5%B7%A5%E7%A8%8B%E9%A1%B9%E7%9B%AE%E7%AE%A1%E7%90%86%E7%B3%BB%E7%BB%9F%EF%BC%81140%E4%B8%AA%E4%B8%9A%E5%8A%A1%E6%8A%A5%E8%A1%A8.md)
- [【知识分享】一文详解，MES、ERP、WMS、OMS、TMS、CRM、SCM、SRM、PLM……](./%E4%B8%9A%E5%8A%A1%E7%9F%A5%E8%AF%86/%E3%80%90%E7%9F%A5%E8%AF%86%E5%88%86%E4%BA%AB%E3%80%91%E4%B8%80%E6%96%87%E8%AF%A6%E8%A7%A3%EF%BC%8CMES%E3%80%81ERP%E3%80%81WMS%E3%80%81OMS%E3%80%81TMS%E3%80%81CRM%E3%80%81SCM%E3%80%81SRM%E3%80%81PLM%E2%80%A6%E2%80%A6.md)
- [一文详解MES、ERP、SCM、WMS、APS、SCADA、PLM、QMS、CRM、EAM及其关系 - 知乎](./%E4%B8%9A%E5%8A%A1%E7%9F%A5%E8%AF%86/%E4%B8%80%E6%96%87%E8%AF%A6%E8%A7%A3MES%E3%80%81ERP%E3%80%81SCM%E3%80%81WMS%E3%80%81APS%E3%80%81SCADA%E3%80%81PLM%E3%80%81QMS%E3%80%81CRM%E3%80%81EAM%E5%8F%8A%E5%85%B6%E5%85%B3%E7%B3%BB%20-%20%E7%9F%A5%E4%B9%8E.md)
- [设备备件管理基础知识讲解](./%E4%B8%9A%E5%8A%A1%E7%9F%A5%E8%AF%86/%E8%AE%BE%E5%A4%87%E5%A4%87%E4%BB%B6%E7%AE%A1%E7%90%86%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86%E8%AE%B2%E8%A7%A3.md)

### 开发技术

- [fastjson_1_upgrade_cn · alibaba fastjson2 Wiki](./%E5%BC%80%E5%8F%91%E6%8A%80%E6%9C%AF/fastjson_1_upgrade_cn%20%C2%B7%20alibaba%20fastjson2%20Wiki.md)
- [新来了个同事，代码命名规范是真优雅呀！代码如诗！！](./%E5%BC%80%E5%8F%91%E6%8A%80%E6%9C%AF/%E6%96%B0%E6%9D%A5%E4%BA%86%E4%B8%AA%E5%90%8C%E4%BA%8B%EF%BC%8C%E4%BB%A3%E7%A0%81%E5%91%BD%E5%90%8D%E8%A7%84%E8%8C%83%E6%98%AF%E7%9C%9F%E4%BC%98%E9%9B%85%E5%91%80%EF%BC%81%E4%BB%A3%E7%A0%81%E5%A6%82%E8%AF%97%EF%BC%81%EF%BC%81.md)
- [监控厂商RTSP规则](./%E5%BC%80%E5%8F%91%E6%8A%80%E6%9C%AF/%E7%9B%91%E6%8E%A7%E5%8E%82%E5%95%86RTSP%E8%A7%84%E5%88%99.md)

### 开发环境

- [OPC和DCOM配置 - ioufev - 博客园](./%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83/OPC%E5%92%8CDCOM%E9%85%8D%E7%BD%AE%20-%20ioufev%20-%20%E5%8D%9A%E5%AE%A2%E5%9B%AD.md)
- [npm 设置源 淘宝 阿里 腾讯 华为 网易 中科 清华 - 知乎](./%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83/npm%20%E8%AE%BE%E7%BD%AE%E6%BA%90%20%E6%B7%98%E5%AE%9D%20%E9%98%BF%E9%87%8C%20%E8%85%BE%E8%AE%AF%20%E5%8D%8E%E4%B8%BA%20%E7%BD%91%E6%98%93%20%E4%B8%AD%E7%A7%91%20%E6%B8%85%E5%8D%8E%20-%20%E7%9F%A5%E4%B9%8E.md)
- [基于开源的GB28181-WVP搭建一个视频监控系统](./%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83/%E5%9F%BA%E4%BA%8E%E5%BC%80%E6%BA%90%E7%9A%84GB28181-WVP%E6%90%AD%E5%BB%BA%E4%B8%80%E4%B8%AA%E8%A7%86%E9%A2%91%E7%9B%91%E6%8E%A7%E7%B3%BB%E7%BB%9F.md)

### 群辉

- [群晖 NAS Docker 部署 OpenClaw优雅实践 - 知乎](./%E7%BE%A4%E8%BE%89/%E7%BE%A4%E6%99%96%20NAS%20Docker%20%E9%83%A8%E7%BD%B2%20OpenClaw%E4%BC%98%E9%9B%85%E5%AE%9E%E8%B7%B5%20-%20%E7%9F%A5%E4%B9%8E.md)
- [群晖上用Docker部署Mihomo实录 老苏的blog](./%E7%BE%A4%E8%BE%89/%E7%BE%A4%E6%99%96%E4%B8%8A%E7%94%A8Docker%E9%83%A8%E7%BD%B2Mihomo%E5%AE%9E%E5%BD%95%20%E8%80%81%E8%8B%8F%E7%9A%84blog.md)

### 其它

- [overleaf](./%E5%85%B6%E5%AE%83/overleaf.md)
- [overleaf相关操作](./%E5%85%B6%E5%AE%83/overleaf%E7%9B%B8%E5%85%B3%E6%93%8D%E4%BD%9C.md)

## 使用方式

### 用 Obsidian 打开

直接把仓库根目录作为 Vault 打开即可，目录分类和附件引用已经按 Obsidian 的使用习惯整理。

### 用 Git 同步

```bash
git clone https://github.com/zhanglei-tech/web-favorites.git
```

### 快速检索

```bash
rg "关键词"
```

## 维护约定

- 优先按主题放入现有分类目录，避免同类内容分散。
- 外部转载或整理文档，文件名保留原题目和来源，便于追溯。
- 图片、脚本、配置文件统一放在 `attachment/` 下，并尽量与文档主题保持同名目录。
- `README.md` 作为总索引，新增文档后建议同步更新对应分类和统计数量。

## 说明

仓库中的部分文档来自公开技术文章或个人整理笔记，仅用于学习、归档和检索。如涉及版权或引用问题，可按需删除或调整。
