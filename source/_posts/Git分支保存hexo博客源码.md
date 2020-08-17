---
title: Git分支保存hexo博客源码
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
  - Hexo
  - Github
  - 博客
categories:
  - hexo
  
---




### 初始化完一个hexo目录之后（假如为HEXO）：


```
$ git init # 初始化本地仓库
$ git remote add origin git@github.com:username/username.github.io.git	#关联远程服务器
$ git add .
$ git commit -m "blog"
$ git push origin master:remotebranch # remotebranch为远程仓的分支名，例如hexo;
```
## 后续

 之后再做修改可以在github的 repository setting 中设置默认分支为hexo源码的分支。

更改后更新只需要输入如下命令即可更新修改后的文件：
```
$ git add .
$ git commit -m "blog"
$ git push origin master:remotebranch # remotebranch为远程仓的分支名，例如hexo;
```

