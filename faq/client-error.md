# 常见问题: 客户端报错

## frpc 常见日志对照 {#frpc-log}

| 英文 | 中文 | 备注 |
| --- | --- | --- |
| connect to local service [`XXX`] error: `YYY` | 连接映射目标 [`XXX`] 失败, 请检查本地服务是否可访问: `YYY` | [点此查看详细说明](#connect-to-local-service-error) |
| Your `XXX` proxy is available now. Use >>`YYY`<< to connect. | `XXX` 隧道启动成功 使用 >>`YYY`<< 连接你的隧道 | 隧道启动成功，一切正常 |
| read from control connection EOF | 控制连接读取失败 (EOF), 可能是网络不稳定 | 网络波动，一般可以忽略或者更换节点 |
| write message to control connection error: `XXX` | 控制连接写入失败, 可能是网络不稳定: `XXX` | 网络波动，一般可以忽略或者更换节点 |
| login to server failed: `XXX` | 登录节点失败, 请检查网络连接: `XXX` | [点此查看详细说明](#login-to-server-failed) |
| router config conflict | 当前 HTTP 隧道已在线, 请勿重复开启 | [点此查看详细说明](#router-config-conflict) |
| Request failed: `XXX` `YYY` | *API 请求失败* | [点此查看详细说明](#api-request-failed) |
| SakuraFrp API failure, please contact administrator | *SakuraFrp API 异常, 请稍后重试或联系我们* | 稍等一段时间并重试，若错误持续出现请 [联系我们](/about.md#contact-us) |

## 隧道重复开启可能出现的错误日志 {#proxy-conflict}

开启了多个 frpc 连接同一条隧道时，就会出现下面的错误日志：

| 英文 | 中文 |
| --- | --- |
| proxy conflict | 当前隧道已在线, 请勿重复开启 |
| multi-instance racing, this one failed | 隧道启动冲突, 请关闭重复开启的 frpc 客户端 |
| port already used | 相关隧道在线, 请勿重复开启 |

请在 **所有设备** 上查找所有存在冲突的 frpc 进程并关闭，确保一条隧道只有 **一个 frpc** 在连接。有时 Supervisor (systemd、pm2) 等配置错误也会造成冲突，推荐您使用启动器管理隧道。

如果实在找不到冲突的 frpc 进程，可以重置访问密钥。不推荐随意重置访问密钥，请将此操作作为最后的手段。

## 无法连接到本地服务 {#connect-to-local-service-error}

::: tip
如果您正在映射 `Minecraft Java` 游戏服务，建议您查看更有针对性的 [MC穿透常见问题](/app/mc.md#connect-to-local-service-error) 页面
:::

此日志说明 **frpc 工作正常**，但是 frpc 无法连接到您的本地服务。

| 原因 | 解决方案 |
| --- | --- |
| 本地服务 (例如 Minecraft 服务器，HTTP 服务器) 没有启动或启动失败 | 检查并启动本地服务 |
| **本地 IP** 发生了变化 | 编辑隧道 **填写正确的本地 IP** 并 **重启 frpc**<br>没有特殊需求请使用 **127.0.0.1** 而不是其他地址 |
| 本地服务配置有误，没有监听 frpc 连接的本地 IP | 正确配置本地服务或修改隧道设置 |
| **本地端口** 或 **本地 IP** 填写错误 | 编辑隧道，参考文档 **填写正确的信息** 然后 **重启 frpc** |
| 电脑上的防火墙、杀毒软件拦截 frpc 请求本地服务 | 添加合理的白名单规则 |
| 隧道协议错误，如软件实际使用 `TCP` 却创建了 `UDP` 隧道 | 删除隧道，重新 **填写正确的信息** 创建隧道 |

下面为您提供一个通常排障思路：

1. 检查本地服务是否可访问

  ::: warning
  检查本地服务是否可访问的视角一定要 **在运行穿透服务（启动器/frpc）的电脑上**。  
  例如，您在家里的电脑上运行了 Minecraft 服务器，然后在路由器上运行了穿透服务，那么您需要先在路由器上检查能否访问 Minecraft 服务器。
  :::

  根据应用的不同，选择不同的方式检查，如：

    - 网页服务可以直接在浏览器中输入 `http://本地IP:本地端口` 查看是否可访问
    - Minecraft 服务器可以在游戏内尝试连接 `本地IP:本地端口`
    - 各种服务都可以在连接要输入 IP 的时候输入您配置到隧道的 **本地 IP**，在需要输入端口的时候输入 **本地端口** 进行测试
  
  如果您是 Windows 用户，**正在使用 TCP 隧道**，您还可以通过 **PowerShell** 运行下面命令来检查端口是否通联：

  ```powershell
  tnc 本地IP -Port 本地端口
  ```

  如果服务正常运行，您可以看到 `TcpTestSucceeded: True`，反之则说明服务不可访问，需要排查是否运行或防火墙问题。

  如果您是一名 Linux 极客，可以自行安装的 `nc` 或 `ncat` 用以检查端口是否通联。

## 登录节点失败, 请检查网络连接 {#login-to-server-failed}

1. 请运行 PING 命令测试节点连通性

   ```bash
   ping <节点域名>

   # 例如
   ping frp-xxx.com
   ```

1. 请查看 [节点状态](https://www.natfrp.com/tunnel/nodes) 页面对应节点是否在线

| <span class="nowrap">在线</span> | PING | 网络 |可能原因 | 解决方案 |
| :---: | :---: |  :---: | --- | --- |
| ✘ |  |  | 节点被攻击、维护中或出现故障 | 换节点 / 等一天再试 |
| ✔ | ✘ |  | 网络故障，防火墙拦截或被墙<br/>_* 部分节点可能禁 PING_ | 换节点 / 换网络 |
| ✔ | ✔ | <span class="nowrap">家里网络 / 热点</span> | 上游防火墙拦截 frp 协议或端口 | 换网络 / 咨询运营商 |
| ✔ | ✔ | 公司 / 校园网 | 网管不允许使用 frp | 那就别用 / 联系网管开通权限<br>参考 [校园/公司网无法连接服务器](/faq/network.md#zoned-network-restriction) |

## URL 路由冲突 {#router-config-conflict}

| 原因 | 解决方案 |
| --- | --- |
| 创建隧道时填写的域名有误 | 填写正确的域名 |
| 服务端路由未释放 | 和 [端口被占用](#proxy-conflict) 类似，解决方案也相同 |

## API 请求失败 {#api-request-failed}

请优先检查 API 连接性问题:

- 检查 SSL 问题
  - Windows 系统请使用 **Internet Explorer** 访问 `https://api.natfrp.com/` 查看是否出现安全警告，如果出现请安装系统更新或者手动安装根证书
  - Linux 系统可以使用 `curl -i https://api.natfrp.com/` 检查是否存在证书错误，如果出现证书错误可以尝试安装 (或更新) `ca-certificates` 包
- 检查防火墙、杀毒软件是否拦截了 frpc 的请求
- 检查宽带是否存在到期未续费等情况，电脑能否正常 **打开网站**（例如 SakuraFrp 首页）

如果还是没有什么头绪，可以查看 [外部状态监控](https://status.natfrp.com/795955161) 中 API 是否正常在线 (<span style="color: #3bd671">**operational**</span>)，如果不在线请联系管理员。
