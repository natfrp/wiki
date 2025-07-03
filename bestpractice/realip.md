# 获取访问者的真实 IP

目前，frp 支持两种获取真实 IP 的方案：

- [XFF 请求头](#xff-header) (适用于 HTTP 隧道)
- [Proxy Protocol](#proxy-protocol) (适用于 TCP、UDP、HTTP、HTTPS 隧道)

请根据您穿透的本地服务选用合适的方案。

## XFF 请求头 {#xff-header}

::: warning
该方案仅适用于 **HTTP** 隧道，不适用于 HTTPS、TCP、UDP 等隧道
:::

使用 HTTP 隧道时，frpc 会自动将客户端的请求 IP 追加到 `X-Forwarded-For` 尾部，您的应用程序可以通过读取这两个请求头来获取客户端真实 IP。您可以参考 [MDN 文档](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/X-Forwarded-For) 获取更多信息。

请注意，XFF 头的前半部分是 **用户完全可控** 的，因此 **前面的数据并不可靠**。我们推荐您只读取最后一个 IP，并且总是做好数据过滤以防出现安全问题。

```http
# 格式说明
X-Forwarded-For: <client>, <proxy1>, ..., <连接到 frps 的 IP>

# 假设连接到 frps 的 IP 为 114.51.4.191，下面是一些例子
X-Forwarded-For: 114.51.4.191
X-Forwarded-For: 127.0.0.1, 1.1.1.1, 6.6.6.6, 114.51.4.191
X-Forwarded-For: '; drop database natfrp --, 114.51.4.191
```

## Proxy Protocol {#proxy-protocol}

::: warning
使用该方案时必须在本地服务也做相应的配置，只修改 frp 配置会造成 **隧道完全不可用**  
UDP 隧道需更新到 0.42.0-sakura-4 以上才能使用此功能
:::

Proxy Protocol 是由 HAProxy 开发者 Willy 提出的一种反向代理协议，目前已被广泛支持。您可以参考 [HAProxy 文档](http://www.haproxy.org/download/1.8/doc/proxy-protocol.txt) 获取更多信息。

启用 [高级用户模式](/geek.md#advanced-mode) 并添加如下 **隧道自定义设置** 后，frpc 就会在请求本地服务时应用 Proxy Protocol 协议：

```ini
proxy_protocol_version = <v1|v2|simple>
```

目前 Proxy Protocol 有两个版本：**v1** 和 **v2**，请先调查您所使用的本地服务支持哪个版本再进行配置。如果两个版本都支持的，我们推荐您使用 **v2** 以提高传输效率。

Proxy Protocol v1 并未为 UDP 设计，在 UDP 隧道中您总是应该使用 **v2**。simple 对应由 Cloudflare 提出的 [Simple Proxy Protocol](https://developers.cloudflare.com/spectrum/reference/simple-proxy-protocol-header/)，由于目前几乎没有应用支持，设置为该选项时务必谨慎操作。

### Web 服务器启用 Proxy Protocol 支持 {#proxy-protocol-web}

::::: tabs

@tab Nginx {#nginx}

::: tip
在某个 `listen` 端口启用 Proxy Protocol 后，该端口（包括其他配置文件中的相同端口）的所有连接都会按 Proxy Protocol 协议处理  
因此，所有连接到该端口的客户端（frpc）都必须启用 Proxy Protocol 支持，否则会导致连接失败；使用浏览器也将无法直接访问该端口，可以使用 [内网访问功能](/frpc/manual#feature-local-access)
:::

在需要启用 Proxy Protocol 的 `server` 块找到 `listen` 字段，并在尾部（分号前面）添加用空格分开的 `proxy_protocol` 即可。举个例子：

<div class="natfrp-side-by-side"><div>

修改前：

```nginx
http {
    server {
        listen 80;
        listen 443 ssl;
        # ...
    }
}
```

</div><div>

修改后：

```nginx
http {
    server {
        listen 80 proxy_protocol;
        listen 443 ssl proxy_protocol;
        # ...
    }
}
```

</div></div>

配置完成后，您可以通过 `$proxy_protocol_addr` 变量获取到真实 IP，可以将其设置为一个头部传递到后端应用等。

一个常见的做法是使用 realip 模块直接将结果覆盖到 `$remote_addr`：

```nginx
server {
    listen 80 proxy_protocol;
    listen 443 ssl proxy_protocol;

    # set_real_ip_from 需要设置为您运行 frpc 机器的内网 IP 或段，或设置为 127.0.0.0/8 表示来自本机
    set_real_ip_from 127.0.0.0/8;
    real_ip_header proxy_protocol;

    # 原有内容...
}
```

现在，您不需要任何其他操作，应用即可获取到真实 IP 了。

@tab Apache {#apache}

如果您的 Apache 版本 **>= 2.4.30**，启用 [mod_remoteip](https://httpd.apache.org/docs/current/mod/mod_remoteip.html#remoteipproxyprotocol) 模块后只需在 Apache 配置文件的对应 `VirtualHost` 中添加 `RemoteIPProxyProtocol On` 即可。

```apache
<VirtualHost *:80>
    ServerName ...

    # 新增此行
    RemoteIPProxyProtocol On
</VirtualHost>
```

顺便一提，您可以使用 `a2enmod remoteip` 命令启用 **mod_remoteip** 模块。

如果您使用的 **Ubuntu 18.04** 和 **CentOS 7** 正大步迈向 EOL 以至于源中没有 Apache 2.4.30 以上的版本，您可以考虑升级系统、自己编译或是使用 [mod-proxy-protocol](https://github.com/roadrunner2/mod-proxy-protocol/) 模块。具体配置方式请参考 README。

:::::

### Minecraft 服务器启用 Proxy Protocol 支持 {#proxy-protocol-minecraft}

::::: tabs

@tab BungeeCord / Waterfall {#bungeecord-waterfall}

请参考 [官方文档](https://www.spigotmc.org/wiki/bungeecord-configuration-guide/) 进行配置，您可以搜索 `proxy_protocol` 找到对应内容（在页面底部）。

```yaml
listeners:
- query_port: 25577
  motd: '&1Another Bungee server'

  # 新增此行
  proxy_protocol: true
```

如果您想同时允许 frp 和直接连接，请使用 [HAProxyDetector](https://github.com/andylizi/haproxy-detector)。

@tab Paper {#paper}

Paper 1.18.2 服务端支持 v2 版本的 Proxy Protocol。

首先，需要确认服务端自带的 **防止代理连接** 功能已经关闭。打开 `server.properties` 文件，按下方示例作修改：

```properties
# 找到此行，修改为 false
prevent-proxy-connections = false
# false 是默认值。如果您将其调为了 true，那么需要重新修改为 false
```

然后，打开 `config/paper-global.yml` 文件，并对此部分作出如下修改:

```yml
proxies:
  ...
  # 修改此行为 true
  proxy-protocol: true
```

@tab Geyser {#geyser}

**入 Geyser 流量**

只需将 Geyser 配置项中 `enable-proxy-protocol` 设置为 `true`，Geyser 即可解析 frp 提供的真实 IP 信息。

**出 Geyser 流量**

要在 Geyser 后的 Java 版服务端中使用真实 IP，您需要将配置文件中的 `use-proxy-protocol` 设置为 `true`，并参照本段的其他主题为您的 Java 版服务端启用 Proxy Protocol。

@tab 其他服务端 {#other}

对于 Spigot，[HAProxyDetector](https://github.com/andylizi/haproxy-detector) 已提供支持。

对于此处没有提及的服务端，请查阅其官方文档或在网上搜索相关的插件。

:::::
