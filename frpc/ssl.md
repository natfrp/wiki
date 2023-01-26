# 配置 frpc 使用的 SSL 证书

在以下两个典型场景中，您可能会需要 **为 frpc 配置 SSL 证书**，以避免证书错误提示:

1. 隧道启用了 [自动 HTTPS](/frpc/auto-https.md)，但服务访问者不支持（或不愿）忽略 **证书错误提示**
1. 隧道启用了 [访问认证](/bestpractice/frpc-auth.md)，但需要避免认证页面的 **证书错误提示** 以增强安全性

此页将介绍如何为 **frpc** 配置 SSL 证书来避免 **自动 HTTPS** 和 **访问认证** 功能的证书错误提示。如果您没有使用这些功能，此页的内容不适用于您碰到的问题。

## 获取 SSL 证书 {#get-cert}

您需要拥有一个属于自己的域名才能申请、部署 SSL 证书。如果您还没有域名，请先到任意注册商购买一个。

有了域名后，选择一个 SSL 服务商，按照他们的流程进行申请即可。下面是一些常见的 SSL 服务商：

- [Let's Encrypt](https://letsencrypt.org/) (免费)
- [Zero SSL](https://zerossl.com/) (免费)
- [腾讯云](https://cloud.tencent.com/product/ssl)
- [阿里云](https://www.aliyun.com/product/cas)
- [Comodo](https://www.comodo.com/)
- [DigiCert](https://www.digicert.com/)
- [GlobalSign](https://www.globalsign.com/)

SSL 服务商 **不必** 是当前域名的注册商，按需选择适合您的平台即可。

如果下载证书时有多种格式可选，请选择 **Nginx 格式**，简单的说就是有 `.key` 和 `.crt` 文件那种。

::: warning 证书域名注意事项
如您打算通过 `sub.example.com` 访问隧道，那么就应为 `sub.example.com` 或 `*.example.com` 申请证书

- `sub.example.com`：这是 **单域名** 证书，仅对绑定的 `sub.example.com` 有效
- `*.example.com`：这是 **泛域名** 证书，对所有二级域名均有效，如 `a.example.com`、`b.example.com` 等
:::

## 配置 frpc 的 SSL 证书 {#install-cert}

### 更新自动 HTTPS 设置 {#autohttps-enable}

登录管理面板修改隧道配置，在 **自动 HTTPS** 处 **输入你的域名**，该域名应与您申请的 SSL 证书域名一致。

然后，启动隧道以进行测试，让 frpc 生成自签名的证书文件。

### 替换自动 HTTPS 证书文件 {#autohttps-sslfile}

自签名证书在 frpc 的 **工作目录** 中，您需要将其 **替换为** 您申领的 SSL 证书。

::: tabs

@tab Windows 启动器

对于 **v2.0.5.0** 及以上版本，工作目录在 `%ProgramData%\SakuraFrpService\FrpcWorkingDirectory`。

如果您没有对系统进行过 “优化”，这个目录通常是 `C:\ProgramData\SakuraFrpService\FrpcWorkingDirectory`。

对于旧版本启动器，工作目录就是启动器的 **frpc.exe** 所在路径。

@tab Systemd

您可以配置 `WorkingDirectory` 项来指定一个工作目录，例如：

```systemd
[Service]
WorkingDirectory=/etc/frpc
```

如果没有单独进行配置（例如您直接复制了文档中的 Unit 示例），工作目录通常是 `/root`。

@tab Docker

Docker 工作目录默认为 `/run/frpc`，但是该目录中的文件会在容器销毁时丢失。

请使用 `-v` 或 `--mount` 挂载证书文件到该目录中，并且最好挂载为只读。

下面的示例将 `/root/my.{crt,key}` 两个文件挂载到容器的 `/run/frpc/example.com.{crt,key}` 中：

```bash
# 用 -v
docker run (其他参数) \
    -v /root/my.crt:/run/frpc/example.com.crt:ro \
    -v /root/my.key:/run/frpc/example.com.key:ro

# 用 -mount
docker run (其他参数) \
    --mount type=bind,src=/root/my.crt,dst=/run/frpc/example.com.crt,ro \
    --mount type=bind,src=/root/my.key,dst=/run/frpc/example.com.key,ro
```

:::

如果刚才已启动隧道测试，那么此时，在工作目录中就可以看到自签名证书了：

- `example.com.crt`：自签名证书文件
- `example.com.key`：自签名证书的私钥文件

此时应先 **确保隧道已关闭**，随后替换这两个 **自签名证书**：

1. 将您自己申领的 SSL 证书下载到本地，找到其中的 `.crt` 和 `.key` 文件
1. 将 `.crt` 文件重命名为 `你的域名.crt`，如 `example.com.crt`
1. 将 `.key` 文件重命名为 `你的域名.key`，如 `example.com.key`
1. 将重命名后的 SSL 证书放到 frpc 工作目录，并 **直接替换** 里面的文件即可  
   _* Docker 直接挂载进去重启就可以了，不需要进行替换_

最后，重新启动隧道并尝试访问。如果您的配置步骤、申请的证书没有问题，那么将不再出现证书错误提示。

::: warning
如果您发现启动隧道后，frpc 工作目录中您替换的 SSL 证书重新被 frpc 替换为自签名证书，那么说明 frpc 未能解析您的 SSL 证书，请检查证书完整性、各文件是否正确。
:::

### 访问认证配置 SSL 证书 {#authpanel}

- frpc **v0.42.0-sakura-3.1** 及以上版本访问认证会遵循 **自动 HTTPS** 配置项的规则加载证书，参考 [配置 frpc 的自动 HTTPS 功能](/frpc/auto-https.md) 和上面的 [替换自动 HTTPS 证书文件](#autohttps-sslfile) 配置即可
- 对于 **v0.42.0-sakura-3** 及更低版本，您可以通过替换 frpc 工作目录下的 `authpanel.<crt|key>` 让访问认证加载对应的证书

### 设置域名解析 {#authpanel-dns}

> 您为您的 **启用访问认证的隧道** 设置了绑定指定域名的 SSL 证书。
因此在访问时，若要避免证书错误提示，需要通过您的域名访问隧道。

| 主机记录 | 记录类型  | 记录值   | 其他配置项           |
| :------: | :-------: | :------: | :------------------: |
| 自定义   | **CNAME** | 节点域名 | 无特殊需求请保留默认 |

随后，访问 `https://您的域名:远程端口`，即可进入访问认证页面。
