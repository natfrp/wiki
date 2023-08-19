# frpc 用户手册

::: tip
这是面向高级用户的手册，如果您尚不熟悉 frpc，请移步 [frpc 简明使用教程](/frpc/usage.md#running-frpc)
:::

由 Sakura Frp 分发的 frpc 与上游开源版本有一定差异，此处仅列出我们新增的功能。如果您在寻找上游 frp 的启动参数、配置文件选项等，请参阅 [上游文档](https://gofrp.org/docs/) 或 [frp/README.md](https://github.com/fatedier/frp/blob/dev/README.md)。

我们总是推荐（并假设）您使用最新版客户端，因此文档中列出的特性不会专门标注可用的版本。如果您需要使用旧版并了解该版本对应的特性，建议您参考 [Nyatwork CDN](https://nya.globalslb.net/natfrp/client/) 中的文件修改时间并对照文档的 Commit History 作出判断，或者参考 [部分 frpc 新增特性](#advanced-feature) 一节。

### 新增命令行开关 {#advanced-switches}

| 开关 | 说明 |
| --- | --- |
| -f, --fetch_config `<Token>:<启动目标1>[,<启动目标2>...]` | 从 Sakura Frp 服务器自动拉取配置文件，启动目标格式如下：<br>- `<隧道 ID>` 指定单条隧道<br>- `n<节点 ID>` 指定某个节点下的所有隧道<br>_* 多节点启动需使用 frpc v0.42.0-sakura-6 及以上版本_ |
| -w, --write_config | 拉取配置文件成功后将配置文件写入 `./frpc.ini` 中 |
| -n, --no_check_update | 启动时不检查更新 |
| -V, --version_full | 显示完整版本号并退出 frpc |
| --system_dns | 只使用系统 DNS 解析 API 请求 |
| --encrypt_dns | 只使用加密 DNS 解析 API 请求 |
| --natfrp_tls | 全程使用 TLS 加密流量，将有效增大 CPU 占用并显著提高延迟<br>_* 上面没写错，这是一个内部开关，我们不建议您使用它_ |
| ~~--update~~ | ~~进行自动更新，如果不设置该选项默认只进行更新检查而不自动更新~~<br>_* 于 0.45.0-sakura-7 移除_ |
| ~~--remote_control `<密码>`~~ | ~~配置远程管理 E2E 密码，请参阅 [frpc 远程管理](/frpc/remote.md) 获取更多信息~~<br>_* 于 0.45.0-sakura-7 移除_ |

### 新增环境变量选项 {#advanced-env}

自 `v0.39.1-sakura-1.1` 版本起，您可以用环境变量代替 `-f` 开关。

| 变量名 | 说明 | 举例 |
| --- | --- | --- |
| NATFRP_TOKEN | 访问密钥 | wdnmdtoken666666 |
| NATFRP_TARGET | 启动目标列表，详见 `-f` 开关 | 1234,6666,7777,n233 |

### 新增配置文件选项 {#advanced-config}

#### common 段 {#common}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| sakura_mode | Boolean | false | 启用 Sakura Frp 自有的各类 frpc 特性<br>下方提到的绝大多数选项均依赖于此项 |
| use_recover | Boolean | false | 启用不断线重连功能 |
| persist_runid | Boolean | true | 根据本机特征 & 隧道信息生成唯一 RunID 以便快速重连 |
| dynamic_key | Boolean | true | 启用 DKC，即使用 SM2 和 AES-128-GCM / AES-128-CFB 加密数据连接（如果启用数据加密）和控制连接 |
| ~~remote_control~~ | ~~String~~ | ~~空~~ | ~~配置远程管理 E2E 密码，留空则禁用远程管理<br>请参阅 [frpc 远程管理](/frpc/remote.md) 获取更多信息~~<br>_* 于 0.45.0-sakura-7 移除_ |

#### TCP 隧道 {#tcp_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| concat_packet | Int | -1 | 配置合并封包功能的最小字节数，有助于减少小包并降低网卡 PPS<br>设置为 `-1` 禁用合并封包功能 |
| auto_https | String | 空 | 配置自动 HTTPS 功能，留空则禁用自动 HTTPS 功能<br>请参阅 [配置 frpc 的自动 HTTPS 功能](/frpc/auto-https.md) 获取更多信息 |
| auto_https_mode | String | 空 | 配置自动 HTTPS 的工作模式<br>请参阅 [配置 frpc 的自动 HTTPS 功能](/frpc/auto-https.md) 获取更多信息 |
| auth_pass | String | 空 | 配置访问认证功能的密码，留空则禁用密码认证<br>请参阅 [配置访问认证功能](/bestpractice/frpc-auth.md) 获取更多信息 |
| auth_totp | String | 空 | 配置访问认证的 TOTP 功能，留空则禁用 TOTP 认证<br>- 留空 **[默认值]**: 不启用 TOTP 验证<br>- Base32 种子: 使用默认配置启用 TOTP<br>- TOTP URI: 使用自定义配置启用 TOTP, 可选参数有 `digits`、`skew`、`algorithm`<br>&nbsp;&nbsp;_例: `otpauth://totp/auto?secret=<种子>&digits=<数字>&skew=<周期>&algorithm=<算法>`_<br>&nbsp;&nbsp;_* algorithm 参数取值为 `md5`、`sha1` (默认)、`sha256`、`sha512`_<br>_* frpc v0.42.0-sakura-3 及以上版本可用_ |
| auth_time | String | 2h | 配置访问认证功能在没有勾选「记住」时授权过期时间<br>接受的后缀为 `h`/`m`/`s`，请从大到小排列，如 `1h3m10s` |
| auth_mode | String | online | 配置 SakuraFrp 访问认证功能的认证模式<br>- `online`: 允许通过密码认证或通过 SakuraFrp 面板进行授权<br>- `standalone`: 仅允许通过密码认证, 忽略 SakuraFrp 服务器下发的授权信息<br>- `server`: 不启用密码，只能通过 SakuraFrp 面板进行授权 |
| auth_redirect | String | 空 | 配置 SakuraFrp 访问认证通过后自动跳转 (或打开) 到的页面<br>请参阅 [认证后打开的 URL](/offtopic/auth-widget.md#redirect_url) 获取更多用法 |

::: tip
在强制访问认证的节点上未设置访问密码（即未启用访问认证）时，将强制打开访问认证，使用 `server` 模式，您将需要在用户面板进行授权
:::

#### HTTPS 隧道 {#https_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| force_https | Int | 0 | 配置 frps 自动重定向 HTTP 请求到 HTTPS 的功能，有助于减少隧道占用。<br>- `0`: 禁用自动重定向功能<br>- 其他数字: 启用重定向功能并在重定向时返回该数字作为状态码，推荐使用 `301` 或 `302`<br>_* 设置为 301 时，返回的 Location 头只包含 Host 和 Path，Query 及后面的部分会被丢弃_ |
| auto_https | String | 空 | 与 [TCP 隧道](#tcp_proxy) 中同名选项相同 |
| auto_https_mode | String | 空 | 与 [TCP 隧道](#tcp_proxy) 中同名选项相同 |

#### WOL 隧道 {#wol_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| password | String | 空 | 指定防止未授权 WOL 访问的密码，设置后请将计算机类型修改为 `WOL (密码保护)` |
| from_ip | String | 空 | 指定 WOL 发送时使用的源 IP，默认使用所有 IP |
| from_if | String | 空 | 指定 WOL 发送时使用的网卡名称，例如 `eth0`，默认使用所有网卡，该选项与 `from_ip` 冲突 |

## frpc 重点更新日志 {#advanced-feature}

此处只列出 frpc 的部分重要的特性变更。

| 最早版本 | 特性 |
| --- | --- |
| 0.33.0-sakura-1 | 添加 `-f` 参数从 API 拉取配置文件 |
| | 添加日志输出 Token 打码功能 |
| 0.33.0-sakura-2 | 添加 `sakura_mode` 配置项，允许开关自有特性来改善对原版的兼容性 |
| | `-w` 写入配置文件开关 |
| 0.33.0-sakura-3 | 透明重连功能 |
| | 添加 TUI 方便用户在无参数启动时进行配置 |
| 0.33.0-sakura-4 | 添加输出信息本地化支持，在支持中文输出时优先以中文输出 |
| | 添加本机生成 `RunID` |
| 0.33.0-sakura-5 | 添加更新检查、自动更新 |
| 0.33.0-sakura-6 | 自动 HTTPS 重定向功能 |
| 0.34.1-sakura-1 | 封包合并功能（需要用户手动配置） |
| 0.34.1-sakura-2 | 客户端限速下发功能 |
| 0.34.2-sakura-1 | 自动 TLS 配置功能 |
| 0.34.2-sakura-3 | WOL 隧道支持 |
| | 访问认证功能 |
| 0.39.1-sakura-1 | 添加 DKC 加密实现，使用 SM2 和 AES-128-GCM / AES-128-CFB 进行数据加密 |
| 0.42.0-sakura-2 | 在自动 HTTPS 中增加 Proxy Protocol 支持 |
| 0.42.0-sakura-2.1 | 增加切换自动 HTTPS 工作模式的配置项 |
| 0.42.0-sakura-3 | 访问认证功能 TOTP 支持 |
| 0.42.0-sakura-4 | UDP 隧道的 Proxy Protocol 支持 |
| 0.42.0-sakura-6 | 添加多节点模式 |
