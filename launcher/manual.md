# SakuraFrp 启动器 3.0 用户手册

::: tip
这是面向高级用户的手册，通常情况下您只需查看 [启动器安装、使用指南](/launcher/usage.md)
:::

## 组件说明

| 用户界面                                                     | 平台                               |
| ------------------------------------------------------------ | ---------------------------------- |
| `SakuraLauncher.exe`                                         | Windows (WPF 启动器，提供最新功能) |
| `LegacyLauncher.exe`                                         | Windows (传统启动器，提供基础功能) |
| `SakuraLauncher.app`                                         | macOS                              |
| `SakuraLauncher.apk`                                         | Android                              |
| 配置 Web UI 通过 [PWA](https://launcher.natfrp.com) 进行管理 | 所有平台                           |

高级用户完全可以选择不安装用户界面、手动修改 `config.json` 启用远程管理 V2 在管理面板进行控制。不过这样做使用体验比较差。

| 核心服务               | 平台            |
| ---------------------- | --------------- |
| `SakuraFrpService.exe` | Windows         |
| `natfrp-service.app`   | macOS           |
| `natfrp-service`       | Linux / FreeBSD |

由于 Apple 的签名要求，核心服务在 macOS 平台下只能通过 `SakuraLauncer.app` 使用，故不适用于 **命令行开关** 与 **环境变量** 章节。虽然您可以将 `natfrp-service.app` 甚至里面的二进制文件单独提取出来使用，但我们不推荐这么做。

Android 平台的启动器也不适用于这两节，并且您可能需要 ADB 或 Root 权限来编辑配置文件。

用户界面本身不提供高级配置选项，下方的说明都是针对核心服务的。

## 命令行开关 {#switches}

::: tip
不同版本的启动器可能会有不同的开关，您可以通过 `natfrp-service help` 子命令检查  
文档中的内容总是基于最新版本的启动器编写
:::

| 适用平台 | 开关                    | 说明                                                |
| -------- | ----------------------- | --------------------------------------------------- |
| 所有     | `-h` / `--help`         | 显示帮助信息并退出                                  |
|          | `-v` / `--version`      | 显示版本号并退出                                    |
|          | `-V` / `--version-full` | 显示完整版本信息并退出                              |
|          | `-c` / `--config`       | 指定配置文件路径，默认为 `${工作目录}/config.json`  |
|          | `--daemon`              | 运行守护进程，不带此开关启动时会显示提示信息并退出  |
| Windows  | `--install`             | 安装系统服务                                        |
|          | `--uninstall`           | 卸载系统服务                                        |
| Unix     | `--force-root`          | 强制以 root 用户身份运行 (请确认您知道自己在做什么) |

### 子命令

```bash
# 初始化 Web UI 并打开安装 URL
natfrp-service webui --init

# 打开带凭据的 Web UI 连接 URL，必须安装 PWA
natfrp-service webui

# 生成经过 KDF、Base64 编码的密钥，用于远程管理 V2 密钥配置。
natfrp-service remote-kdf <明文密码>
```

## 环境变量 {#env}

目前仅在 Linux / FreeBSD 下会读取以下环境变量：

| 变量                  | 说明                                                             |
| --------------------- | ---------------------------------------------------------------- |
| `NATFRP_SERVICE_WD`   | 指定 **工作目录**                                                |
| `NATFRP_SERVICE_LOCK` | 指定互斥锁兼 PID 文件路径，默认为 `${工作目录}/lock.pid`         |
| `NATFRP_SERVICE_SOCK` | 指定控制连接的 Unix Socket 路径，默认禁用                        |
| `NATFRP_FRPC_PATH`    | 指定 frpc 可执行文件路径，默认为 `核心服务可执行文件/frpc(.exe)` |

## 工作目录 {#working-dir}

核心服务的所有文件都是相对于 **工作目录** 创建的。下面是工作目录的默认值：

- Windows：`%PROGRAMDATA%\SakuraFrpService`
- macOS：`~/Library/Containers/com.natfrp.launcher/Data/Library/Application Support/natfrp-service`
- Linux / FreeBSD 下遵循 FreeDesktop 规范：
  - 优先使用 `$XDG_CONFIG_HOME/.config/natfrp-service`
  - 如果 `$XDG_CONFIG_HOME` 未设置，则使用 `~/.config/natfrp-service`
- Android 启动器：`/data/data/com.natfrp.launcher/service/`
- OpenWRT LuCI 插件：`/etc/natfrp`

启动器将使用以下路径：

| 路径                                                               | 说明                                   |
| ------------------------------------------------------------------ | -------------------------------------- |
| `config.json`                                                      | 核心配置文件                           |
| `Logs/`                                                            | 日志路径                               |
| `Logs/SakuraFrpService.log` 或 `Logs/natfrp-service.log`           | 本次运行日志                           |
| `Logs/SakuraFrpService.last.log` 或 `Logs/natfrp-service.last.log` | 前次运行日志                           |
| `Logs/Update.log`                                                  | 最后一次自动更新日志                   |
| `FrpcWorkingDirectory/`                                            | frpc 工作目录                          |
| `Update/`                                                          | 更新文件临时目录                       |
| `Temp/`                                                            | WPF 启动器临时目录 (仅 Windows)        |
| `lock.pid`                                                         | 互斥锁兼 PID 文件 (仅 Linux / FreeBSD) |

## 配置文件 {#config}

配置文件 `config.json` 默认以 660 权限创建。在 Unix 平台您可以建立单独的用户以确保配置文件不被泄露。

### 核心功能 {#config-core}

| 配置项             | 类型      | 默认值    | 说明                                                |
| ------------------ | --------- | --------- | --------------------------------------------------- |
| token              | `String`  | 空        | 用户访问密钥，用于自动登录                          |
| auto_start_tunnels | `Int[]`   | 空        | 自动登录后启动的隧道 ID 列表                        |
| update_interval    | `Int`     | `86400`   | 自动更新检查间隔，单位为秒，设置为 -1 禁用自动更新  |
| update_channel     | `String`  | `current` | 更新通道，可选值为 `lts`，`current`，`beta`，`edge` |
| frpc_force_tls     | `Boolean` | `false`   | 强制启用 frpc TLS 连接                              |
| frpc_enable_stats  | `Boolean` | `true`    | 将 frpc 统计信息回报到启动器，用于 Web UI 展示      |

### API 连接性保障 {#config-api}

| 配置项                 | 类型       | 默认值     | 说明                                        |
| ---------------------- | ---------- | ---------- | ------------------------------------------- |
| api_proxy              | `String`   | 空         | 配置 API 使用的代理                         |
| api_timeout            | `Int`      | `30`       | API 请求超时时间，单位为秒                  |
| api_ca_mode            | `String`   | `embedded` | API 根证书验证模式                          |
| api_dns_override       | `String[]` | `null`     | 用于解析 API 地址的 DNS 服务器地址列表      |
| api_dns_system_only    | `Boolean`  | `false`    | 仅使用系统 DNS 解析 API 地址                |
| api_dns_encrypted_only | `Boolean`  | `false`    | 使用内置 DNS 服务器列表时，仅启用加密服务器 |

#### 关于 api_proxy {#config-api-proxy}

该选项接受一个代理 URI，如 `socks5h://user:pass@host:port`。

填写 `system` 则使用系统代理，留空则不使用代理。

该选项设置了自定义代理 URI 时，用户界面的 **绕过系统代理** 选项将总是显示为打开且不可修改。

#### 关于 api_ca_mode {#config-api-ca-mode}

| 模式        | 说明                                         |
| ----------- | -------------------------------------------- |
| `embedded`  | 使用内置的根证书，确保最佳连接性             |
| `system`    | 使用系统根证书，以兼容需要流量审查的特殊环境 |
| `no-verify` | 不验证 SSL 证书，可能造成严重安全问题        |

#### 关于 api_dns_* 相关选项 {#config-api-dns}

- 若指定了 `api_dns_override`，则总是会使用指定的 DNS 服务器列表进行解析。

  该选项接受一个 URI 数组，支持的协议有：

  | 协议           | 说明           |
  | -------------- | -------------- |
  | `udp`, `tcp`   | 普通 DNS 请求  |
  | `tls`, `dot`   | DNS-over-TLS   |
  | `https`, `doh` | DNS-over-HTTPS |

  URL 示例：`udp://223.5.5.5:53`，无效的 URI 将被忽略。

- 否则，若指定了 `api_dns_system_only`，则只使用系统 DNS 进行解析。

- 若上述两个选项均未指定，则会使用内置的 DNS 服务器列表，并根据 `api_dns_encrypted_only` 决定是否启用未加密的 DNS 服务器。

除 `api_dns_override` 外的两个选项会被传递给 frpc。

在任何情况下，都会以系统 DNS 作为最后的备选解析服务器。

### 日志记录 {#config-logging}

| 配置项          | 类型      | 默认值  | 说明                                       |
| --------------- | --------- | ------- | ------------------------------------------ |
| log_buffer_size | `Int`     | `4096`  | 日志 Ring 缓冲区大小（条数），请勿随意调节 |
| log_stdout      | `Boolean` | `false` | 将日志写到标准输出，Docker 中默认为 `true` |
| log_file        | `String`  | `auto`  | 日志文件路径，`auto` 则写入默认路径        |

### 远程管理 {#config-remote}

关于配置项的详细信息，请参阅 [远程管理 V2 / 进阶配置](/launcher/remote-v2.md#geek)。

| 配置项                      | 类型      | 默认值  | 说明                                  |
| --------------------------- | --------- | ------- | ------------------------------------- |
| remote_management           | `Boolean` | `false` | 启用远程管理                          |
| remote_management_key       | `String`  | 空      | 远程管理密钥，KDF 后的 32 字节 Base64 |
| remote_management_auth_mode | `String`  | `nonce` | 远程管理 Challenge-Response 认证模式  |
| remote_management_auth_conf | `String`  | 空      | 远程管理 Challenge-Response 认证配置  |

### Web UI {#config-webui}

::: warning 警告
在任何情况下您都 **不应该** 将 Web UI 暴露在公网上，尤其**不应该** 用 frp 将其穿透至节点  
如果需要带外管理请考虑配置 [远程管理 V2](/launcher/remote-v2.md) 通过 SakuraFrp 进行管理，而非对外暴露 Web UI
:::

您可以访问由我们托管的 [PWA](https://launcher.natfrp.com) 应用来连接启动器的 Web UI 管理接口，我们推荐您总是使用 PWA 以获取最佳体验。

您也可以直接访问启动器的 Web UI 监听地址使用内置的 Web UI，但您将无法使用 PWA 以及最新功能。

| 配置项            | 类型     | 默认值      | 说明                                                  |
| ----------------- | -------- | ----------- | ----------------------------------------------------- |
| webui_host        | `String` | `localhost` | Web UI 监听地址，不为 `localhost` 时必须配置 TLS 证书 |
| webui_port        | `Int`    | `-1`        | Web UI 监听端口，-1 禁用<br>在 Unix 平台默认为 `4101` |
| webui_pass        | `String` | 空          | Web UI 访问密码                                       |
| webui_cert        | `String` | 空          | Web UI TLS 证书路径                                   |
| webui_cert_key    | `String` | 空          | Web UI TLS 证书密钥路径                               |
| webui_origin_mode | `String` | `natfrp`    | Web UI Origin 检查模式                                |

#### 关于 webui_host {#config-webui-host}

考虑到 Web UI 强制在监听非 `localhost` 地址时强制使用 TLS 的行为可能会影响一部分 Geek，如果您真的确定您知道自己在做什么，可以在地址前加 `this-breaks-webui-i-dont-care:` 前缀强制绕过这一限制：

- 例如 `this-breaks-webui-i-dont-care:192.168.1.100` 会使启动器在 `192.168.1.100` 监听 HTTP 协议
- 但这会造成 Web UI 工作异常，最常见的表现为卡在 **连接中...**
- 我们知道这是由于非安全上下文中无法使用部分 API 造成的，但我们不会修复这个问题

同时满足下列三个条件时，启动器会自动生成并使用自签名证书 `webui.{key,crt}`：

- `webui_host` 不为 `localhost`
- 未使用绕过前缀
- `webui_cert`、`webui_cert_key` 均为空

#### 关于 webui_pass {#config-webui-pass}

出于安全考虑，Web UI **必须配置长度不低于 8 字符的访问密码**，服务首次运行时会生成 24 字符的随机密码。

PWA 会自动在 `localStorage` 保存连接信息，因此您无需记住它，我们推荐直接使用随机生成的值。

密码长度要求是硬性限制，无法绕过。

#### 关于 webui_origin_mode {#config-webui-origin-mode}

| 模式     | 说明                                                                |
| -------- | ------------------------------------------------------------------- |
| `strict` | 仅允许同源请求，即 WebSocket 请求的 `Origin` 头必须与 `Host` 头匹配 |
| `natfrp` | 仅允许同源请求或来自 `https://launcher.natfrp.com` 的请求           |
| `any`    | 不检查 `Origin` 头（可能造成严重安全隐患，不推荐使用）              |
