# 全端口穿透 (VPN)

如果您需要远程访问机器的所有端口（或者整个内网），同时保持安全性的话，穿透一个VPN用于访问内网服务会是个不错的选择。

但请注意下面的注意事项：

!> 所有 VPN 隧道都 **必须** 创建在国内，如果创建在国外将导致服务器被屏蔽，此行为将被界定为滥用

!> 如果您不知道您在做些什么，请不要穿透 VPN 以防出现任何安全性问题，未进行适当的安全应对将导致您置于危险的境地中

!> 此文章仅作为索引，不提供任何支持

## 选择VPN程序

对于高级用户：用您比较熟悉的VPN程序，并关闭该篇教程

### OpenVPN （Windows 用户推荐）

OpenVPN 的连接性较好，提供了充足的安全保障，以及较少被运营商截断，所以我们推荐使用 OpenVPN 来访问您的内网。

OpenVPN 的客户端应用存在于各种平台的各种分发渠道中，可以搜索并下载使用。

考虑到易用性，可以使用 [SoftEther](https://www.softether.org/) 以支持多协议的穿透，只需要启动 SE 的 OpenVPN 并映射对应端口即可。

也可直接参考 [该篇文章](http://www.zhujian.org/vps/course/210.html) 搭建 OpenVPN 服务端后，映射对应端口。

对于路由器用户：通常您的集成式固件会集成有 OpenVPN 服务器，如果没有，可以自行根据 [这篇官方教程](https://openwrt.org/docs/guide-user/services/vpn/openvpn/server) 创建。

OpenVPN 提供了 tcp 或 udp 可选的传输方式，请注意映射隧道的类型应与设置相同。

### OpenConnect （Linux/OpenWRT 用户推荐）

OpenConnect 是兼容思科 AnyConnect 协议的 SSLVPN 解决方案，拥有较高的稳定性，且因为 SSLVPN 解决方案在各大企业、组织甚至政府部分中被广泛使用，其被截断的可能性也很小。

因为 OpenConnect 在 Windows 上没有图形化客户端，需要使用商业软件 AnyConnect 的泄露版本，我们不推荐主用 Windows 的用户使用该方案。

但是因为 OpenConnect Server(ocserv) 在 OpenWRT 的图形化环境 LuCI 中支持较好，只需 `opkg install luci-app-ocserv` 之后即可在路由器管理面板中设置服务器，
因此我们仍推荐疲于搭建 OpenVPN 服务器的路由器用户使用这一方案。

### PPTP & L2TP （不推荐）

PPTP 和 L2TP 是非常传统的 VPN 协议选择，但是因为其中前者存在安全性问题，后者被国内很多运营商所屏蔽，我们建议您**不要**使用此二者协议。

### WireGuard （高级用户推荐）

[WireGuard](https://www.wireguard.com/quickstart/) 是一个比较新的高性能易用且安全的 VPN 工具，但是缺少图形化工具且需要一定的网络知识来使用，如果您有心折腾，我们非常推荐您使用该程序。