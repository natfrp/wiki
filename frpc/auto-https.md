# 配置 frpc 的自动 HTTPS 功能

::: danger 请确保您完全理解这个功能再进行配置
我们已经碰到上百例因为 **乱开自动 HTTPS 开关** 造成 **隧道访问不了**、**出现神秘报错** 的问题了  
在打开自动 HTTPS 前请先 **完全搞清楚** 这个功能有什么用，如果看不懂就 **不要开** 这个功能  
打开前必须阅读 [禁忌证](#contraindication) 里列出的 **典中典不适用自动 HTTPS 功能的情况** 并与使用场景进行对照
:::

如果您在寻找一个快速的不需要脑子的速查表：

| 服务 | 是否应该启用 |
| --- | --- |
| 网页 (国内节点) | ✔️必须 |
| 网页 (国外节点) | 🆗按需使用 |
| 应用的 HTTP API (国内节点) | ✔️必须 |
| 戴森球计划 (Nebula) | ✔️必须 |
| 其他游戏联机 | ❌不要 |
| 远程桌面 | ❌不要 |

## 功能简介 {#introduction}

首先让我们粗略的理解一下 HTTP 和 HTTPS 的关系：

- HTTP = 用明文传输的网页
- HTTPS = 用 TLS 对明文进行加密再传输，也就是把 HTTP 流量包在叫 TLS 的壳里

再看一下自动 HTTPS 功能的工作原理简图：

![](./_images/auto-https.light.png#light)
![](./_images/auto-https.dark.png#dark)

显然，这个功能的本质就是要求 frpc 采用 TLS 接受对外连接，对流量进行 ”脱壳“ 后再用明文协议连接本地服务。

### 适应证 {#indications}

这个功能最典型的应用场景是本地服务 **不支持 HTTPS** 时，却 **需要用 HTTPS** 进行访问。

> 下面这行字是写给 **非 HTTP 流量** 的用户看的，如果您穿透的是 HTTP 流量请 **不要** 动 `auto_https_mode` 这个选项

当然，这个功能也可以用在其他地方。如果您有 **非 HTTP 流量** 需要用 TLS 进行一个套，也可以启用这个功能，但是最好把 `auto_https_mode` 配置为 `passthrough` 来避免 frpc 对流量进行修改。

### 禁忌证 {#contraindication}

::: warning 典中典不适用自动 HTTPS 功能的情况

1. 如果您穿透的已经是 **HTTPS 协议** 了，就 **不要开** 这个功能
1. 如果您穿透的 **不是 Web 应用**，比如 **游戏联机** 或者 **远程桌面**，就 **不要开** 这个功能
1. 如果您不知道自己在干什么，或者不知道自己的服务需不需要 TLS，就 **不要开** 这个功能
:::

如果穿透的 **已经是** HTTPS 协议了，再打开这个功能会把流量变成 **TLS 套 TLS**。

如果您使用的是 0.51.0-sakura-7 及以上版本，frpc 会自动检测这种情况并切换到 HTTPS 反代模式。

否则，frpc 在请求本地服务时会使用 **明文 HTTP** 协议，此时本地服务需要的显然是 **HTTPS 协议**，用明文 HTTP 去连接就 **不能用**，而且会 **报错**：

- Nginx 会报 **400 Bad Request**，错误信息为 `The plain HTTP request was sent to HTTPS port`
- Apache 会报 **Bad Request**，错误信息为 `Your browser sent a request that this server could not understand`  
  错误原因为 `You're speaking plain HTTP to an SSL-enabled server port`

如果看到上述错误，请关掉自动 HTTPS 功能然后重启 frpc，然后大概就可以用了。

## 配置方法 {#usage}

打开这个功能很简单，只要开一个开关就可以了，剩下的 frpc 都会自动处理：

1. 编辑隧道并在 **自动 HTTPS** 处选择 `自动` (或者 `启用`, 或者输入需要加载证书的域名)

   ![](./_images/auto-https-toggle.png)

1. 重启 frpc
1. 使用 `https://连接方式` 的形式访问您穿透的服务即可
1. (可选) 如果您想避免证书错误提示，请 [配置 SSL 证书](/frpc/ssl.md)

## 进阶配置 {#advanced-usage}

请查看 [用户手册](/frpc/manual.md#feature-auto-https) 中对相关配置项的说明。
