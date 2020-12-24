# 映射安全指南

为了防止出现 [这种情况](https://www.v2ex.com/t/692012 ':target=_blank')，我们为您准备了一些安全设定的指南。

## 通用

1. 对于暴露在网络上的任何东西，密码一定要足够强
2. 不要作死，保持谦逊是美德，也是保护你不被人攻击的隐身咒
3. 如果你知道一个东西以漏洞闻名，那就为它多加防护

## HTTP 安全指南

首先，http 是一个明文传输的协议，对于保证http传输安全且不被篡改的最优先事项应当是升级为 https。

### 添加鉴权

为了保护你的页面不被直接窥视，通过 Basic Auth 添加一个鉴权会是一个低成本的安慰方案。
因为http是一个明文传输的协议，它几乎不具有任何的保护作用，但仍然可以像英国政府一样「让人相信你受到了保护」。

Basic Auth的配置方式大同小异，下面是常见web server的相关文档链接：
 - [Nginx](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/)
 - [Apache](https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-apache-on-ubuntu-16-04)
 - [Caddy](https://caddyserver.com/docs/caddyfile/directives/basicauth)

### 保持程序最新

如果你在使用一个诸如 Wordpress 这种历史悠久的项目，那么你遇到陈年老代码带来漏洞的可能性将急速升高，请务必打开网站程序自带的更新检测，并总是第一时间进行更新。

## HTTPS 安全指南

对于 http 的安全建议同样适用于 https 应用，同时因为不再是明文传输，添加鉴权变成了一个好选择。

## TCP 安全指南

### frpc鉴权

在 0.34.2-sakura-3 之后，frpc现在提供了安全鉴权功能，只要经过适当的配置就可阻止未经授权的ip访问你的服务，从而减少密码爆破、0day等安全风险。

[配置方法](/frpc/manual#tcp_proxy) 中 「auth_pass」项

启动器用户请将配置写到「编辑隧道 - 自定义设置」中。

### RDP 安全

映射远程桌面通常会带来出人意料的风险，因为巨硬的漏洞总是很多。如果你需要映射一个远程桌面，请务必启用[frpc鉴权](#frpc鉴权)避免任何0day在你的电脑上被利用，出现wannacry的悲剧。

**系统更新是你的朋友，不是敌人。** 如果说有一个东西总是能在暴露的风险中拯救你，那一定是阻断药……啊不，系统更新。
系统更新可能会迟到，但是只要到达，它总是能为守护你的电脑奉上你需要的力量。
如果你因为一些理由关闭了系统更新，请不要以任何形式把自己暴露在网络中。
