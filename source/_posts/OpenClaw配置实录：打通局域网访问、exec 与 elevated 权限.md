---
title: OpenClaw配置实录：打通局域网访问、exec 与 elevated 权限
author: Qihong
top: false
cover: false
toc: true
mathjax: false
date: 2026-04-01 05:10:00
img:
coverImg:
password:
summary: 记录一次把 OpenClaw 从只能本机访问、权限链路未打通，折腾到局域网可访问、exec 可执行、elevated 可提权、Control UI 风险收口的完整过程。
tags:
  - OpenClaw
  - Gateway
  - Exec
  - Elevated
  - 局域网
categories:
  - OpenClaw配置
---

这篇文章记录一次把 OpenClaw 从“能跑起来”折腾到“局域网可访问、控制 UI 可用、exec 可执行、elevated 可提权”的完整过程。

目标不是讲概念，而是把一条真正跑通的路径整理出来，方便以后自己或别人复现。

## 环境

- 系统：Ubuntu / Linux
- OpenClaw 版本：2026.3.28
- Gateway 端口：`18789`
- 局域网 IP：`10.10.10.10`
- 使用方式：Telegram 直连 + 本地 OpenClaw Gateway

## 最终目标

要打通的是下面这几件事：

1. 局域网其他设备可以访问 Dashboard
2. Control UI 不再是危险绕过状态
3. 当前会话可以执行 `exec`
4. 当前会话可以执行 `elevated` 命令
5. 整体配置通过验证，关键 CRITICAL 清零

## 一、确认症状：为什么 10.10.10.10 打不开

最开始的现象是：

- `ping 10.10.10.10` 可以通
- 但浏览器打开 `http://10.10.10.10:18789/` 提示“拒绝连接”

这说明：

- 网络层没断
- 但应用层端口没有对局域网开放，或者服务只监听 loopback

通过 `openclaw status` 可以看到当时的关键信息：

- Dashboard 指向 `http://127.0.0.1:18789/`
- Gateway 处于 local loopback 模式

也就是说，服务只对本机开放，没有真正对局域网设备开放。

## 二、把 Gateway 改成局域网可访问

核心思路就是把网关从 loopback 改成 LAN 模式。

关键配置目标：

```bash
openclaw config set gateway.bind lan
openclaw gateway restart
```

重启后再检查：

```bash
openclaw gateway status
openclaw qr --json
```

理想结果是：

- `bind=lan (0.0.0.0)`
- `Listening: *:18789`
- `gatewayUrl = ws://10.10.10.10:18789`
- `urlSource = gateway.bind=lan`

这时候局域网设备就能通过：

```text
http://10.10.10.10:18789/
```

访问 Dashboard。

## 三、修 Control UI：从“能用”改成“安全可用”

为了快速打通链路，前期很容易把 Control UI 配成危险模式，比如：

- `gateway.controlUi.allowedOrigins = ["*"]`
- `gateway.controlUi.dangerouslyDisableDeviceAuth = true`

这样虽然方便调试，但会在 `openclaw status` 里直接出现 CRITICAL。

最终的收口方式是：

### 1. 恢复 device auth

把：

```json
"dangerouslyDisableDeviceAuth": true
```

改回：

```json
"dangerouslyDisableDeviceAuth": false
```

### 2. 收紧 allowedOrigins

把 wildcard 改成明确白名单：

```json
[
  "http://10.10.10.10:18789",
  "http://127.0.0.1:18789",
  "http://localhost:18789"
]
```

改完后重启 Gateway，再执行：

```bash
openclaw status
```

确认 security audit 不再出现：

- `CRITICAL DANGEROUS: Control UI device auth disabled`

这是整个配置链路里非常关键的一步。

## 四、打通 exec

在这套环境里，最开始 `exec` 跑不起来，报错大意是：

- `exec host not allowed`
- 需要把 `tools.exec.host` 配到 `gateway`

最终可用配置是：

```json
"tools": {
  "exec": {
    "host": "gateway",
    "security": "full"
  }
}
```

说明：

- `host=gateway` 让会话可以在 Gateway 所在主机上执行命令
- `security=full` 是高权限模式，适合自己完全信任的环境，不适合公开多用户场景

打通后，就可以直接执行：

- `openclaw status`
- `openclaw gateway status`
- `openclaw devices list`
- 以及后续安装依赖、排障、读取配置等操作

## 五、打通 elevated

普通 `exec` 可用后，并不代表可以做提权操作。

比如执行：

```bash
npm install -g agent-browser
```

就会遇到 `elevated is not available right now`。

最终是通过为 Telegram 来源显式打开 elevated 权限解决的。

配置形态类似：

```json
"tools": {
  "elevated": {
    "enabled": true,
    "allowFrom": {
      "telegram": ["*"]
    }
  }
}
```

注意这里一个坑：

`allowFrom.telegram` 不是布尔值，而是数组。最开始如果写成：

```json
"telegram": true
```

配置会直接校验失败。

正确做法是数组，例如：

```json
"telegram": ["*"]
```

改完后要验证：

```bash
openclaw config validate
openclaw gateway restart
```

通过之后，elevated 才真正可用。

## 六、如何验证全部已经打通

推荐按下面顺序验收：

### 1. Gateway 状态

```bash
openclaw gateway status
```

确认：

- `bind=lan (0.0.0.0)`
- `Listening: *:18789`
- `Runtime: running`

### 2. 总体状态

```bash
openclaw status
```

确认：

- Dashboard 地址是 `http://10.10.10.10:18789/`
- 没有 critical
- 关键功能都正常

### 3. QR / 节点接入信息

```bash
openclaw qr --json
```

确认：

- `gatewayUrl` 是局域网地址
- 不再是 `127.0.0.1`

### 4. 提权命令

执行一个需要 elevated 的安装或系统操作，确认不再被拒绝。

## 七、最终建议

如果你和我一样是在**完全自用、可信的内网环境**折腾 OpenClaw，那么：

- `gateway.bind=lan` 很实用
- `tools.exec.host=gateway` 很实用
- `tools.exec.security=full` 也可以接受，但要明确这是高信任模式

但仍然建议：

- 不要把这套控制界面直接暴露到公网
- `allowedOrigins` 不要用 `*`
- `dangerouslyDisableDeviceAuth` 只在极短时间调试时使用，完事就关

## 八、总结

这次真正打通 OpenClaw，不是只改一个配置，而是同时解决了四层问题：

1. 网络可达性（loopback → LAN）
2. Control UI 安全边界
3. exec 主机与权限
4. elevated 提权来源

把这四层一起理顺，OpenClaw 才会从“能跑”变成“真的能用”。

如果你也遇到类似报错，建议配合下一篇排障记录一起看：那篇会把每个坑的现象、原因和解法拆得更细。
