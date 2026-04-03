# Git + Maven + Jenkins 实现自动化部署 - JMCui - 博客园
一、安装 和 准备工作
-----------

    我们选择了用 Tomcat 服务器下 war 包的安装方式。Jenkins 的下载地址：[http://mirrors.jenkins-ci.org/](http://mirrors.jenkins-ci.org/)，打开链接后，表格有war列。Releases行是短期更新包，LTS行是长期更新包。一般选择Releases下载即可。将下载完成的 war 包 放在 Tomcat 服务器的 webapps 目录下，然后启动服务器即可。建议单独用一台 Tomcat 服务器部署，方便管理。

    **1、**Tomcat 服务器运行起来后，用浏览器访问 **http://ip地址:端口号/jenkins** 如下图：

         ![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413145050744-60898540.png)

    **2、**在 Linux 服务器上执行 **cat /root/.jenkins/secrets/initialAdminPassword** 复制密码并粘贴：

       ![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413145508613-779010275.png)

    **3、**安装推荐的插件即可。插件安装完成后，可以创建一个管理员账户：

        ![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413150037391-1877712014.png)

  **4、**创建用户后，进入Jenkins ，页面如下图：

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413150331831-564815109.png)

    **5、**点击 **系统管理 --> 管理插件 --> 可选插件** ，搜索 **Maven Integration** （用来Maven 编译打包）和 **Publish Over SSH** （用于远程服务器发布） 插件，安装完成后重启：**http://IP地址:端口号/jenkins/restart**

**![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413151207218-2055185217.png)**

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413151251862-982043565.png)

    **6、**点击 **系统管理 --> 全局工具配置**，安装配置好 JDK、Maven 和 Git。不会安装的自行百度...

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413161321658-636825695.png)

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413161353985-2052862447.png)

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413161429092-1061970146.png)

tips：安装好 git 后请把服务器公钥添加到 gitlab 服务器。 

二、构建 Maven 项目 
--------------

    **1、**输入任务名称，选择 **构建一个 Maven 项目：** 

**![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413162658615-1118805326.png)**

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413163045653-1955726872.png)

    **2、源码管理**

**![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413164026148-748539225.png)**

    **3、构建触发器**

**![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413164345065-1356528751.png)**

build whenever a snapshot dependency is built -->当job依赖的快照版本被build时，执行本job。  
build after other projects are built -->当本job依赖的job被build时，执行本job  
build periodically -->隔一段时间build一次，不管版本库代码是否发生变化，通常不会采用此种方式。  
poll scm -->隔一段时间比较一次源代码如果发生变更，那么就build。否则，不进行build，通常采用这种方式。

这里我选择手动触发部署，所以没有勾选任何一项。

    **4、构建环境**

**![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413164658330-1851687316.png)**

Delete workspace before build starts --> 默认删除所有的,也可以设置删除特定的文件

\- Patterns for files to be deleted:正则匹配删除哪些文件  
\- Apply pattern also on directories:规则是否也应用到文件夹  
\- Check parameter:是否删除,是个bool值,true则删除,false不删除  
\- External Deletion Command:执行外部删除命令

Abort the build if it’s stuck --> 构建阻塞的时候,根据超时策略处理.

\- Time-out strategy:超时策略,有绝对时间,相对时间,根据以前的构建时间判断等  
\- Time-out variable:超时时间  
\- Time-out actions:超时后的处理,如终结,faile调或者写描述  
\- Add timestamps to the Console Output:在输出界面添加时间戳  
\- Use secret text(s) or file:使用密文,用于全局性的管理密码等,勾选后会在下方出现Binding,输入需要的用户名,密码证书等就可以了。

  **5、Build**

**![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180413165245033-732071372.png)**

     **6、Post Steps**

当Maven 编译打包完成后，接下来的工作就是 把 war包 解压到 Tomcat 服务器的 /webapps/ROOT 目录下，然后重启服务器。为此准备了两个脚本 deploy.sh (解压war包并重启服务器)，重启服务器 用到了另一个脚本 restart.sh 。接下来看一下这两个脚本的具体内容：

deploy.sh 

![](https://assets.cnblogs.com/images/copycode.gif)

#!/bin/sh war\=$1 bin\=$(cd \`dirname $0\`; pwd) if \[ ! -n "${war}" \]; then
    echo "\*\*\*Usage: $0 \[project.war\]" exit 0
fi
if \[ ! -f "${war}" \]; then
    echo "\*\*\*Error: ${war} does not exist." exit 0
fi
if \[ ! "${war##\*.}" = "war" \]; then
    echo "\*\*\*Error: ${war} is not a war file." exit 0
fi

echo "Deploy ${war##\*/}..."
rm -rf ${bin}/../webapps/ROOT/ cd ${bin}/../webapps && mkdir ROOT && cd ROOT
jar \-xvf ${war} rm -rf ${bin}/../work/Catalina/localhost/
echo "Restart tomcat..."
sh ${bin}/restart.sh

![](https://assets.cnblogs.com/images/copycode.gif)

备注：1、deploy.sh会先清空tomcat下的ROOT目录，再将指定的war包加压至ROOT目录，最后执行restart.sh重启tomcat。

          2、可以使用 unzip 命令 直接解压，但是我发现我们服务器上经常没有安装 unzip 这个软件，所以选择了如上的方式。

          3、一键发布命令：./deploy.sh 项目war包    例如：./deploy.sh /home/test.war 。

restart.sh

![](https://assets.cnblogs.com/images/copycode.gif)

#!/bin/sh bin\=$(cd \`dirname $0\`; pwd)
pid\=$(ps aux | grep tomcat | grep -v grep | grep -v restart | grep ${bin} | awk '{print $2}') if \[ -n "${pid}" \]; then
    echo "Shutdown..."
    sh ${bin}/shutdown.sh
    sleep 3 pid\=$(ps aux | grep tomcat | grep -v grep | grep -v restart | grep ${bin} | awk '{print $2}') if \[ -n "${pid}" \]; then
        kill -9 ${pid} sleep 1
    fi
fi

echo "Startup..."
sh ${bin}/startup.sh
if \[ "$1" = "\-v" \]; then
    tail -f -n 600 ${bin}/../logs/catalina.out fi

![](https://assets.cnblogs.com/images/copycode.gif)

备注：1、restart.sh是用来重启tomcat的，如果tomcat没有启动则直接启动，如果已经启动就先shutdown再启动，如果shutdown之后3s没有停掉tomcat进程，则kill掉原来的进程再启动。

          2、如需重启tomcat则使用命令：./restart.sh 或 ./restart.sh -v （参数-v表示启动时打印tomcat启动日志）。

**实施方案**： 把 deploy.sh 和 restart.sh 拷贝到 Tomcat 的bin目录下，再用chmod +x 给这两个脚本赋上可执行权限。

**本地部署方案：** 

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180416114520081-1743051383.png)

![](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif)

#!/bin/sh export BUILD\_ID\=qianxx sh /home/wwwroot/t8\_8280\_passenger/bin/deploy.sh ${WORKSPACE}/target/\*.war

View Code

**远程服务器部署方案：** 

1.  添加服务器

**系统管理** --> **系统设置** \-->**Publish over SSH** ，服务器配置如下：

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180416124757174-1005531163.png)

2\. 工程中配置

![](https://images2018.cnblogs.com/blog/1153954/201804/1153954-20180416125755531-1465208439.png)

![](https://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif)

/home/wwwroot/t8\_8180\_common/bin/deploy.sh /root/common/\*.war

View Code