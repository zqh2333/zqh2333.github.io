---
title: PVE直通硬盘
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
  - PVE
  - 直通
  - 虚拟机
  
---




### 进入pve shell 查看硬盘识别符：


```
 ls -l /dev/disk/by-id/ # 查看硬盘识别符

```
## 后续

 输入如下命令：
```
 qm set 107 --sata1 /dev/disk/by-id/ata-ST2000VX008-2E3164_Z528F9AK # 107为直通虚拟机 ata-ST2000VX008-2E3164_Z528F9AK为硬盘识别符 
```

