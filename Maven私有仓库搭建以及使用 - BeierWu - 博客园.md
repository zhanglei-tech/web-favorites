# Maven私有仓库搭建以及使用 - BeierWu - 博客园
　　![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130143526971-202493577.png)

```

```

　　![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130143719855-2072198209.png)

```

```

　　现在已经安装完成了 nexus。

           访问：[http://ip:8081/nexus](http://ip:8081/nexus)  使用默认管理员身份登录，帐号：admin，密码：admin123

                    ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130152900654-1050282508.png)

 2、进入管理界面
---------

            ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130154444686-2001929600.png)

*   Browse可以查看当前有多少仓库，搭建好的Nexus，默认会带有一些maven仓库，一般使用这些仓库就足够了。
*   默认仓库说明    

          maven-central：maven中央库，默认从https://repo1.maven.org/maven2/拉取jar

          maven-releases：私库发行版jar，初次安装请将Deployment policy设置为Allow redeploy

          maven-snapshots：私库快照（调试版本）jar

          maven-public：仓库分组，把上面三个仓库组合在一起对外提供服务，在本地maven基础配置settings.xml或项目pom.xml中使用

*   仓库类型    

           Group：这是一个仓库聚合的概念，用户仓库地址选择Group的地址，即可访问Group中配置的，用于方便开发人员自己设定的仓库。maven-public就是一个Group类型的仓库，内部设置了多个仓库，访问顺序取决于配置顺序，3.x默认Releases，Snapshots，                                  Central，当然你也可以自己设置。  
           Hosted：私有仓库，内部项目的发布仓库，专门用来存储我们自己生成的jar文件  
           3rd party：未发布到公网的第三方jar (3.x去除了)  
           Snapshots：本地项目的快照仓库  
           Releases： 本地项目发布的正式版本  
           Proxy：代理类型，从远程中央仓库中寻找数据的仓库（可以点击对应的仓库的Configuration页签下Remote Storage属性的值即被代理的远程仓库的路径），如可配置阿里云maven仓库  
          Central：中央仓库  
          Apache Snapshots：Apache专用快照仓库(3.x去除了)

 3、增加新的代理源
----------

             第一步 按照步骤添加新的代理源

              ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130154948336-886273.png)

###              第二步选择添加maven2的代理

___             ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130155307628-2089844715.png)
___

###             第三步添加代理（Cache统一设置为200天 288000）

            ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130155458779-1665135957.png)

            ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130155916434-67749094.png)

###            第四步逐个增加常用代理

![](https://assets.cnblogs.com/images/copycode.gif)

1. aliyun
http://maven.aliyun.com/nexus/content/groups/public
2. apache\_snapshot
https://repository.apache.org/content/repositories/snapshots/
3. apache\_release
https://repository.apache.org/content/repositories/releases/
4. atlassian
https://maven.atlassian.com/content/repositories/atlassian-public/
5. central.maven.org
http://central.maven.org/maven2/
6. datanucleus
http://www.datanucleus.org/downloads/maven2
7. maven-central （安装后自带，仅需设置Cache有效期即可）
https://repo1.maven.org/maven2/
8. nexus.axiomalaska.com
http://nexus.axiomalaska.com/nexus/content/repositories/public
9. oss.sonatype.org
https://oss.sonatype.org/content/repositories/snapshots
10.pentaho
https://public.nexus.pentaho.org/content/groups/omni/

![](https://assets.cnblogs.com/images/copycode.gif)

###               第五步 设置maven-public 将这些代理加入Group，最好将默认的maven库放到最底下

                ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130160504123-979533222.png)

###                第六步 设置私用仓库可重复发布

                 Nexus安装后自带maven-releases，maven-snapshots两个仓库，用于将生成的jar包发布在这两个仓库中，在实际开发中需要将maven-releases设置为可以重复发布

               ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130161008617-752247636.png)

4、Maven配置使用Nexus
----------------

        修改.m2下面的setting.xml文件配置

![](https://assets.cnblogs.com/images/copycode.gif)

<?xml version="1.0" encoding="UTF-8"?>

<!-- Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License. \-->

<!--
 | This is the configuration file for Maven. It can be specified at two levels: |
 |  1. User Level. This settings.xml file provides configuration for a single user, |                 and is normally provided in ${user.home}/.m2/settings.xml. |
 | NOTE: This location can be overridden with the CLI option: |
 |                 -s /path/to/user/settings.xml |
 |  2. Global Level. This settings.xml file provides configuration for all Maven |                 users on a machine (assuming they're all using the same Maven
 |                 installation). It's normally provided in
 |                 ${maven.conf}/settings.xml. |
 | NOTE: This location can be overridden with the CLI option: |
 |                 -gs /path/to/global/settings.xml |
 | The sections in this sample file are intended to give you a running start at | getting the most out of your Maven installation. Where appropriate, the default
 | values (values used when the setting is not specified) are provided. |
 |-->
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi\="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation\="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd"\>
  <!-- localRepository | The path to the local repository maven will use to store artifacts. |
   | Default: ${user.home}/.m2/repository \-->
  <localRepository>${user.home}/.m2/repository</localRepository>

  <!-- interactiveMode | This will determine whether maven prompts you when it needs input. If set to false, | maven will use a sensible default value, perhaps based on some other setting, for
   | the parameter in question. |
   | Default: true
  <interactiveMode>true</interactiveMode>
  -->

  <!-- offline | Determines whether maven should attempt to connect to the network when executing a build. | This will have an effect on artifact downloads, artifact deployment, and others. |
   | Default: false
  <offline>false</offline>
  -->

  <!-- pluginGroups | This is a list of additional group identifiers that will be searched when resolving plugins by their prefix, i.e. | when invoking a command line like "mvn prefix:goal". Maven will automatically add the group identifiers | "org.apache.maven.plugins" and "org.codehaus.mojo" if these are not already contained in the list. |-->
  <pluginGroups>
    <!-- pluginGroup | Specifies a further group identifier to use for plugin lookup. <pluginGroup>com.your.plugins</pluginGroup>
    -->
  </pluginGroups>

  <!-- proxies | This is a list of proxies which can be used on this machine to connect to the network. | Unless otherwise specified (by system property or command-line switch), the first proxy | specification in this list marked as active will be used. |-->
  <proxies>
    <!-- proxy | Specification for one proxy, to be used in connecting to the network. |
    <proxy>
      <id>optional</id>
      <active>true</active>
      <protocol>http</protocol>
      <username>proxyuser</username>
      <password>proxypass</password>
      <host>proxy.host.net</host>
      <port>80</port>
      <nonProxyHosts>local.net|some.host.com</nonProxyHosts>
    </proxy>
    -->
  </proxies>

  <!-- servers | This is a list of authentication profiles, keyed by the server-id used within the system. | Authentication profiles can be used whenever maven must make a connection to a remote server. |-->
  <servers>
    <!-- server | Specifies the authentication information to use when connecting to a particular server, identified by | a unique name within the system (referred to by the 'id' attribute below). |
     | NOTE: You should either specify username/password OR privateKey/passphrase, since these pairings are | used together. |
    -->
    
    <server>
      <id>releases</id>
      <username>admin</username>
      <password>admin23</password>
    </server>
    
    <server>
      <id>snapshots</id>
      <username>admin</username>
      <password>admin123</password>
    </server>

    <!-- Another sample, using keys to authenticate. <server>
      <id>siteServer</id>
      <privateKey>/path/to/private/key</privateKey>
      <passphrase>optional; leave empty if not used.</passphrase>
    </server>
    -->
  </servers>

  <!-- mirrors | This is a list of mirrors to be used in downloading artifacts from remote repositories. |
   | It works like this: a POM may declare a repository to use in resolving certain artifacts. | However, this repository may have problems with heavy traffic at times, so people have mirrored | it to several places. |
   | That repository definition will have a unique id, so we can create a mirror reference for that | repository, to be used as an alternate download site. The mirror site will be the preferred | server for that repository. |-->
  <mirrors>
    <!-- mirror | Specifies a repository mirror site to use instead of a given repository. The repository that | this mirror serves has an ID that matches the mirrorOf element of this mirror. IDs are used | for inheritance and direct lookup purposes, and must be unique across the set of mirrors. |
    -->
    <mirror>
      <id>HolliParkMirror</id>
      <mirrorOf>\*</mirrorOf>
      <name>HolliPark Repository Mirror.</name>
      <url>http://localhost:8082/nexus/repository/maven-public/</url>
    </mirror>
       
  </mirrors>

  <!-- profiles | This is a list of profiles which can be activated in a variety of ways, and which can modify | the build process. Profiles provided in the settings.xml are intended to provide local machine-
   | specific paths and repository locations which allow the build to work in the local environment. |
   | For example, if you have an integration testing plugin - like cactus - that needs to know where
   | your Tomcat instance is installed, you can provide a variable here such that the variable is
   | dereferenced during the build process to configure the cactus plugin. |
   | As noted above, profiles can be activated in a variety of ways. One way - the activeProfiles | section of this document (settings.xml) - will be discussed later. Another way essentially | relies on the detection of a system property, either matching a particular value for the property, | or merely testing its existence. Profiles can also be activated by JDK version prefix, where a | value of '1.4' might activate a profile when the build is executed on a JDK version of '1.4.2\_07'. | Finally, the list of active profiles can be specified directly from the command line. |
   | NOTE: For profiles defined in the settings.xml, you are restricted to specifying only artifact |       repositories, plugin repositories, and free-form properties to be used as configuration |       variables for plugins in the POM. |
   |-->
  <profiles>
    <profile>
      <id>HolliPark</id>
      <repositories>
        <repository>
          <id>nexus</id>
          <name>Public Repositories</name>
          <url>http://localhost:8082/nexus/repository/maven-public/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
        </repository>
      
        <repository>
          <id>central</id>
          <name>Central Repositories</name>
          <url>http://localhost:8082/nexus/repository/maven-central/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>false</enabled>
          </snapshots>
        </repository>
        
        <repository>
          <id>release</id>
          <name>Release Repositories</name>
          <url>http://localhost:8082/nexus/repository/maven-releases/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>false</enabled>
          </snapshots>
        </repository>
        
        <repository>
          <id>snapshots</id>
          <name>Snapshot Repositories</name>
          <url>http://localhost:8082/nexus/repository/maven-snapshots/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </repository>
      </repositories>
      
      <pluginRepositories>
        <pluginRepository>
          <id>plugins</id>
          <name>Plugin Repositories</name>
          <url>http://localhost:8082/nexus/repository/maven-public/</url>
        </pluginRepository>
      </pluginRepositories>
    </profile>
    <!-- profile | Specifies a set of introductions to the build process, to be activated using one or more of the | mechanisms described above. For inheritance purposes, and to activate profiles via <activatedProfiles/>
     | or the command line, profiles have to have an ID that is unique. |
     | An encouraged best practice for profile identification is to use a consistent naming convention | for profiles, such as 'env-dev', 'env-test', 'env-production', 'user-jdcasey', 'user-brett', etc. | This will make it more intuitive to understand what the set of introduced profiles is attempting | to accomplish, particularly when you only have a list of profile id's for debug.
     |
     | This profile example uses the JDK version to trigger activation, and provides a JDK-specific repo. <profile>
      <id>jdk-1.4</id>

      <activation>
        <jdk>1.4</jdk>
      </activation>

      <repositories>
        <repository>
          <id>jdk14</id>
          <name>Repository for JDK 1.4 builds</name>
          <url>http://www.myhost.com/maven/jdk14</url>
          <layout>default</layout>
          <snapshotPolicy>always</snapshotPolicy>
        </repository>
      </repositories>
    </profile>
    -->
    
    <!--
     | Here is another profile, activated by the system property 'target-env' with a value of 'dev', | which provides a specific path to the Tomcat instance. To use this, your plugin configuration | might hypothetically look like: |
     | ... | <plugin>
     |   <groupId>org.myco.myplugins</groupId>
     |   <artifactId>myplugin</artifactId>
     |
     |   <configuration>
     |     <tomcatLocation>${tomcatPath}</tomcatLocation>
     |   </configuration>
     | </plugin>
     | ... |
     | NOTE: If you just wanted to inject this configuration whenever someone set 'target-env' to |       anything, you could just leave off the <value/> inside the activation-property. |
    <profile>
      <id>env-dev</id>

      <activation>
        <property>
          <name>target-env</name>
          <value>dev</value>
        </property>
      </activation>

      <properties>
        <tomcatPath>/path/to/tomcat/instance</tomcatPath>
      </properties>
    </profile>
    -->
  </profiles>

  <!-- activeProfiles | List of profiles that are active for all builds. |
  <activeProfiles>
    <activeProfile>alwaysActiveProfile</activeProfile>
    <activeProfile>anotherAlwaysActiveProfile</activeProfile>
  </activeProfiles>
  -->
  
  <activeProfiles>
    <activeProfile>HolliPark</activeProfile>
  </activeProfiles>
  
</settings>

![](https://assets.cnblogs.com/images/copycode.gif)

              ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130164723064-912123935.png)

  2、修改项目的pom.xml
----------------

                    在pom文件中加入distributionManagement节点，注意：pom.xml中repository里的id需要和.m2中setting.xml里的server id名称保持一致

![](https://assets.cnblogs.com/images/copycode.gif)

<distributionManagement>  
    <repository>  
        <id>releases</id>  
        <name>Nexus Release Repository</name>  
        <url>http://localhost:8082/nexus/repository/maven-releases/</url>  
    </repository>  
    <snapshotRepository>  
        <id>snapshots</id>  
        <name>Nexus Snapshot Repository</name>  
        <url>http://localhost:8082/nexus/repository/maven-snapshots/</url>  
    </snapshotRepository>  
</distributionManagement>

![](https://assets.cnblogs.com/images/copycode.gif)

3、发布私有公库
--------

                            执行部署命令即可发布。

                            登录Nexus，查看对应的仓库已经有相关的依赖包了

                     ![](https://img2018.cnblogs.com/blog/57115/201901/57115-20190130165726723-1645832423.png)

         注意以下几点：         

*    若项目版本号末尾带有 -SNAPSHOT，则会发布到snapshots快照版本仓库
*    若项目版本号末尾带有 -RELEASES 或什么都不带，则会发布到releases正式版本仓库