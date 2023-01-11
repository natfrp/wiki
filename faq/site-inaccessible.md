# 常见问题: 无法访问映射的网站

首先，您需要正确区分 **HTTP(S) 隧道** 和 **TCP 隧道映射 HTTP(S) 流量**：

| 网站访问方式 | 穿透类型 |
| --- | --- |
| `http://www.example.com` 或 `https://www.example.com` | HTTP(S) 隧道 |
| `http://www.example.com:12345` (注意此处带了端口 `12345`) | TCP 隧道映射 HTTP 流量 |
| `https://www.example.com:54321` (注意此处带了端口 `54321`) | TCP 隧道映射 HTTPS 流量 |

## 建站条件 {#site-requirement}

不满足下表中的任一条件均会造成网站无法访问，此时请更换映射方式或节点：

!> 此处指的是在 **本站内的** 实名认证，而非 **域名提供商的** 实名认证

| 节点类型 | HTTP(S) 隧道 | TCP 隧道映射 HTTP 流量 | TCP 隧道映射 HTTPS 流量 |
| --- | --- | --- | --- |
| 海外节点 | 需实名认证 | √ | √ |
| 台州多线、嘉兴多线、绍兴多线 | × | × | × (任何 TLS 流量都会被阻断，包括部分 RDP 连接和 FTPS 连接) |
| 其他节点 | 需实名认证和 [ICP备案](https://baike.baidu.com/item/ICP%E5%A4%87%E6%A1%88) | × (请 [配置自动 HTTPS](#frpc-auto-https)) | 需实名认证 |

## 配置 frpc 的自动 HTTPS 功能 {#frpc-auto-https}

!> 配置 "自动 HTTPS 功能" 的本质就是借助 frpc 给流量套了一层 TLS  
我们推荐您尽可能使用所穿透服务内建的 TLS 实现，不要过度依赖此功能

中国内地节点不允许直接通过 TCP 隧道转发明文 HTTP 流量，您可以配置 frpc 并将 HTTP 服务自动转换为 HTTPS 服务：

1. 编辑隧道并在 **自动 HTTPS** 处选择 `自动` 
   ![](_images/site-inaccessible-auto-https.png)
2. 重启 frpc
3. 使用 `https://连接方式` 的形式访问您穿透的服务即可
4. (可选) 如果您想避免证书错误提示，请自己申请 SSL 证书并替换 frpc 工作目录下的相关证书文件

   ::: tip
   对于使用 Systemd 方式启动的 frpc，您可能需要配置 `WorkingDirectory` 项来指定一个工作目录
   :::

   ::: tip
   对于 v2.0.5.0 及以上版本的启动器，工作目录在 `%ProgramData%\SakuraFrpService\FrpcWorkingDirectory`，通常为 `C:\ProgramData\SakuraFrpService\FrpcWorkingDirectory`
   :::

如果需进行高级配置，请参考下面列出的 `auto_https` 的取值：

- 留空 **[默认值]**: 禁用自动 HTTPS 功能
- `auto`: frpc 将使用 `server_name` 作为证书 **CommonName** 生成自签证书
- 其他值:  
  frpc 将尝试加载当前工作目录(cwd)下 `<auto_https>.crt` 和 `<auto_https>.key` 两个证书文件  
  *注: 对于 Docker，cwd 默认为 `/run/frpc`*  
  若文件不存在或解析失败则使用 `<auto_https>` 作为 **CommonName** 生成一份自签名证书并保存到上述文件中  
  *注: 若文件已存在，`<auto_https>` 就作为一个单纯的文件名进行处理，不会对证书产生影响*

::: tip
自动 HTTPS 功能会在隧道启动时发送 `HEAD /\r\n\r\n` 请求检测您穿透的服务是否真的为 HTTPS 服务，该行为在 0.42.0-sakura-2.1 及以上版本的 frpc 中可以被 [auto_https_mode](/frpc/manual#tcp_proxy) 开关强制覆写
:::

## HTTP 隧道出现 503 错误 {#http-503}

当您在访问网站时出现 `503 错误` 提示时，请检查是否存在以下情况：

+ 绑定的域名和您访问的域名是否 **完全** 相同，是否有打错字的情况。
  - `natfrp.com` 和 `www.natfrp.com` 是两个完全不同的子域名，请勿混淆。
+ 域名解析指向的节点是否和您隧道创建到的节点相同。
  - 一般免费的 DNS 解析服务，解析结果缓存时长从 10 分钟到一星期不等，请等待解析生效后再试。*提示：您可以使用 `dig type domain @dns_server` 查询 DNS 解析结果*
+ 检查本地的 web 服务是否成功启动。
  - 是否能在**本地**访问您的网站。
+ 隧道映射的本地 IP 和端口号是否正确。
  - 您是否能够通过该隧道设置的**本地**地址和**本地**端口访问您的 web 服务。
+ 客户端是否成功启动并出现 `start proxy success` 字样。
  - 不要先急着设置开机自启，先手动启动程序确认是否可以成功启动
+ [针对 HTTP(S) 隧道] 隧道是否成对创建（一个 HTTP、一个 HTTPS）。
  - 只创建 HTTP 隧道会导致无法使用 HTTPS 协议访问。
  - 只创建 HTTPS 隧道会导致无法使用 HTTP 协议访问。

如果以上方法都不行，那么请尝试**更换节点**，如果还是不行可以考虑更换服务商。
