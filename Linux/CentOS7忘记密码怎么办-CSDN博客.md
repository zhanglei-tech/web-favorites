# CentOS7忘记密码怎么办-CSDN博客
版权声明：本文为博主原创文章，遵循 [CC 4.0 BY-SA](http://creativecommons.org/licenses/by-sa/4.0/) 版权协议，转载请附上原文出处链接和本声明。

### 1、首先 开启 虚拟系统时，按住esc键进入如下界面

![](https://i-blog.csdnimg.cn/blog_migrate/4bc289c0a4586071af3b288f5c1521ec.png)

### 2、然后根据提示按 e 键，进入编辑选项

![](https://i-blog.csdnimg.cn/blog_migrate/aafe552750fffd2f058df68bec7ececd.png)

在 UTF-8 行编辑修改两处，首相将ro改为rw，即只读改为可读写权限，然后在尾部加入 init\=/bin/sh

改成如下：

![](https://i-blog.csdnimg.cn/blog_migrate/bea723224aec5e0adaa132e2b3596250.png)

这里提示一下，有些小伙伴的屏幕没找到UTF-8这行，原因是因为屏幕显示 信息 有限，按键盘“下”方向键就显示出来了。

### 3、此时按住Ctrl+ x 快捷键进入拯救模式

![](https://i-blog.csdnimg.cn/blog_migrate/a61da2d5f5e0e0427bfa28f209e806f8.png)

### 4、修改 root 用的新密码为123456，修改命令如下:

###         命令：echo "123456"|passwd --stdin root

![](https://i-blog.csdnimg.cn/blog_migrate/250a7c772dedec9526d0b7552beed823.png)

回车出现如下界面

![](https://i-blog.csdnimg.cn/blog_migrate/d310524cfe2a9eb78b73dc48b5465ce8.png)

### 5、再输入以下命令更新 系统 信息

###         命令： touch   /.autorelabel

![](https://i-blog.csdnimg.cn/blog_migrate/ccfc4b280b2f08fb309535db5ad9d5e0.png)

### 6、重启系统

输入   exec /sbin/init       重启系统

### 7、重新登陆

此时你就可以用你修改的新密码123456登入系统了。

![](https://i-blog.csdnimg.cn/blog_migrate/a4502b0bba76e8a381e5bbc94c8ed592.png)