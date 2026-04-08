# Mac下安装iTerm2+oh-my-zsh+配色（详细教程） - Tsingke - 博客园
**Mac下安装iTerm2+oh-my-zsh+配色（详细教程）**

**先展示iterm2改装后对效果图（几百种方案可选）：** 

![](https://img2020.cnblogs.com/blog/647396/202102/647396-20210210222738429-1579392264.png)
![](https://img2020.cnblogs.com/blog/647396/202102/647396-20210210223007751-1607648639.png)

![](https://img2020.cnblogs.com/blog/647396/202102/647396-20210210223139400-360969871.png)
![](https://img2020.cnblogs.com/blog/647396/202102/647396-20210210223342040-71443280.png)

* * *

**网上虽然教程很多，但是很多还是不够详细，本文总结一篇比较容易安装的图文教程，帮助大家配置个人对iterm+oh-my-zsh**

![](https://upload-images.jianshu.io/upload_images/3425146-c1ba2b0d139adb96.png?imageMogr2/auto-orient/strip|imageView2/2/w/698/format/webp)

效果图，很帅气有木有

### 一、首先安装[iTem2](https://links.jianshu.com/go?to=http%3A%2F%2Fwww.iterm2.com%2Fdownloads.html)

*   安装好后的截图如下：

![](https://upload-images.jianshu.io/upload_images/3425146-28aa9724e1af901d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1140/format/webp)

安装好后的截图

### 二、安装[oh-my-zsh](https://links.jianshu.com/go?to=http%3A%2F%2Fohmyz.sh%2F)。

*   方式一（如果无法安装可通过方式二进行安装）：
    
    ```null
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    
    ```
    
*   方式二：  
    1、下载`oh-my-zsh`，从[Github地址](https://links.jianshu.com/go?to=%255Bhttps%3A%2F%2Fgithub.com%2Fohmyzsh%2Fohmyzsh%255D%28https%3A%2F%2Fgithub.com%2Fohmyzsh%2Fohmyzsh%29)或[Gitee地址](https://links.jianshu.com/go?to=%255Bhttps%3A%2F%2Fgitee.com%2Fmirrors%2Foh-my-zsh)下载：  
    2、解压后进入到tools目录执行install.sh

![](https://upload-images.jianshu.io/upload_images/3425146-a64ce203fb538ba0.png?imageMogr2/auto-orient/strip|imageView2/2/w/776/format/webp)

image.png

*   卸载：
    
    ```null
    卸载oh-my-zsh命令：uninstall_oh_my_zsh
    
    ```
    

![](https://upload-images.jianshu.io/upload_images/3425146-0dc4212b68292d38.png?imageMogr2/auto-orient/strip|imageView2/2/w/1154/format/webp)

安装oh-my-zsh

*   安装成功如下图：

![](https://upload-images.jianshu.io/upload_images/3425146-3ccb457edda1dee9.png?imageMogr2/auto-orient/strip|imageView2/2/w/1140/format/webp)

成功安装oh-my-zsh

### 三、安装[Powerline](https://links.jianshu.com/go?to=http%3A%2F%2Fpowerline.readthedocs.io%2Fen%2Flatest%2Finstallation.html)

*   先安装**pip**
*   再安装**Powerline**
    
    ```null
    pip install powerline-status
    
    ```
    

### 四、安装 [Meslo](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fpowerline%2Ffonts) 字体库。

*   方法1、可以直接复制下面命令到终端中安装：
    
    ```null
    
    git clone https://github.com/powerline/fonts.git --depth=1
    
    cd fonts
    ./install.sh
    
    cd ..
    rm -rf fonts
    
    ```
    

方法2、单独下载 [Meslo](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fpowerline%2Ffonts%2Fblob%2Fmaster%2FMeslo%2520Slashed%2FMeslo%2520LG%2520M%2520Regular%2520for%2520Powerline.ttf) 字体,点击 view raw 下载字体，然后安装；如下图  
![](https://upload-images.jianshu.io/upload_images/3425146-e3a3f56f700de696.png?imageMogr2/auto-orient/strip|imageView2/2/w/1003/format/webp)

单独下载字体文件

3、配置item2：（`iTerm2>Preferences>Profiles>Text>Change Font`）,如下图：

*   如果没有发现紫色框的`Non-ASCII Font`,先在绿色箭头所指的地方打钩，然后再重启.

![](https://upload-images.jianshu.io/upload_images/3425146-493f75a4c73454f1.png?imageMogr2/auto-orient/strip|imageView2/2/w/918/format/webp)

字体配置图

### 五、安装`solarized配色方案`

*   在下图中所指的地方直接选择就行

![](https://upload-images.jianshu.io/upload_images/3425146-849211c94aea3656.png?imageMogr2/auto-orient/strip|imageView2/2/w/918/format/webp)

### 六、安装`agnoster`主题。

*   oh-my-zsh已经内置该主题,不用再单独下载了

直接配置就行了

*   进入根目录

用vim编辑器打开隐藏文件`.zshrc`，将ZSH\_THEME后面字段改为`agnoster`.  
![](https://upload-images.jianshu.io/upload_images/3425146-dc187df825c95438.png?imageMogr2/auto-orient/strip|imageView2/2/w/650/format/webp)

配置主题

*   重新打开iTerm2，效果如下

![](https://upload-images.jianshu.io/upload_images/3425146-4b29de5741e340b0.png?imageMogr2/auto-orient/strip|imageView2/2/w/754/format/webp)

### 七、设置语法高亮 -- [zsh-syntax-highlighting](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fzsh-users%2Fzsh-syntax-highlighting)

*   直接使用`homebrew`安装`zsh-syntax-highlighting`插件
    
    ```null
    brew install zsh-syntax-highlighting
    
    ```
    
*   然后在根目录下`.zshrc`中插入下面内容：
    
    ```null
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    ```
    
*   在`.zshrc`中插入下面内容：
    
    ```null
    plugins=(
      git
      zsh-syntax-highlighting
    )
    
    ```
    

### 八、代码补全插件

1、`zsh-completions`，Github地址：[zsh-completions](https://links.jianshu.com/go?to=%255Bhttps%3A%2F%2Fgithub.com%2Fzsh-users%2Fzsh-completions%255D%28https%3A%2F%2Fgithub.com%2Fzsh-users%2Fzsh-completions%29)

> *   在oh-my-zsh存储库中克隆存储库:
> 
> ```null
>   git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
> 
> ```
> 
> *   在`.zshrc`中插入下面内容：
> 
> ```null
> plugins=(
>   git
>   zsh-completions
> )
> autoload -U compinit && compinit
> 
> ```

2、`zsh-autosuggestions`：补全的是历史输入的命令，点击方向键`->`即可补全

> *   使用`homebrew`安装
> 
> ```null
> brew install zsh-autosuggestions
> 
> ```
> 
> *   在`.zshrc`中插入下面内容：
> 
> ```null
> plugins=(
>   git
>   zsh-autosuggestions
> )
> 
> ```

### 九、最后再说一下效果图中大拇指👍的配置：

*   进入主题目录

打开**agnoster**主题,按红框里面的编辑保存完退出就好了。

![](https://upload-images.jianshu.io/upload_images/3425146-6b808e0be08a7904.png?imageMogr2/auto-orient/strip|imageView2/2/w/651/format/webp)

### 十、大功告成、喜欢的给点个赞👍

或许有用👇

*   1、查看shell：
*   2、更改shell：
*   3、查看当前shell，但不能时时反映shell，需重启iTerm2：

### 十一、问题

问题一：

> 1、安装（手动下载）完zsh插件后，执行 source ~/.zshrc，显示如下提示：
> 
> ```null
> zsh compinit: insecure directories, run compaudit for list.
> Ignore insecure directories and continue [y] or abort compinit [n]?
> 
> ```
> 
> 2·解决方法：
> 
> ```null
> $ cd /usr/local/share/
> $ sudo chmod -R 755 zsh
> $ sudo chown -R root:staff zsh
> //最后再执行
> source ~/.zshrc
> 
> ```

[参考文章地址：https://blog.csdn.net/weixin\_34077371/article/details/86011940](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.csdn.net%2Fweixin_34077371%2Farticle%2Fdetails%2F86011940)

[iTerm 2 && Oh My Zsh【DIY教程——亲身体验过程】](https://www.jianshu.com/p/7de00c73a2bb)  
[Mac下终端配置（item2 + oh-my-zsh + solarized配色方案）](https://links.jianshu.com/go?to=http%3A%2F%2Fwww.cnblogs.com%2Fweixuqin%2Fp%2F7029177.html)  
[用Powerline美化你的Mac终端和Vim](https://www.jianshu.com/p/68ef9d2e1653)  
[我的 Mac 终端配置（Mac OSX + iTerm2 + Zsh + Oh-My-Zsh）](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.csdn.net%2Fqianghaohao%2Farticle%2Fdetails%2F79440961)  
[Powerlevel9k --- 一个美观而又实用的 ZSH 主题](https://www.jianshu.com/p/f84cf6132d1e)

转载参考链接：https://www.jianshu.com/p/246b844f4449