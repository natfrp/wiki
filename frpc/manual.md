# frpc 用户手册

::: tip
这是面向高级用户的手册，如果您尚不熟悉 frpc，请移步 [frpc 简明使用教程](/frpc/usage.md#running-frpc)
:::

由 Sakura Frp 分发的 frpc 与上游开源版本有一定差异，部分配置项可能不受支持，请以此文档为准进行配置。

## 命令行开关 {#advanced-switches}

| 开关 | 说明 |
| --- | --- |
| -f, --fetch_config `<Token>:<隧道ID 1>[,隧道ID 2[,隧道ID 3...]]` | 从 Sakura Frp 服务器自动拉取配置文件<br>_* 多节点启动需使用 frpc v0.42.0-sakura-6 及以上版本_ |
| -w, --write_config | 拉取配置文件成功后将配置文件写入 `./frpc.ini` 中 |
| -n, --no_check_update | 启动时不检查更新 |
| -V, --version_full | 显示完整版本号并退出 frpc |
| --system_dns | 强制只使用系统 DNS |
| --encrypt_dns | 强制只使用加密 DNS |
| --log_level | 强制覆写 frpc 日志等级 |
| --proxy | 强制覆写连接节点时的代理设置 (不对 API 请求生效)<br>- `none`: 强制绕过代理<br>- `system`: 使用系统代理 (http_proxy 变量)<br>- 或传入 SOCKS5 / HTTP 代理 URI<br>_* 0.51.0-sakura-7 及以上版本可用_ |
| --disable_log_color | 禁用日志输出中的颜色<br>_* 0.51.0-sakura-5.1 及以上版本可用_ |
| --natfrp_tls | 全程使用 TLS 加密流量，将有效增大 CPU 占用并显著提高延迟<br>_* 上面没写错，这是一个内部开关，我们不建议您使用它_ |
| ~~--update~~ | ~~进行自动更新，如果不设置该选项默认只进行更新检查而不自动更新~~<br>_* 于 0.45.0-sakura-7 移除_ |
| ~~--remote_control `<密码>`~~ | ~~配置远程管理 E2E 密码，请参阅 [frpc 远程管理](/frpc/remote.md) 获取更多信息~~<br>_* 于 0.45.0-sakura-7 移除_ |

## 环境变量选项 {#advanced-env}

自 `v0.39.1-sakura-1.1` 版本起，可通过下述环境变量代替 `-f` 开关：

| 变量名 | 说明 | 举例 |
| --- | --- | --- |
| NATFRP_TOKEN | 访问密钥 | wdnmdtoken666666 |
| NATFRP_TARGET | 逗号分割的隧道 ID 列表，详见 `-f` 开关 | 1234,6666,7777 |

此外，配置文件加载时会被作为 [Text Template](https://pkg.go.dev/text/template) 解析，可通过 `{{ .Envs.<变量名> }}` 语法引用环境变量。

## 配置文件选项 {#advanced-config}

### common 段 {#common}

::: details 上游兼容配置项

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| server_addr | String | 0.0.0.0 | 服务器地址 |
| server_port | Int | 7000 | 服务器端口 |
| user | String | 空 | frpc 认证用户名<br>_* 连接 Sakura Frp 节点时应填写访问密钥_ |
| pool_count | Int | 10 | 预分配的工作连接池大小<br>_* 该配置对 SakuraFrp 节点无效_ |
| dial_server_timeout | Int | 10 | 连接服务器的超时时间 (秒) |
| dial_server_keepalive | Int | 7200 | Keepalive 周期 (秒) |
| connect_server_local_ip | Int | 7200 | Keepalive 周期 (秒) |
| http_proxy | String | 空 | HTTP 代理 URI |
| log_level | String | info | 日志等级 |
| disable_log_color | Boolean | false | 禁用日志输出中的颜色 |
| token | String | 空 | frpc 认证密钥<br>_* 该配置对 SakuraFrp 节点无效_ |
| authenticate_new_work_conns | String | 空 | 通过 `token` 认证工作连接<br>_* 该配置对 SakuraFrp 节点无效_ |
| tls_enable | Boolean | false | 启用 TLS 加密连接 |
| tls_cert_file | String | 空 | TLS 证书文件路径 |
| tls_key_file | String | 空 | TLS 私钥文件路径 |
| tls_trusted_ca_file | String | 空 | TLS 受信任 CA 证书文件路径 |
| tls_server_name | String | 同 server_addr | TLS 服务器名称 |
| disable_custom_tls_first_byte | Boolean | false | TLS 握手时不发送特征字节 |

:::

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| sakura_mode | Boolean | false | 启用 Sakura Frp 连接协议 |
| persist_runid | Boolean | true | 根据本机特征 & 隧道信息生成唯一 RunID 以便快速重连 |
| dynamic_key | Boolean | true | 启用 DKC，即使用 SM2 和 AES-128-GCM / AES-128-CFB 加密数据连接（如果启用数据加密）和控制连接<br>**关闭该选项会造成控制连接流量通过近乎明文的方式传输, 可能暴露您的访问密钥和服务端下发的 SSL 证书等敏感信息**<br>_* 由于服务端协议变更, 目前仅在 0.51.0-sakura-4.3 及以上版本生效, 旧版客户端会自动关闭, 请尽快更新_ |
| ~~use_recover~~ | ~~Boolean~~ | ~~false~~ | ~~启用不断线重连功能~~<br>_* 于 0.51.0-sakura-6 移除_ |
| ~~remote_control~~ | ~~String~~ | ~~空~~ | ~~配置远程管理 E2E 密码，留空则禁用远程管理<br>请参阅 [frpc 远程管理](/frpc/remote.md) 获取更多信息~~<br>_* 于 0.45.0-sakura-7 移除_ |

### TCP 隧道 {#proxy-tcp}

| 选项 | 类型 | 默认值 | 说明 |
| :---: | --- | --- | --- |
| [IP 访问控制](#feature-ip-acl) | | | 点击左侧链接查看配置详情 |
| [自动 HTTPS](#feature-auto-https) | | | 点击左侧链接查看配置详情 |
| [访问认证](#feature-auth) | | | 点击左侧链接查看配置详情 |
| [本地访问](#feature-local-access) | | | 点击左侧链接查看配置详情 |
| minecraft_detect | String | auto | 配置 Minecraft 局域网游戏监测功能<br>- 留空: 在本地端口为 25565 时监测来自本机的局域网游戏广播<br>- `enabled`: 监测来自本机的局域网游戏广播<br>- `enabled_lan`: 监测整个 LAN 中的局域网游戏广播<br>- `disabled`: 禁用局域网游戏监测<br>_* 0.51.0-sakura-5 及以上版本可用_ |
| ~~concat_packet~~ | ~~Int~~ | ~~-1~~ | ~~配置合并封包功能的最小字节数，有助于减少小包并降低网卡 PPS<br>设置为 `-1` 禁用合并封包功能~~<br>_* 于 0.51.0-sakura-7.2 移除_  |

### UDP 隧道 {#proxy-udp}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| [IP 访问控制](#feature-ip-acl) | | | 点击左侧链接查看配置详情 |
| [本地访问](#feature-local-access) | | | 点击左侧链接查看配置详情 |
| no_budp2 | Boolean | false | 停用 bUDPv2 优化<br>_* bUDPv2 优化在 0.51.0-sakura-3 及以上版本可用_ |
| auth_mode | String | 空 | 设置为 `server` 可启用服务端访问认证 |

bUDPv2 优化有助于降低延迟和流量消耗，但是当您的隧道同时被超过 4096 个客户端访问且高强度发报时，可能出现极少量数据报被发送到错误的目标。

### HTTPS 隧道 {#proxy-https}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| [IP 访问控制](#feature-ip-acl) | | | 点击左侧链接查看配置详情 |
| [自动 HTTPS 功能](#feature-auto-https) | | | 点击左侧链接查看配置详情 |
| [访问认证](#feature-auth) | | | 点击左侧链接查看配置详情 |
| force_https | Int | 0 | 配置 frps 自动重定向 HTTP 请求到 HTTPS 的功能，有助于减少隧道占用。<br>- `0`: 禁用自动重定向功能<br>- 其他数字: 启用重定向功能并在重定向时返回该数字作为状态码，推荐使用 `301` 或 `302` |
| auto_https_mode | String | 空 | 与 [TCP 隧道](#tcp_proxy) 中同名选项相同 |
| auto_https_policy | String | `loose` | 与 [TCP 隧道](#tcp_proxy) 中同名选项相同 |

### WOL 隧道 {#proxy-wol}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| password | String | 空 | 指定防止未授权 WOL 访问的密码，设置后请将计算机类型修改为 `WOL (密码保护)` |
| from_ip | String | 空 | 指定 WOL 发送时使用的源 IP，默认使用所有 IP |
| from_if | String | 空 | 指定 WOL 发送时使用的网卡名称，例如 `eth0`，默认使用所有网卡，该选项与 `from_ip` 冲突 |

## IP 访问控制功能 {#feature-ip-acl}

- 该功能适用于 `TCP`、`UDP`、`HTTP`、`HTTPS` 隧道
- 启用端口导出时，该功能只会对中继模式的端口生效

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| blacklist_ip | List&lt;String&gt; | 空 | 以 `,` 分隔的黑名单列表，比白名单优先级更高，格式可以为:<br>- `114.5.1.4`: 单个 IP<br>- `114.5.1.4/8(16,24,32)`: 可以被 8 整除的前缀表示 |
| whitelist_ip | List&lt;String&gt; | 空 | 以 `,` 分隔的白名单列表，设置白名单后无法通过黑白名单的 IP 即无法访问，格式与黑名单相同 |

## 访问认证功能 {#feature-auth}

- 该功能适用于 `TCP`、`HTTPS`、`ETCP` 隧道
- 启用端口导出时，该功能只会对中继模式的端口生效
- 在 [此处](/bestpractice/frpc-auth.md) 可查看简单的配置指南

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| auth_pass | String | 空 | 配置访问认证功能的密码，留空则禁用密码认证 |
| auth_totp | String | 空 | 配置访问认证的 TOTP 功能<br>- 留空: 不启用 TOTP 验证<br>- Base32 种子: 使用默认配置启用 TOTP<br>- TOTP URI: 使用自定义配置启用 TOTP, 可选参数有 `digits`、`skew`、`algorithm`<br>&nbsp;&nbsp;_例: `otpauth://totp/auto?secret=<种子>&digits=<数字>&skew=<周期>&algorithm=<算法>`_<br>&nbsp;&nbsp;_* algorithm 参数取值为 `md5`、`sha1` (默认)、`sha256`、`sha512`_<br>_* 0.42.0-sakura-3 及以上版本可用_ |
| auth_time | String | 2h | 配置访问认证功能在没有勾选「记住」时授权过期时间<br>接受的后缀为 `h`/`m`/`s`，请从大到小排列，如 `1h3m10s` |
| auth_mode | String | online | 配置 SakuraFrp 访问认证功能的认证模式<br>- `online`: 允许通过密码认证或通过 SakuraFrp 面板进行授权<br>- `standalone`: 仅允许通过密码认证, 忽略 SakuraFrp 服务器下发的授权信息<br>- `server`: 不启用密码，只能通过 SakuraFrp 面板进行授权 |
| auth_redirect | String | 空 | 配置 SakuraFrp 访问认证通过后自动跳转 (或打开) 到的页面<br>请参阅 [认证后打开的 URL](/offtopic/auth-widget.md#redirect_url) 获取更多用法 |

## 自动 HTTPS 功能 {#feature-auto-https}

- 该功能适用于 `TCP`、`HTTPS`、`ETCP` 隧道
- 启用端口导出时，该功能只会对中继模式的端口生效
- 在 [此处](/frpc/auto-https.md) 可查看简单的配置指南

#### auto_https

| 取值 | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 禁用自动 HTTPS 功能 |
| auto | frpc 将使用节点域名作为证书 CN 生成自签证书<br>如果配置了 [子域绑定](/bestpractice/domain-bind.md) 功能, 则从服务端自动加载相关域名的证书 |
| 逗号分隔的域名列表 | frpc 将尝试逐个加载 **工作目录** 下的 `<域名>.crt` 和 `<域名>.key` 两个证书文件<br>- 若加载成功，则使用这些证书进行处理<br>- 若文件不存在或解析失败则生成一份自签名证书并保存到上述文件中<br>对于泛域名证书，请参考 [泛域名证书加载说明](#wildcard-cert-loading) |

#### auto_https_mode

frpc 默认会在启动时自动探测本地服务是否为 HTTP(S) 服务器，并选择恰当的工作模式。

自 `0.42.0-sakura-2.1` 起，可以通过`auto_https_mode` 开关强制覆写工作模式：

| 取值 | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 自动探测是否为 HTTP 服务并选择恰当的工作模式 |
| http | 使用 HTTP 服务器进行反代并在发给本地服务的请求中追加 `X-Forwarded-For` 请求头 |
| passthrough | 直通模式，单纯的在 TCP 流外面套上一层 TLS，不对数据包进行其他修改操作 |
| https | HTTPS 反代模式, 自 `0.51.0-sakura-7` 起可用, 与 HTTP 反代模式类似 |

#### auto_https_policy

frpc 会在处理请求时按照 `SAN 完全匹配 -> SAN 中的泛域名可匹配请求` 的规则尝试使用预加载证书进行握手。

可以通过本开关指定预加载证书匹配失败时，证书的自动加载策略：

| 取值 | 说明 |
| :---: | --- |
| loose<br>**[默认值]** | 自动加载存在于工作目录的本地证书, 若加载失败则使用 `auto_https` 中第一个域名对应的证书作为 fallback |
| exist | 自动加载存在于工作目录的本地证书, 若加载失败则拒绝 TLS 握手 |
| strict | 不允许自动加载证书, 没有预加载证书的域名均拒绝 TLS 握手 |

以域名 `nya-labs.natfrp.com` 为例，frpc 将按顺序尝试加载以下几个证书文件，其中 `_wildcard` 是固定关键字：

- 本级完全匹配: `nya-labs.natfrp.com.crt`、`nya-labs.natfrp.com.key`
- 上级泛域名证书: `_wildcard.natfrp.com.crt`、`_wildcard.natfrp.com.key`
- 本级泛域名证书: `_wildcard.nya-labs.natfrp.com.crt`、`_wildcard.nya-labs.natfrp.com.key`
- 上级完全匹配: `natfrp.com.crt`、`natfrp.com.key`

若所有证书均加载失败，frpc 会在预加载时生成一份自签名证书并保存到 `nya-labs.natfrp.com.crt/key` 中。

::: tip 下方列出的是自动 HTTPS 的请求修改功能
这些配置项仅对 `http` / `https` 模式生效，对于 `passthrough` 模式不会有任何效果
:::

#### auto_https_no_proto_headers

自 `0.51.0-sakura-9` 起，自动 HTTPS 功能默认会在反代时添加若干请求头以增强兼容性，该开关用于控制此行为。

| 取值 | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 自动在反代时添加下列请求头 |
| true | 不自动添加下列请求头 |

```log
X-Forwarded-Proto: https
X-Forwarded-Protocol: https
X-Forwarded-Ssl: on
X-Url-Scheme: https
```

#### plugin_host_header_rewrite

该开关控制反代时对 `Host` 请求头的修改。

| 取值 | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 不修改 `Host` 请求头 |
| 自定义文本 | 将 `Host` 请求头修改为指定内容 |

#### plugin_header_* {#auto-https-modify-header}

该开关用于自定义反代时追加或删除的 HTTP 请求头。

```ini
plugin_header_<头部名> = <值>

; 例如，您可以使用下面的配置来替换请求中的 Cookie
plugin_header_cookie = "logged_in=yes;"
; 或者为所有用户都返回移动端页面
plugin_header_user-agent = "Mozilla/5.0 (Linux; Android 13; Pixel 6 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36"
; 或者删除所有请求中的 Referer
plugin_header_Referer = ""
```

#### auto_https_error_code

自 `0.51.0-sakura-9` 起，可通过该开关指定自动 HTTPS 功能在发生错误时返回的 HTTP 状态码。

| 取值 | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 返回 `502 Bad Gateway` 状态码 |
| 自定义数字 | 返回指定状态码 |

#### auto_https_error_mime

自 `0.51.0-sakura-9` 起，可通过该开关指定自动 HTTPS 功能在发生错误时所返回错误页的 MIME 类型。

| 取值 | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 在 `Content-Type` 中返回 `text/plain; charset=utf-8` |
| 自定义文本 | 在 `Content-Type` 中返回指定的 MIME 类型 |

#### auto_https_error_template

自 `0.51.0-sakura-9` 起，可通过该开关指定自动 HTTPS 功能在发生错误时所返回错误页的内容。

指定的错误页将被作为 [Text Template](https://pkg.go.dev/text/template) 解析，可通过 `{{ .Error }}` 在模版中渲染错误信息。

| 取值 | 说明 |
| :---: | --- |
| 留空<br>**[默认值]** | 返回原始的纯文本错误信息 |
| 自定义文本 | 使用该文本作为错误页模版。注：由于配置文件加载时会被渲染一次，<br>请使用 `{{"{{"}}` 和 `{{"}}"}}` 转义渲染标签的开头和结尾 |
| `file://<文件路径>` | 从指定文件中读取模版 |

## 本地访问功能 {#feature-local-access}

自 `0.51.0-sakura-9.3` 起，您可以启用本地访问功能并向与 frpc 处于相同内网的设备提供内网访问端口。

- 该功能适用于 `TCP`、`UDP` 隧道
- 启用后，frpc 将在本地监听 **远程端口**，您可以通过 `frpc 所在设备IP:远程端口` 访问隧道
- 通过该端口访问时，[IP 访问控制](#feature-ip-acl)、[访问认证](#feature-auth)、[自动 HTTPS](#feature-auto-https) 等客户端侧功能均正常生效

典型的应用场景是启用子域绑定（或将自己的域名解析到节点）后，内网通过 DNS 将域名覆写到 frpc 所在设备 IP，从而实现本地设备通过内网访问、外网设备通过穿透节点访问，且两种方式都能正常使用客户端侧功能。

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| local_access | Boolean | false | 是否启用本地访问功能 |
| local_access_addr | String | 0.0.0.0 | 本地访问功能的监听地址 |
