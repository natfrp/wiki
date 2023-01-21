# 配置 frpc 使用的 SSL 证书

::: tip
您需要拥有一个属于自己的域名才能申请、部署 SSL 证书。如果您还没有域名，请先到任意注册局购买一个。
:::

在以下两个使用场景中，您可能会需要 **为 frpc 配置 SSL 证书**，以避免证书错误提示:

1. 外网服务或用户需通过 **TCP** 或 **HTTP(S)** 访问穿透的服务，但 **外网服务或用户** 无法 (不愿) 忽略证书错误提示。
1. 隧道启用了访问认证，但需要避免用于认证的 `https://idea-leaper-1.natfrp.cloud:12345` 页面的 **证书错误提示**

此页将介绍如何为 **frpc** 在这两种环境下配置 SSL 证书。

## 获取 SSL 证书 {#ssl}

> 如果您还不知道如何设置、申领 SSL 证书，请阅读此章节。
否则，请直接跳到 [后续内容](#autohttps)。

### 选择 SSL 服务商 {#ssl-choose}

通常，域名注册商会一并提供 DNS 解析，部分服务商还会同时提供 SSL 证书申请。

::: tip
SSL 服务商不必须是当前域名的注册商或解析服务商。
:::

SSL 服务商通常使用 DNS 解析记录来验证域名所有权，因此选择适合您的平台即可。

> [Nyatwork SSL](https://get.ssl.moe) 证书成本价售卖中。

### 申领证书 {#ssl-get}

#### 设置证书域名 {#ssl-get-domain}

如您打算通过 `sub.example.com` 访问隧道，那么就应为 `sub.example.com` 或 `*.example.com` 申请证书。

- `sub.example.com`: 这是单域名证书，仅对绑定的 `sub.example.com` 有效。
- `*.example.com`: 这是泛域名证书，针对任何 `example.com` 下的二级域名均有效，如 `sub.example.com`。

#### 验证域名所有权 {#ssl-verify-domain}

在申请证书后，服务商为了验证该证书绑定的 **域名** 是您所有，需要您为域名在解析服务商处添加 DNS 记录。

- 该记录的类型不固定，看服务商怎么验证，通常为 **CNAME 或 TXT** 等。
- 添加记录后需要一定的验证时间，请以服务商给出的信息为准。

> 以上都是基础的证书相关知识，不再作过多说明。

## 自动 HTTPS 配置 SSL 证书 {#autohttps}

### 启用自动 HTTPS {#autohttps-enable}

#### 配置隧道 {#autohttps-setup}

请先参考 [配置 frpc 的自动 HTTPS 功能](/frpc/auto-https.md) 页面，来启用自动 HTTPS。

::: warning
此时不要直接在隧道配置的 **自动 HTTPS** 处选择 `自动`。
:::
由于您有自定义域名，因此请直接在该参数处输入 `你的域名`，该域名应与您申请的 SSL 证书的绑定域名一致。

#### 测试隧道 {#autohttps-test}

此时，您可以先 **启动隧道** 以进行测试，由 frpc 生成自签名的证书文件。

> 现在，通过 `htttps://节点域名:远程端口` 访问隧道时，仍会提示证书错误。
因为该 `自签名证书` 没有绑定相应的域名。

### 替换 SSL 证书文件 {#autohttps-sslfile}

自签名证书在 frpc 的工作目录中。您需要将其替换为您申领的 SSL 证书。

> 对于使用 Systemd 方式启动的 frpc，您可能需要配置 `WorkingDirectory` 项来指定一个工作目录。
> 对于 v2.0.5.0 及以上版本的启动器，`工作目录在 %ProgramData%\SakuraFrpService\FrpcWorkingDirectory`，通常为 `C:\ProgramData\SakuraFrpService\FrpcWorkingDirectory`。

请找到 frpc 工作目录。

如果刚才已启动隧道测试，那么此时，在 **frpc 工作目录** 中就可以看到自签名证书了:

- `example.com.crt`: 自签名证书文件。
- `example.com.key`: 自签名证书的私钥文件。

此时应先 **确保隧道已关闭**，随后替换这两个 **自签名证书**:

1. 将您自己申领的 SSL 证书下载到本地，找到其中的 `xxx.crt` 和 `xxx.key` 文件。
1. 将 `xxx.crt` 重命名为 `你的域名.crt`，如 `example.com.crt`。
1. 将 `xxx.key` 重命名为 `你的域名.key`，如 `example.com.key`。
1. 将重命名后的 SSL 证书放到 frpc 工作目录，并 **直接替换** 自签名证书。

最后，重新启动隧道。

> 启动后，请尝试访问该隧道，并检查是否有错误提示。
如果您的配置步骤、申请的 SSL 证书没有问题，那么将不再出现证书错误提示。

::: warning
如果您发现启动隧道后，frpc 工作目录中您替换的 SSL 证书重新被 frpc 替换为自签名证书，那么说明 frpc 未能解析您的 SSL 证书，请检查证书完整性、各文件是否正确。
:::

## 访问认证配置 SSL 证书 {#authpanel}

> 请查看 [配置访问认证功能](/bestpractice/frpc-auth.md) 获取启用访问认证功能的帮助

- frpc **v0.42.0-sakura-3.1** 及以上版本访问认证会遵循 **自动 HTTPS** 配置项的规则加载证书，参考 [配置 frpc 的自动 HTTPS 功能](/frpc/auto-https.md) 和上面的 [替换 SSL 证书文件](#autohttps-sslfile) 配置即可。
- 对于 **v0.42.0-sakura-3** 及更低版本，您可以通过配置 frpc 工作目录下的 'authpanel.<crt|key>' 并使用恰当的域名访问。

### 设置域名解析 {#authpanel-dns}

> 您为您的 **启用访问认证的隧道** 设置了绑定指定域名的 SSL 证书。
因此在访问时，若要避免证书错误提示，需要通过您的域名访问隧道。

| 主机记录 | 记录类型  | 记录值   | 其他配置项           |
| :------: | :-------: | :------: | :------------------: |
| 自定义   | **CNAME** | 节点域名 | 无特殊需求请保留默认 |

随后，访问 `https://您的域名:远程端口`，即可进入访问认证页面。
