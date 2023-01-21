# 配置 frpc 的自动 HTTPS 功能

::: danger 请确保您完全理解这个功能再进行配置
我们已经碰到上百例因为 **乱开自动 HTTPS 开关** 造成 **隧道访问不了**、**出现神秘报错** 的问题了  
在打开自动 HTTPS 前请先 **完全搞清楚** 这个功能有什么用，如果看不懂就 **不要开** 这个功能  
打开前必须阅读 [禁忌证](#contraindication) 里列出的 **典中典不适用自动 HTTPS 功能的情况** 并与使用场景进行对照
:::

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

如果穿透的 **已经是** HTTPS 协议了，再打开这个功能会把流量变成 **TLS 套 TLS**，并且 frpc 在请求本地服务时会使用 **明文 HTTP** 协议。

但是此时本地服务需要的显然是 **HTTPS 协议**，用明文 HTTP 去连接就 **不能用**，而且会 **报错**：

- Nginx 会报 **400 Bad Request**，错误信息为 `The plain HTTP request was sent to HTTPS port`
- Apache 会报 **Bad Request**，错误信息为 `Your browser sent a request that this server could not understand`  
  错误原因为 `You're speaking plain HTTP to an SSL-enabled server port`

如果看到上述错误，请关掉自动 HTTPS 功能然后重启 frpc，然后大概就可以用了。

## 配置方法 {#usage}

打开这个功能很简单，只要开一个开关就可以了，剩下的 frpc 都会自动处理：

1. 编辑隧道并在 **自动 HTTPS** 处选择 `自动`

   ![](./_images/auto-https-toggle.png)

1. 重启 frpc
1. 使用 `https://连接方式` 的形式访问您穿透的服务即可
1. (可选) 如果您想避免证书错误提示，请 [配置 SSL 证书](/frpc/ssl.md)

## 进阶配置 {#advanced-usage}

主开关 `auto_https` 取值如下：

| auto_https | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 禁用自动 HTTPS 功能 |
| auto | frpc 将使用 `server_name` 作为证书 Common Name (CN) 生成自签证书 |
| 其他值 | frpc 将尝试加载 工作目录 下的 `<auto_https>.crt` 和 `<auto_https>.key` 两个证书文件<br>- 若加载成功，`<auto_https>` 就作为一个单纯的文件名进行处理，不会对证书产生影响<br>- 若文件不存在或解析失败则使用 `<auto_https>` 作为 CN 生成一份自签名证书并保存到上述文件中 |

考虑到部分用户穿透的可能不是 Web 应用，frpc 默认会在启动时发送 `HEAD /\r\n\r\n` 并检查回包的头 4 个字节来决定工作模式。如果是 `HTTP` 就采用 `http` 模式，否则采用 `passthrough` 模式。

当然，自动检测并非完美，因此自 **v0.42.0-sakura-2.1** 起您可以通过 `auto_https_mode` 开关强制覆写工作模式：

| auto_https_mode | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 自动探测是否为 HTTP 服务并选择恰当的工作模式 |
| http | 使用 HTTP 服务器进行反代并在发给本地服务的请求中追加 `X-Forwarded-For` 请求头 |
| passthrough | 直通模式，单纯的在 TCP 流外面套上一层 TLS，不对数据包进行其他修改操作 |
