---
title: PVE上安装黑裙辉6.2
author: Qihong
top: false
cover: false
toc: true
mathjax: false
date: 2020-05-19 20:36:11
img:
coverImg:
password:
summary:
tags:
  - PVE
  - 直通
  - 虚拟机
categories:
  - 群晖
  - PVE
  - 虚拟机
---




### PVE上安装黑裙辉6.2
参考文章：
https://post.smzdm.com/p/a25r8mo2/

http://www.myxzy.com/post-488.html

 

**环境介绍**

1、Proxmox VE（以下简称PVE） 

2、黑群晖DSM6.2引导由xpenology的大神Jun提供（引导文件名DS3617xs_v1.03.zip）

下载链接: https://pan.baidu.com/s/1T_rQDnkXrID93-U3PWd85g 提取码: 6gm1

3、群晖安装镜像，文件名DSM_DS3617xs_23739.pat 可以在[官网下载](https://www.synology.com/zh-cn/support/download)，也可通过提供的百度云下载

下载链接: https://pan.baidu.com/s/1R_cEENHCl3-moX7Td9BlCw 提取码: kehx

 

PVE的安装教程，请参考：https://www.cnblogs.com/faberbeta/p/proxmox004.html

 

1. 点击右上角“创建虚拟机”按钮，勾上“高级”，勾上“开机自启动”，名称填入虚拟机名称（例如DSM），点击“下一步”

![1](C:\Users\Administrator\Pictures\1.png)

2、操作系统选择“Linux”，版本选择“4.X/3.X/2.6 Kernel”即可，选择“不适用任何介质”，点击“下一步”

![2](C:\Users\Administrator\Pictures\2.png)

3、系统默认即可，点击“下一步”

![3](C:\Users\Administrator\Pictures\3.png)

4、硬盘，随便设置，之后会删除的，点击“下一步”

![4](C:\Users\Administrator\Pictures\4.png)

5、CPU按照实际情况选择，有四个核就填4，点击“下一步”

![5](C:\Users\Administrator\Pictures\5.png)

6、内存大小设置，也是根据实际情况选择（一般2G内存够了），点击“下一步”

![6](C:\Users\Administrator\Pictures\6.png)

7、网络模型选择“intel E1000”，点击“下一步”

 ![7](C:\Users\Administrator\Pictures\7.png)

8、确认配置，直接点击“完成”

![8](C:\Users\Administrator\Pictures\8.png)

9、删除硬盘，选择“DSM” --> "硬件"，找到硬盘，选中点击“分离”

![9](C:\Users\Administrator\Pictures\9.png)



11.使用WinSCP或者mac上直接scp，把解压出来的synoboot.img上传到根目录

 

12.img磁盘转换，选择Shell，输入

```bash
qm importdisk 101 /synoboot.img local-lvm
```


 会看到vm-101-disk-0正在创建

101是虚拟机编号，synoboot.img是刚才上传的引导镜像

![13](C:\Users\Administrator\Pictures\13.png)

 

13.添加磁盘。进入DSM硬件设置，选中未使用的磁盘0，点击编辑

![14](C:\Users\Administrator\Pictures\14.png)

14.总线/设备选择SATA和0，磁盘镜像选择vm-101-disk-0

![15](C:\Users\Administrator\Pictures\15.png)

15.引导顺序，改为硬盘，Disk ‘sata0’

![16](C:\Users\Administrator\Pictures\16.png)

16.回到proxmox的shell

输入

```bash
apt-get update
```

 更新一下源

```bash
apt-get install lshw
```

安装lshw

```bash
ls -l /dev/disk/by-id/
```

查看设备的磁盘ID

![17](C:\Users\Administrator\Pictures\17.png)

会出来一大片，我们这里有用的是前面带ata的几行

![18](C:\Users\Administrator\Pictures\18.png)

我们选用其中一个进行示范，红框里的内容是我们要用到的，我们把他一字不差的打下来，要区分大小写

proxmox网页的话可以选中右键复制

ata-WDC_WD10EZEX-08M2NA0_WD-WCC3FP2U67YA

完成后应该是这样一行设备信息

然后我们用下面的代码把他直通给群晖

```bash
qm set 101 --sata2 /dev/disk/by-id/ata-WDC_WD10EZEX-08M2NA0_WD-WCC3FP2U67YA
```

<font color=#00ffff>  上一行代码中， 101代表VM ID，sata2代表总线类型以及编号，最后面的是硬盘的路径以及编号  </font>

硬盘直通就完成了，我们用同样的方法把另外3个硬盘也直通给群晖使用，类似下面的，sata的编号是递增的

`qm set 101 --sata3 /dev/disk/by-id/ata-WDC_WD10EZEX-XXX`

`qm set 101 --sata4 /dev/disk/by-id/ata-WDC_WD10EZEX-XXX`

`qm set 101 --sata5 /dev/disk/by-id/ata-WDC_WD10EZEX-XXX`

 回到DSM虚拟机，我们可以看到硬盘已经添加在虚拟机中了

 

17.在PVE后台，启动刚才创建的DSM虚拟机

18.内网访问网页http://find.synology.com，找到未配置的群晖

![19](C:\Users\Administrator\Pictures\19.png)

19.用户协议，勾上确定，下一步

![20](C:\Users\Administrator\Pictures\20.png)

20.点击“设置”，如果系统盘有信息，会显示“还原”

![21](C:\Users\Administrator\Pictures\21.png)

21.点击“手动安装”，选择本地电脑上下载的DSM_DS3617xs_23739.pat文件，点击立即安装

![22](C:\Users\Administrator\Pictures\22.png)

22.会提示硬盘有几块数据盘会被清空，1是引导盘，其他的是系统盘

![23](C:\Users\Administrator\Pictures\23.png)

23.等待安装完成

![24](C:\Users\Administrator\Pictures\24.png)

24.DSM初次进入的配置, 重点不要选择，自动更新，可以选手动更新，但是要求自己来决定是否更新。

系统让设置用户名和密码，用户名可以任意起名，这个用户是管理员用户，笔者把这个用户设置为 admin

稍微等一会，启动 Synology Assistant 搜索或者直接到路由器中看IP地址，

我这里直接路由器中查看到IP为192.168.0.31，直接在浏览器中输入http://192.168.0.31:5000,进入到安装界面

25.上一张进入DSM的信息图

![QQ截图20200814080946](C:\Users\Administrator\Pictures\QQ截图20200814080946.png)

26.至此，会群晖DSM 6.2 DS3617xs安装完毕，不能进行升级，一旦升级就启动不了。

在套件中心可以升级现有的套件，套件可以任意升级。

