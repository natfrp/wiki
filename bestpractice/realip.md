# 获取访问者的真实 IP

目前，frp 支持两种获取真实 IP 的方案：
 - XFF 请求头
 - Proxy Protocol

请根据您穿透的本地服务选用合适的方案。

## XFF 请求头 {#xff-header}

!> 该方案仅适用于 **HTTP** 隧道，不适用于 HTTPS、TCP、UDP 等隧道

使用 HTTP 隧道时，frpc 会自动将客户端的请求 IP 追加到 `X-Forwarded-For` 尾部，您的应用程序可以通过读取这两个请求头来获取客户端真实 IP。您可以参考 [MDN 文档](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/X-Forwarded-For) 获取更多信息。

请注意，XFF 头的前半部分是 **用户完全可控** 的，因此 **前面的数据并不可靠**。我们推荐您只读取最后一个 IP，并且总是做好数据过滤以防出现安全问题。

```
# 格式说明
X-Forwarded-For: <client>, <proxy1>, ..., <连接到 frps 的 IP>

# 假设连接到 frps 的 IP 为 114.51.4.191，下面是一些例子
X-Forwarded-For: 114.51.4.191
X-Forwarded-For: 127.0.0.1, 1.1.1.1, 6.6.6.6, 114.51.4.191
X-Forwarded-For: '; drop database natfrp --, 114.51.4.191
```

## Proxy Protocol {#proxy-protocol}

!> 使用该方案时必须在本地服务也做相应的配置，只修改 frp 配置会造成 **隧道完全不可用**  

!> UDP 隧道需更新到 0.42.0-sakura-4 以上才能使用此功能

Proxy Protocol 是由 HAProxy 开发者 Willy 提出的一种反向代理协议，目前已被广泛支持。您可以参考 [HAProxy 文档](http://www.haproxy.org/download/1.8/doc/proxy-protocol.txt) 获取更多信息。

在隧道配置中启用 **高级设置** 并添加如下自定义配置后，frpc 就会在请求本地服务时应用 HAProxy 协议：

```ini
proxy_protocol_version = <v1|v2>
```

目前 Proxy Protocol 有两个版本：**v1** 和 **v2**，请先调查您所使用的本地服务支持哪个版本再进行配置。如果两个版本都支持的，我们推荐您使用 **v2** 以提高传输效率。

Proxy Protocol v1 并未为 UDP 设计，在 UDP 隧道中您总是应该使用 **v2**。

我们为常见的支持 Proxy Protocol 的程序提供一个简单的 [配置说明](/offtopic/proxy-protocol)，如果这个说明中没有列出您使用的本地服务，请咨询程序开发者或 STFW。
