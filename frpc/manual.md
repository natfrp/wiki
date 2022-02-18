# frpc 用户手册

下面是写给普通用户的一般使用教程，如果您是高级用户，请参阅 [此章节](#advanced) 获取更多信息。

## 从 TUI 启动隧道 :id=tui-usage

在 `frpc.ini` 不存在的情况下，不带参数直接运行 frpc 会出现一个交互式 UI

输入 **访问密钥**，然后使用 `Tab` 键切换到 **Login** 按钮并按 `回车` 键登录 (若终端支持也可使用鼠标进行操作)

![](_images/tui-0.png)

登录成功后 TUI 会显示当前账户下的隧道列表，使用方向键选中想要启动的隧道，按空格标为绿色 (或使用鼠标直接点击隧道)

?> 可以一次性启用多个隧道，但是这些隧道必须位于同一节点下  
您也可以直接选中节点来启用该节点下的所有隧道

![](_images/tui-1.png)

选择完毕后，按 `Ctrl-C` 即可启动隧道，相关启动参数会被保存到配置文件 `frpc.ini` 中，下次不带参数直接运行 frpc 时不再显示 TUI 而是直接启动隧道

![](_images/tui-2.png)

## 从命令行启动隧道 :id=cli-usage

### 启动参数格式

!> 如果您没有按照 [Linux 使用教程](/frpc/usage/linux) 安装 frpc，或您使用的是 Windows 系统，启动时要把 "frpc" 换成下载到的的文件名  
如 `frpc_windows_386.exe` 、 `./frpc_linux_amd64` 等

frpc 支持启动单条、多条或位于某个节点上的所有隧道。同时启动多条隧道时，这些隧道必须位于同一节点。

 - `frpc -f <访问密钥>:<隧道ID>[,隧道ID[,隧道ID...]]`
 - `frpc -f <访问密钥>:n<节点ID>`
 - 示例：
   - `frpc -f wdnmdtoken6666666:1234`
   - `frpc -f wdnmdtoken6666666:1234,6666,7777,114514`
   - `frpc -f wdnmdtoken6666666:n95`

### 使用举例

假设您的 Token 为 `wdnmdtoken6666666`

![](_images/manual-1.png)

您的隧道列表如下图所示

![](_images/manual-2.png)

假设当前运行的系统为 32 位的 Windows 系统，因此您下载到的 frpc 文件名是 `frpc_windows_386.exe` 。

1. 启动图中的第一条隧道：
```cmd
frpc_windows_386.exe -f wdnmdtoken666666:85823
```

1. 启动 **#6 镇江双线** 节点下的所有隧道，可以不输入隧道 ID：
```cmd
frpc_windows_386.exe -f wdnmdtoken666666:n6
```

1. 第二条命令也可以替换为手动输入两个隧道 ID，效果是相同的：
```cmd
frpc_windows_386.exe -f wdnmdtoken666666:85823,94617
```

---

## 高级用户手册 :id=advanced

由 Sakura Frp 分发的 frpc 与上游开源版本有一定差异，此处仅列出我们新增的功能。如果您在寻找上游 frp 的启动参数、配置文件选项等，请参阅 [上游文档](https://gofrp.org/docs/ ':target=_blank')。

### 新增命令行开关

| 开关 | 说明 |
| --- | --- |
| -f, --fetch_config | 从 Sakura Frp 服务器自动拉取配置文件<br>- 参数 1: `<Token>:<TunnelID>[,<TunnelID>...]`<br>- 参数 2: `<Token>:n<NodeID>` |
| -w, --write_config | 拉取配置文件成功后将配置文件写入 `./frpc.ini` 中 |
| -n, --no_check_update | 启动时不检查更新 |
| -V, --version_full | 显示完整版本号并退出 frpc |
| --remote_control `<密码>` | 配置远程管理 E2E 密码，请参阅 [frpc 远程管理](/frpc/remote) 获取更多信息 |
| --update | 进行自动更新，如果不设置该选项默认只进行更新检查而不自动更新 |
| --report | 向启动器上报信息<br>_* 这是一个内部开关，我们不建议您使用它_ |
| --watch `<PID>` | 监控指定 PID 并在进程退出时退出 frpc，同时禁用日志颜色输出<br>_* 这是一个内部开关，我们不建议您使用它_ |

### 新增配置文件选项

#### common 段

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| sakura_mode | Boolean | false | 启用 Sakura Frp 自有的各类 frpc 特性<br>下方提到的绝大多数选项均依赖于此项 |
| use_recover | Boolean | false | 启用不断线重连功能 |
| persist_runid | Boolean | true | 根据本机特征 & 隧道信息生成唯一 RunID 以便快速重连 |
| remote_control | String | 空 | 配置远程管理 E2E 密码，留空则禁用远程管理<br>请参阅 [frpc 远程管理](/frpc/remote) 获取更多信息 |
| dynamic_key | Boolean | true | 启用 DKC，即使用 SM2 和 AES-128-GCM / AES-128-CFB 加密控制连接和数据连接（如果启用） |

#### TCP 隧道 :id=tcp_proxy

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| concat_packet | Int | -1 | 配置合并封包功能的最小字节数，有助于减少小包并降低网卡 PPS<br>设置为 `-1` 禁用合并封包功能 |
| auto_https | String | 空 | 配置自动给流量套上 TLS 的功能<br>请参阅 [配置 frpc 的自动 HTTPS 功能](/faq/site-inaccessible#frpc-auto-https) 获取更多信息 |
| auth_pass | String | 空 | 配置访问认证功能的密码，留空则禁用访问认证<br>请参阅 [安全指南-frpc 访问认证](/bestpractice/security#frpc-访问认证) 获取更多信息 |
| auth_time | String | 2h | 配置访问认证功能在没有勾选「记住」时授权过期时间<br>接受的后缀为 `h`/`m`/`s`，请从大到小排列，如 `1h3m10s` |
| auth_mode | String | online | 配置 SakuraFrp 访问认证功能的认证模式<br>- `online`: 允许通过密码认证或通过 SakuraFrp 面板进行授权<br>- `standalone`: 仅允许通过密码认证, 忽略 frps 下发的 IP 授权信息 |

#### HTTPS 隧道

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| force_https | Int | 0 | 配置 frps 自动重定向 HTTP 请求到 HTTPS 的功能，有助于减少隧道占用。<br>- `0`: 禁用自动重定向功能<br>- 其他数字: 启用重定向功能并在重定向时返回该数字作为状态码，推荐使用 `301` 或 `302` |
| auto_https | String | 空 | 与 [TCP 隧道](#tcp_proxy) 中同名选项相同 |

#### WOL 隧道

| 选项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| password | String | 空 | 指定防止未授权 WOL 访问的密码，尚未在管理面板实装相关 UI |
| from_ip | String | 空 | 指定 WOL 发送时使用的源 IP |
| from_if | String | 空 | 指定 WOL 发送时使用的网卡 |

## 部分 frpc 新增特性

1. 日志输出会对用户 Token 进行打码，防止 Token 泄漏
1. 连接成功后会输出一段提示信息，提示用户当前隧道的连接方式
   - 该提示信息不会匹配日志格式。目的是兼容旧版启动器对旧版本 frpc 日志解析的逻辑
1. 与服务器连接断开后会尝试自动进行重连，客户端将尝试直接恢复 MUX 连接，因此短暂的断线 (10 秒内) 能实现用户无感知重连
1. 根据本机特征 & 隧道信息生成 `RunID`
   - 这有助于服务端快速辨识掉线的 `frpc` 并进行重连作业。生成的 `RunID` 为一串 `Hash`，不会包含敏感信息
1. 启动时会从 API 服务器的 `/client/get_version` 获取最新版本信息, 并提示用户进行更新或进行自动更新
1. 内建 TUI，方便用户在无参数启动时进行配置
1. 增加封包合并功能以减少小包
1. 下发客户端限速，提升连接体验并有助于解决部分应用断线问题
   - 服务端读取限速存在上行速度在 **跑满本地带宽** 和 **0 Byte/s** 之间反复跳动的问题，在客户端也进行限制即可获得稳定的最大速度
1. 增加自动 TLS 配置功能以简化通过 TCP 隧道调试 HTTP 应用的配置流程
1. 增加自动 HTTPS 重定向功能以减少隧道占用
1. 增加访问认证功能以提升隧道安全性
