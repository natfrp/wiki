# 获取访问者的真实 IP

!> 该篇教程仅作一个通用的引导，具体配置将需要根据使用场景对您要映射的程序进行配置或修改

## 方案选择

Frp 支持两种获取真实 IP 的方案：
 - HTTP Header
 - Proxy Protocol

## HTTP Header

!> 该方法仅适用于 HTTP 隧道

该方法无需配置，客户端真实 ip 会自动地 append 到 `X-Forwarded-For` 和 `X-Real-IP`。

行为参考 [MDN相关文章](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/X-Forwarded-For)

## Proxy Protocol

!> 该方法不支持 UDP 隧道

在隧道配置时加入配置即可使用：

```
proxy_protocol_version = 版本(v1|v2)
```

?> Proxy Protocol 有两个版本：v1 和 v2，请检查您所使用的服务端程序的支持性以选择使用哪个版本，对于两个都支持的，我们推荐使用 v2 以提高传输效率

我们为常用的支持 Proxy Protocol 的程序提供一个简单的[配置说明](/offtopic/proxy-protocol-configs)，如果您需要使用的程序不在范围内，请询问提供商。
