# frpc 常见问题

### 如何通过一个 frpc 开启多条隧道

?> 一个 frpc 只能连接一个 **节点**，但可以连接多条 **隧道**  
详见 [其他常见问题-一个 frpc 可以连接多条隧道吗](/faq#一个-frpc-可以连接多条隧道吗)

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

### Windows 系统命令行版 frpc 开机自启设置方法

!> 注意，此处列出的方法虽然 **【能用】** 但并不能算 **【正确】** 的操作  
使用此方法会产生大量不可控因素或潜在的安全隐患，如果没有特殊需求请 [使用启动器](/launcher/usage)

- 第一步：将 `frpc.exe` 放置到 `C:\` 目录下
- 第二步：在 `C:\` 目录下新建一个空白文件，命名为 `frpc.bat`
- 第三步：在 `C:\frpc.bat` 文件中写入以下内容
  ```bat
  C:\frpc.exe -f <您的Token>:<隧道ID>
  ```
- 第四步：以管理员身份运行命令提示符，运行以下命令：
  ```bat
  sc create frpc binPath=C:\frpc.bat start=auto
  ```
- 第五步：重启系统，检查效果
