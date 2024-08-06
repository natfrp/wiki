# 常见应用配置 Proxy Protocol

配置 Proxy Protocol 可以让您穿透的本地服务获取到客户端真实 IP。

::: warning 注意
在进行下列配置前，请先阅读 [获取真实 IP](/bestpractice/realip.md#proxy-protocol) 并 **修改隧道配置**，否则可能造成**隧道完全不可用**。
:::

## Web 服务器 {#web-servers}

### Nginx {#nginx}

::: tip
在某个 `listen` 端口启用 Proxy Protocol 后，该端口（包括其他配置文件中的相同端口）的所有连接都会按 Proxy Protocol 协议处理  
因此，所有连接到该端口的客户端（frpc）都必须启用 Proxy Protocol 支持，否则会导致连接失败。此外，浏览器将无法直接访问该端口
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

配置完成后，您可以通过 `$proxy_protocol_addr` 变量获取到真实 IP。一个常见的做法是将该变量设置为一个 HTTP 头以便后续应用使用：

```nginx
server {
    listen 80 proxy_protocol;
    listen 443 ssl proxy_protocol;

    # 反向代理
    location ... {
        proxy_set_header X-Real-IP $proxy_protocol_addr;
        proxy_set_header X-Forwarded-For $proxy_protocol_addr;

        # 原有内容
        proxy_pass ...;
    }

    # FastCGI
    location ... {
        fastcgi_param HTTP_X_REAL_IP $proxy_protocol_addr;
        fastcgi_param HTTP_X_FORWARDED_FOR $proxy_protocol_addr;

        # 原有内容
        fastcgi_pass ...;
    }
}
```

现在，您可以通过 `X-Forwarded-For` 和 `X-Real-IP` 两个请求头获取真实 IP 了。

### Apache {#apache}

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

## Minecraft 服务器 {#minecraft}

### BungeeCord / Waterfall {#bungeecord-waterfall}

请参考 [官方文档](https://www.spigotmc.org/wiki/bungeecord-configuration-guide/) 进行配置，您可以搜索 `proxy_protocol` 找到对应内容（在页面底部）。

```yaml
listeners:
- query_port: 25577
  motd: '&1Another Bungee server'

  # 新增此行
  proxy_protocol: true
```

如果您想同时允许 frp 和直接连接，请使用 [HAProxyDetector](https://github.com/andylizi/haproxy-detector)。

### Paper {#paper}

> Paper 1.18.2 服务端支持使用 v2 版本的 Proxy Protocol。

请先为 隧道配置 增加 `proxy_protocol_version = v2` 自定义设置。

#### 修改服务端配置文件 {#paper-properties}

首先，需要确认服务端自带的 **防止代理连接** 功能已经关闭。

请打开 `server.properties` 文件，并按下方示例作修改。

```properties
sync-chunk-writes = true
op-permission-level = 4

# 修改此行
prevent-proxy-connections = false
# false 是默认值。如果您将其调为了 true，那么需要重新修改为 false。
```

> 关于 `server.properties` 每个参数的详细用法，请看 [Geyser 开服指南中的 编辑 Java 版服务端配置文件](/offtopic/mc-geyser.md#编辑配置文件)

#### 修改 Paper 配置文件 {#paper-yml}

请打开 `config/paper-global.yml` 文件，并对此部分作出如下修改:

```yml
proxies:
  ...
  
  # 修改此行
  proxy-protocol: true
```

### Geyser {#geyser}

#### 入 Geyser 流量

只需将 Geyser 配置项中 `enable-proxy-protocol` 设置为 `true`，Geyser 即可解析 frp 提供的真实 IP 信息。

#### 出 Geyser 流量

要在 Geyser 后的 Java 版服务端中使用真实 IP，您需要将配置文件中的 `use-proxy-protocol` 设置为 `true`，并参照本段的其他主题为您的 Java 版服务端启用 Proxy Protocol。

### 其他服务端 {#other}

对于 Spigot，[HAProxyDetector](https://github.com/andylizi/haproxy-detector) 已提供支持。

STFW。
