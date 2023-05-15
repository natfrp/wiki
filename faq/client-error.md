# 常见问题: 客户端错误

## frpc 常见日志对照 {#frpc-log}

| 英文 | 中文 | 备注 |
| --- | --- | --- |
| Your `XXX` proxy is available now. Use [`YYY`] to connect. | `XXX` 类型隧道启动成功 使用 [`YYY`] 来连接到你的隧道 | 隧道启动成功，一切正常 |
| Recover success: [`XXX`] | 不断线重连成功: [`XXX`] | 网络波动，一般可以忽略或更换节点 |
| recover to server timed out | 不断线重连失败 | 网络波动，frpc 会自动尝试另外一种重连方式，一般可以忽略或更换节点 |
| Connection recover failed: `XXX` | 不断线重连失败: `XXX` | 网络波动，frpc 会自动尝试另外一种重连方式，一般可以忽略或更换节点 |
| read from control connection EOF | 控制连接读取失败 (EOF), 可能是网络不稳定 | 网络波动，一般可以忽略或者更换节点 |
| write message to control connection error: `XXX` | 控制连接写入失败, 可能是网络不稳定: `XXX` | 网络波动，一般可以忽略或者更换节点 |
| login to server failed: `XXX` | 登录节点失败, 请检查网络连接: `XXX` | [点此查看详细说明](#login-to-server-failed) |
| connect to local service [`XXX`] error: `YYY` | 连接映射目标 [`XXX`] 失败, 请检查本地服务是否打开: `YYY` | [点此查看详细说明](#connect-to-local-service-error) |
| proxy conflict | *隧道冲突* | 该问题是由于隧道重复开启造成的，请查找 **所有设备** 上的 frpc 进程并关闭重复开启的隧道。如果此问题持续存在，请尝试重置访问密钥 |
| multi-instance racing, this one failed | *多实例竞争* | 该问题是 frpc 重复开启且生成了相同的 RunID，在 frps 上争抢同一个隧道造成的。请在 **当前设备** 上查找所有存在冲突的 frpc 进程并关闭，或检查 supervisor 配置是否有误 |
| port already used | *服务端端口被占用* | [点此查看详细说明](#port-already-used) |
| router config conflict | *URL 路由冲突* | [点此查看详细说明](#router-config-conflict) |
| Request failed: `XXX` `YYY` | *API 请求失败* | [点此查看详细说明](#api-request-failed) |
| SakuraFrp API failure | *SakuraFrp API 出现故障* | 看到此错误请重试，若错误持续出现请 [联系我们](/about.md#contact-us) |

## 登录节点失败, 请检查网络连接 {#login-to-server-failed}

1. 请运行 PING 命令测试节点连通性

   ```bash
   ping <节点域名>

   # 例如
   ping idea-leaper-1.natfrp.cloud
   ```

1. 请查看 [节点状态](https://www.natfrp.com/tunnel/nodes) 页面对应节点是否在线

| 节点在线 | PING 测试 | 可能原因 | 解决方案 |
| :---: | :---: | --- | --- |
| ✘ |  | 节点被攻击或故障 | 换节点 / 等一天再试 |
| ✔ | ✘ | 网络故障 | 换节点 / 换网络 |
| ✔ | ✘ | 节点被墙了 | 换节点 |
| ✔ | ✔ | 上游防火墙拦截 frp 协议或 7000 / 7001 端口 | 换网络 / 找别家 |
| ✔ | ✔ | 公司 / 学校网管不允许使用 frp | 那就别用 / 联系网管开通权限 |

## 服务端端口被占用 {#port-already-used}

| 原因 | 解决方案 |
| --- | --- |
| 隧道刚刚被关闭 | 启动器: **关闭隧道** <br> frpc: **退出 frpc** <br> 等待 **一分钟** 后重新开启 |
| 存在 frpc 进程残留 | 启动器: 右键点击托盘图标, **彻底退出** 后重新打开启动器 <br> frpc: 打开 **任务管理器** 查找并 **关闭** 残留的 frpc 进程 |
| 重复开启隧道 | 一条隧道同一时间只能在一个地方开启<br>请 **关闭重复开启的隧道** 并 **创建不同端口的隧道** 使用 |

## URL 路由冲突 {#router-config-conflict}

| 原因 | 解决方案 |
| --- | --- |
| 创建隧道时填写的域名有误 | 填写正确的域名 |
| 服务端路由未释放 | 和 [端口被占用](#port-already-used) 类似，解决方案也相同 |
| **高级设置** 中 URL 路由配置错误 | 您是高级用户，请自行寻找解决方案<br>如果是不小心填写的，请删掉相关配置项 |

## API 请求失败 {#api-request-failed}

请优先检查 API 连接性问题:

- 检查 SSL 问题
  - Windows 系统请使用 **Internet Explorer** 访问 `https://natfrp-api.globalslb.net/` 查看是否出现安全警告，如果出现请安装系统更新或者手动安装根证书
  - Linux 系统可以使用 `curl -i https://natfrp-api.globalslb.net/` 检查是否存在证书错误，如果出现证书错误可以尝试安装 (或更新) `ca-certificates` 包
- 检查防火墙、杀毒软件是否拦截了 frpc 的请求
- 检查宽带是否存在到期未续费等情况，电脑能否正常 **打开网站**（例如 SakuraFrp 首页）

如果还是没有什么头绪，可以查看 [外部状态监控](https://status.natfrp.com/785657645) 中 API 是否正常在线 (<span style="color: #3bd671">**operational**</span>)，如果不在线请联系管理员。

## 无法连接到本地服务 {#connect-to-local-service-error}

此日志说明 **frpc 工作正常**，但是 frpc 无法连接到您的本地服务。

| 原因 | 解决方案 |
| --- | --- |
| 本地服务 (例如 Minecraft 服务器，HTTP 服务器) 没有启动或启动失败 | 检查并启动本地服务 |
| 本地服务配置有误，没有监听 frpc 连接的本地 IP | 正确配置本地服务或修改隧道设置 |
| **本地端口** 或 **本地 IP** 填写错误 | 编辑隧道，参考文档 **填写正确的信息** 然后 **重启 frpc** |
| **本地 IP** 发生了变化 | 重新检查本地地址，然后编辑隧道 **填写正确的本地 IP** 并 **重启 frpc** |
| 防火墙、杀毒软件拦截 frpc 请求本地服务 | 添加合理的白名单规则到防火墙、杀毒软件中 |
