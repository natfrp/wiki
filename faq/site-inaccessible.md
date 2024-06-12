# 常见问题: 无法访问映射的网站

首先，您需要正确区分 **HTTP(S) 隧道** 和 **TCP 隧道映射 HTTP(S) 流量**：

| 网站访问方式 | 穿透类型 |
| --- | --- |
| `http://www.example.com` 或 `https://www.example.com` | HTTP(S) 隧道 |
| `http://www.example.com:12345` (注意此处带了端口 `12345`) | TCP 隧道映射 HTTP 流量 |
| `https://www.example.com:54321` (注意此处带了端口 `54321`) | TCP 隧道映射 HTTPS 流量 |

## 建站条件 {#site-requirement}

不满足下表中的任一条件均会造成网站无法访问，此时请更换映射方式或节点：

::: tip
此处的 *需实名认证* 指的是在 **SakuraFrp 管理面板** 完成 [实名认证](https://www.natfrp.com/user/realname)，而非 **域名提供商的** 实名认证
:::

| 节点类型 | HTTP(S) 隧道 | TCP 隧道映射 HTTP 流量 | TCP 隧道映射 HTTPS 流量 |
| --- | --- | --- | --- |
| 海外节点 | 需实名认证 | √ | √ |
| 其他节点 | 需实名认证和 [ICP备案](https://baike.baidu.com/item/ICP%E5%A4%87%E6%A1%88) | × (请 [配置自动 HTTPS](/frpc/auto-https.md)) | √ |

## HTTP 隧道出现 503 错误 {#http-503}

当您访问映射的网站时，如果出现 `503 Service Unavailable` 错误，请检查是否存在以下情况：

1. 绑定的域名和您访问的域名是否 **完全相同**？配置文件里是否有打错字？
   - `natfrp.com` 和 `www.natfrp.com` 是两个不同的域名，请不要混淆
   - 同理，`a.natfrp.com` 和 `b.natfrp.com` 自然也是两个不同的子域名

1. 域名解析到的节点是否和隧道所在的节点相同？
   - DNS 解析修改后并不是立即生效的，解析结果缓存时长从 10 分钟到一星期不等，请等待解析生效后再试
   - Windows 用户可以使用这条命令查询 DNS 解析结果：

     ```batch
     nslookup <您的域名>
 
     # 例如
     nslookup www.example.com
     ```

   - *nix 用户可以使用这条命令查询 DNS 解析结果：

      ```bash
      dig <您的域名>

      # 例如
      dig www.example.com
      ```

1. 本地的 Web 服务是否成功启动？隧道映射的本地 IP 和端口号是否正确？
   - 是否能在 **运行 frpc 的电脑** 通过 **本地 IP** 和 **本地端口** 访问您的网站？
   - frpc 有没有显示 `无法连接到本地服务` 等错误？

1. 客户端是否成功启动并出现 `隧道启动成功` 字样？
   - 不要先急着设置开机自启，先手动启动程序确认是否可以成功启动
   - 在 Windows 上最好使用启动器管理隧道

1. (HTTPS 隧道) 隧道是否正确创建？访问的时候有没有输入完整的 `https://` 前缀？
   - 只创建 HTTPS 隧道会导致使用 HTTP 协议访问时出现 503 错误

如果使用以上方法都不能排除故障，那么请尝试 **更换节点**，如果还是不行可以考虑更换服务商。

## 配置 frpc 的自动 HTTPS 功能 {#frpc-auto-https}

本节内容已被移动，请到 [这里](/frpc/auto-https.md) 查看。
