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

主开关 `auto_https` 取值如下：

| auto_https | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 禁用自动 HTTPS 功能 |
| auto | frpc 将使用节点域名作为证书 CN 生成自签证书<br>如果配置了 [子域绑定](/bestpractice/domain-bind.md) 功能, 则从服务端自动加载相关域名的证书 |
| 逗号分隔的域名列表 | frpc 将尝试逐个加载 **工作目录** 下的 `<域名>.crt` 和 `<域名>.key` 两个证书文件<br>- 若加载成功，则使用这些证书进行处理<br>- 若文件不存在或解析失败则生成一份自签名证书并保存到上述文件中<br>对于泛域名证书，请参考 [泛域名证书加载说明](#wildcard-cert-loading) |

frpc 默认会在启动时自动探测本地服务是否为 HTTP(S) 服务器，并选择恰当的工作模式。

自 `0.42.0-sakura-2.1` 起，您也可以通过`auto_https_mode` 开关强制覆写工作模式：

| auto_https_mode | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 自动探测是否为 HTTP 服务并选择恰当的工作模式 |
| http | 使用 HTTP 服务器进行反代并在发给本地服务的请求中追加 `X-Forwarded-For` 请求头 |
| passthrough | 直通模式，单纯的在 TCP 流外面套上一层 TLS，不对数据包进行其他修改操作 |
| https | HTTPS 反代模式, 自 `0.51.0-sakura-7` 起可用, 与 HTTP 反代模式类似 |

此外，自 `0.51.0-sakura-7` 起，可以通过 `auto_https_policy` 指定接收到对未通过 `auto_https` 开关预加载证书的域名的 HTTPS 请求时，证书的加载策略：

| auto_https_policy | 说明 |
| :---: | --- |
| loose<br>**[默认值]** | 自动加载存在于工作目录的本地证书, 若加载失败则使用 `auto_https` 中第一个域名对应的证书作为 fallback |
| exist | 自动加载存在于工作目录的本地证书, 若加载失败则拒绝 TLS 握手 |
| strict | 不允许自动加载证书, 没有预加载证书的域名均拒绝 TLS 握手 |

::: tip
下面的请求修改功能仅当工作在 `http` / `https` 模式时可用，如果您在使用 直通模式，配置下面的参数将没有任何效果。
:::

对于特定应用需要修改请求中的 Host 的情况，您可以在高级设置中使用下面的配置来修改请求：

```ini
plugin_host_header_rewrite = <指定 Host，如 www.natfrp.com>
```

对于特定应用或情况需要修改请求中 Header 的，您可以使用下面的配置来修改请求：

```ini
plugin_header_<头部名> = <值>

; 例如，您可以使用下面的配置来替换请求中的 Cookie
plugin_header_cookie = "logged_in=yes;"
; 或者为所有用户都返回移动端页面
plugin_header_user-agent = "Mozilla/5.0 (Linux; Android 13; Pixel 6 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36"
```

### 泛域名证书加载说明 {#wildcard-cert-loading}

自 `0.51.0-sakura-7` 起，自动 HTTPS 功能支持泛域名证书的加载。

泛域名证书加载后，frpc 会在处理请求时按照 `SAN 完全匹配 -> SAN 中的泛域名可匹配请求` 的规则查找预加载的证书，查找失败则按照 `auto_https_policy` 设定的策略进行自动加载、Fallback 或拒绝握手。

以域名 `nya-labs.natfrp.com` 为例，frpc 将按顺序尝试加载以下几个证书文件，其中 `_wildcard` 是固定关键词：

- 本级完全匹配: `nya-labs.natfrp.com.crt`、`nya-labs.natfrp.com.key`
- 上级泛域名证书: `_wildcard.natfrp.com.crt`、`_wildcard.natfrp.com.key`
- 本级泛域名证书: `_wildcard.nya-labs.natfrp.com.crt`、`_wildcard.nya-labs.natfrp.com.key`
- 上级完全匹配: `natfrp.com.crt`、`natfrp.com.key`

若所有证书均加载失败，frpc 会在预加载时生成一份自签名证书并保存到 `nya-labs.natfrp.com.crt/key` 中。
