---
title: 群晖docker设置国内镜像
author: Qihong
top: false
cover: false
toc: true
mathjax: false
date: 2020-08-17 20:36:11
img:
coverImg:
password:
summary:
tags:
  - 群晖
  - Github
  - ftp
categories:
  - 群晖
  - Github
  - ftp 

---

**一、打开Docker，注册表-设置-Docker Hub-编辑**

[![群晖Docker设置阿里云国内镜像加速教程](https://cdn.rixin.info/2020/08/2029fb81cec128d73b4699162b2f17c5.jpg)](https://cdn.rixin.info/2020/08/2029fb81cec128d73b4699162b2f17c5.jpg)

二、启用注册表镜像打勾，在注册表镜像URL处填写：

```
https:``//gcislbr9.mirror.aliyuncs.com
```

[![群晖Docker设置阿里云国内镜像加速教程](https://cdn.rixin.info/2020/08/85520921086d783b01c336fcb9435d56.jpg)](https://cdn.rixin.info/2020/08/85520921086d783b01c336fcb9435d56.jpg)

以上的镜像如果有问题，可以试下面的地址：

```
https:``//ay0r3phx.mirror.aliyuncs.com
```

三、点确认后重启**[群晖](https://www.rixin.info/tags/群晖)**。重启后你再下载一个Docker镜像试一下，感受一下快感吧！

我现在还有许多Docker容器需要重新安装了，以后大家一定要做好备份。

####  国内加速地址

- Docker中国区官方镜像
  https://registry.docker-cn.com
- 网易
  http://hub-mirror.c.163.com
- ustc
  https://docker.mirrors.ustc.edu.cn
- 中国科技大学
  https://docker.mirrors.ustc.edu.cn
- 阿里云容器 服务
  https://cr.console.aliyun.com/
  首页点击“创建我的容器镜像” 得到一个专属的镜像加速地址，类似于“https://1234abcd.mirror.aliyuncs.com”

###### 

