# frpc 用户手册

::: tip
这是面向高级用户的手册，如果您尚不熟悉 frpc，请移步 [frpc 简明使用教程](/frpc/usage.md#running-frpc)
:::

由 Sakura Frp 分发的 frpc 与上游开源版本有一定差异，此处仅列出我们新增的功能。如果您在寻找上游 frp 的启动参数、配置文件选项等，请参阅 [上游文档](https://gofrp.org/zh-cn/docs/) 或 [frp/README.md](https://github.com/fatedier/frp/blob/dev/README.md)。

我们总是推荐（并假设）您使用最新版客户端，因此文档中列出的特性不会专门标注可用的版本。如果您需要使用旧版并了解该版本对应的特性，建议您参考 [Nyatwork CDN](https://nya.globalslb.net/natfrp/client/) 中的文件修改时间并对照 [文档提交记录](https://github.com/natfrp/wiki/commits) 进行判断。

### 专有命令行开关 {#advanced-switches}

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

### 专有环境变量选项 {#advanced-env}

自 `v0.39.1-sakura-1.1` 版本起，您可以用环境变量代替 `-f` 开关。

| 变量名 | 说明 | 举例 |
| --- | --- | --- |
| NATFRP_TOKEN | 访问密钥 | wdnmdtoken666666 |
| NATFRP_TARGET | 逗号分割的隧道 ID 列表，详见 `-f` 开关 | 1234,6666,7777 |

### 专有配置文件选项 {#advanced-config}

#### common 段 {#common}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| sakura_mode | Boolean | false | 启用 Sakura Frp 自有的各类 frpc 特性<br>下方提到的绝大多数选项均依赖于此项 |
| persist_runid | Boolean | true | 根据本机特征 & 隧道信息生成唯一 RunID 以便快速重连 |
| dynamic_key | Boolean | true | 启用 DKC，即使用 SM2 和 AES-128-GCM / AES-128-CFB 加密数据连接（如果启用数据加密）和控制连接<br>**关闭该选项会造成控制连接流量通过近乎明文的方式传输, 可能暴露您的访问密钥和服务端下发的 SSL 证书等敏感信息**<br>_* 由于服务端协议变更, 目前仅在 0.51.0-sakura-4.3 及以上版本生效, 旧版客户端会自动关闭, 请尽快更新_ |
| ~~use_recover~~ | ~~Boolean~~ | ~~false~~ | ~~启用不断线重连功能~~<br>_* 于 0.51.0-sakura-6 移除_ |
| ~~remote_control~~ | ~~String~~ | ~~空~~ | ~~配置远程管理 E2E 密码，留空则禁用远程管理<br>请参阅 [frpc 远程管理](/frpc/remote.md) 获取更多信息~~<br>_* 于 0.45.0-sakura-7 移除_ |

#### 隧道通用配置 {#all_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| blacklist_ip | List&lt;String&gt; | 空 | 以 `,` 分隔的黑名单列表，比白名单优先级更高，格式可以为:<br>- `114.5.1.4`: 单个 IP<br>- `114.5.1.4/8(16,24,32)`: 可以被 8 整除的前缀表示 |
| whitelist_ip | List&lt;String&gt; | 空 | 以 `,` 分隔的白名单列表，设置白名单后无法通过黑白名单的 IP 即无法访问，格式与黑名单相同 |

#### TCP 隧道 {#tcp_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| auto_https | String | 空 | 配置自动 HTTPS 功能，留空则禁用自动 HTTPS 功能<br>请参阅 [配置 frpc 的自动 HTTPS 功能](/frpc/auto-https.md) 获取更多信息 |
| auto_https_mode | String | 空 | 配置自动 HTTPS 的工作模式<br>- 留空: 由 frpc 自动探测本地服务并选择<br>- `http`: 通过 HTTP 反代连接本地服务<br>- `passthrough`: 直通模式, 只在流量外层套上 TLS, 内部数据原样转发<br>- `https`: 通过 HTTPS 反代连接本地服务<br>_* https 模式在 0.51.0-sakura-7 及以上版本可用_ |
| auto_https_policy | String | `loose` | 配置自动 HTTPS 的证书加载策略<br>- `loose`: 自动加载存在的本地证书, 失败则使用第一个域名对应的证书<br>- `exist`: 自动加载存在的本地证书, 失败则拒绝握手<br>- `strict`: 不允许自动加载证书, 没有预加载证书的域名均拒绝握手 <br>_* 0.51.0-sakura-7 及以上版本可用_ |
| auth_pass | String | 空 | 配置访问认证功能的密码，留空则禁用密码认证<br>请参阅 [配置访问认证功能](/bestpractice/frpc-auth.md) 获取更多信息 |
| auth_totp | String | 空 | 配置访问认证的 TOTP 功能<br>- 留空: 不启用 TOTP 验证<br>- Base32 种子: 使用默认配置启用 TOTP<br>- TOTP URI: 使用自定义配置启用 TOTP, 可选参数有 `digits`、`skew`、`algorithm`<br>&nbsp;&nbsp;_例: `otpauth://totp/auto?secret=<种子>&digits=<数字>&skew=<周期>&algorithm=<算法>`_<br>&nbsp;&nbsp;_* algorithm 参数取值为 `md5`、`sha1` (默认)、`sha256`、`sha512`_<br>_* 0.42.0-sakura-3 及以上版本可用_ |
| auth_time | String | 2h | 配置访问认证功能在没有勾选「记住」时授权过期时间<br>接受的后缀为 `h`/`m`/`s`，请从大到小排列，如 `1h3m10s` |
| auth_mode | String | online | 配置 SakuraFrp 访问认证功能的认证模式<br>- `online`: 允许通过密码认证或通过 SakuraFrp 面板进行授权<br>- `standalone`: 仅允许通过密码认证, 忽略 SakuraFrp 服务器下发的授权信息<br>- `server`: 不启用密码，只能通过 SakuraFrp 面板进行授权 |
| auth_redirect | String | 空 | 配置 SakuraFrp 访问认证通过后自动跳转 (或打开) 到的页面<br>请参阅 [认证后打开的 URL](/offtopic/auth-widget.md#redirect_url) 获取更多用法 |
| minecraft_detect | String | auto | 配置 Minecraft 局域网游戏监测功能<br>- 留空: 在本地端口为 25565 时监测来自本机的局域网游戏广播<br>- `enabled`: 监测来自本机的局域网游戏广播<br>- `enabled_lan`: 监测整个 LAN 中的局域网游戏广播<br>- `disabled`: 禁用局域网游戏监测<br>_* 0.51.0-sakura-5 及以上版本可用_ |
| ~~concat_packet~~ | ~~Int~~ | ~~-1~~ | ~~配置合并封包功能的最小字节数，有助于减少小包并降低网卡 PPS<br>设置为 `-1` 禁用合并封包功能~~<br>_* 于 0.51.0-sakura-7.2 移除_  |

::: tip
在强制访问认证的节点上未设置访问密码（即未启用访问认证）时，将强制打开访问认证，使用 `server` 模式，您将需要在用户面板进行授权。
:::

#### UDP 隧道 {#udp_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| no_budp2 | Boolean | false | 停用 bUDPv2 优化<br>_* bUDPv2 优化在 0.51.0-sakura-3 及以上版本可用_ |

::: tip
bUDPv2 优化有助于降低延迟和流量消耗，但是当您的隧道同时被超过 4096 个客户端访问且高强度发报时，可能出现极少量数据报被发送到错误的目标。
:::

#### HTTPS 隧道 {#https_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| force_https | Int | 0 | 配置 frps 自动重定向 HTTP 请求到 HTTPS 的功能，有助于减少隧道占用。<br>- `0`: 禁用自动重定向功能<br>- 其他数字: 启用重定向功能并在重定向时返回该数字作为状态码，推荐使用 `301` 或 `302` |
| auto_https_mode | String | 空 | 与 [TCP 隧道](#tcp_proxy) 中同名选项相同 |
| auto_https_policy | String | `loose` | 与 [TCP 隧道](#tcp_proxy) 中同名选项相同 |

#### WOL 隧道 {#wol_proxy}

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| password | String | 空 | 指定防止未授权 WOL 访问的密码，设置后请将计算机类型修改为 `WOL (密码保护)` |
| from_ip | String | 空 | 指定 WOL 发送时使用的源 IP，默认使用所有 IP |
| from_if | String | 空 | 指定 WOL 发送时使用的网卡名称，例如 `eth0`，默认使用所有网卡，该选项与 `from_ip` 冲突 |
