# Proxy Protocol 常见应用配置

在隧道配置中添加 `proxy_protocol_version = 版本` 后，你还需要对 frpc 端附近的应用进行配置，以让其获取真实 IP。

## Nginx

为 Nginx 配置 Proxy Protocol，需要在配置文件中修改相应的监听语句，添加 `proxy_protocol` 到 `listen` 语句的最后（分号前面）：

```
http {
    #...
    server {
        listen 80   proxy_protocol;
        listen 443  ssl proxy_protocol;
        #...
    }
}
```

此时已经为 Nginx 启用了 Proxy Protocol，并可以在 Nginx 配置文件中通过 `$proxy_protocol_addr` 使用真实 IP。

要让后续的应用可以得到真实 IP，需要添加下面的配置到 `server` 段中：

```
proxy_set_header X-Forwarded-For $proxy_protocol_addr;
proxy_set_header X-Real-IP $proxy_protocol_addr;
```

此时，在应用中可以通过 `X-Forwarded-For` 和 `X-Real-IP` 来获取真实的 IP 和协议。

## Apache Web Server

如果你的 Apache 版本 >= 2.4.30，只需要在 Apache 配置文件的对应 vhost 段添加 `RemoteIPProxyProtocol On` 即可：

```bash
a2enmod remoteip # 如果你没有，记得启用 RemoteIP 模块
```

```apache
Listen 80
<VirtualHost *:80>
    ServerName www.example.com
    RemoteIPProxyProtocol On
</VirtualHost>
```

如果你使用的 Ubuntu 18.04 和 CentOS 7 正大步迈向 EOL 以至于源中没有 Apache 2.4.30 以上的版本，除了升级系统和自己编译外，你还可以使用 [mod-proxy-protocol](https://github.com/roadrunner2/mod-proxy-protocol/) 并跟随 readme 操作。

## Minecraft

请使用 [这个插件](https://github.com/andylizi/bc-haproxy-detector)，[MCBBS 帖子](https://www.mcbbs.net/thread-1111852-1-1.html)。

