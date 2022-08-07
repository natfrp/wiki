# 常见问题: frpc

## 如何通过一个 frpc 开启多条隧道 :id=multi-tunnels-in-single-frpc

?> 一个 frpc 只能连接一个 **节点**，但可以连接多条 **隧道**  
详见 [其他常见问题-一个 frpc 可以连接多条隧道吗](/faq/misc#一个-frpc-可以连接多条隧道吗)

如果您使用 **启动参数** 启动 frpc，只需要在启动参数中加上半角逗号 `,` 分隔的其他隧道 ID 即可，例如：

```bash
frpc -f <访问密钥>:<隧道ID>,<另外一个隧道ID>,<更多隧道ID>,...
```

如果您使用 **配置文件** 启动 frpc，可以简单的对配置文件进行合并，例如：

<table style="border-style: none;">
<tr style="border-style: none;">
<td style="border-style: none;">
隧道 1 的配置文件如下：

```ini
[common]
server_addr = idea-leaper-1.natfrp.cloud
server_port = 7000
// 其余部分省略

[TUNNEL_FOR_ALICE]
type = tcp

local_ip = 127.0.0.1
local_port = 2333
// 其余部分省略
```
</td>
<td style="border-style: none;">
隧道 2 的配置文件如下：

```ini
[common]
server_addr = idea-leaper-1.natfrp.cloud
server_port = 7000
// 其余部分省略

[TUNNEL_FOR_BOB]
type = udp

local_ip = 127.0.0.1
local_port = 179
// 其余部分省略
```
</td>
</tr>
</table>
由于两个隧道均位于同一节点，我们可以保留一个 `[common]` 段并将剩余部分合并，得到以下配置文件：

```ini
[common]
server_addr = idea-leaper-1.natfrp.cloud
server_port = 7000
// 其余部分省略

[TUNNEL_FOR_ALICE]
type = tcp

local_ip = 127.0.0.1
local_port = 2333
// 其余部分省略

[TUNNEL_FOR_BOB]
type = udp

local_ip = 127.0.0.1
local_port = 179
// 其余部分省略
```

使用此配置文件启动 frpc，就可以同时连接两条隧道了。

## macOS 提示 frpc 无法打开 :id=macos-run-frpc-issue

!> 我们已对 macOS frpc 文件进行签名和公正，我们建议您不要使用第三方分发的 frpc

当您通过其他渠道下载并运行 frpc 时，可能会出现下列错误：  

![](_images/frpc-macos-run-issue-1.png)  
_“无法打开 “frpc”，因为 Apple 无法检查它是否包含恶意软件。此软件需要更新，请联系开发者了解更多信息。”_

我们推荐您 [通过命令行直接下载和安装 frpc](/frpc/usage#macos-install-frpc)，如果您仍想使运行此二进制文件，请参考下面的指南：

1. 转到 `系统偏好设置 > 安全与隐私`：

   ![](_images/frpc-macos-run-issue-2.png)

2. 找到 frpc 对应的阻止提示，选择 `仍要打开`，您可能需要输入密码并确认操作：

   ![](_images/frpc-macos-run-issue-3.png)

3. 再尝试运行一次 frpc，此时弹出的提示框会有变化。在这个提示框中选择 “打开”，后面就可以正常运行 frpc 了：

   ![](_images/frpc-macos-run-issue-4.png)

## ARM 运行提示 Illegal instruction :id=arm-illegal-instruction

首先，请确认您下载的文件 MD5 与软件下载页面显示的 MD5 相同。

如果您的 [Linux 使用教程/安装 frpc](/frpc/usage#linux-check-arch) 显示为 `armv7l`，请下载 `arm_garbage` 版本重试。否则，请联系管理员。

## Windows 系统命令行版 frpc 开机自启设置方法 :id=windows-simple-autostart

!> 注意，此处列出的方法虽然 **【能用】** 但并不能算 **【正确】** 的操作  
使用此方法会产生大量不可控因素或潜在的安全隐患，如果没有特殊需求请 [使用启动器](/launcher/usage)

1. 将 `frpc.exe` 放置到 `C:\` 目录下
1. 在 `C:\` 目录下新建一个空白文件，命名为 `frpc.bat`
1. 在 `C:\frpc.bat` 文件中写入以下内容
   ```bat
   C:\frpc.exe -f <您的Token>:<隧道ID>
   ```
1. 以管理员身份运行命令提示符，运行以下命令：
   ```bat
   sc create frpc binPath=C:\frpc.bat start=auto
   ```
1. 重启系统，检查效果
