---
sidebar: false
---

# 高级用户相关说明

## 数据安全 {#data-security}

我们严格按照 [隐私策略](https://www.natfrp.com/policy/privacy) 执行，并使用最新版本服务端软件。

在架构设计适宜、法律法规许可的情况下总是使用 E2E 设计，以保证我们也无法解密您的数据。

## 软件安全 {#software-security}

目前我们只提供启动器源码，frpc/frps 均不开源，但对外分发的二进制文件未经过加密或混淆，您可以直接拖进 IDA 进行审计。

但是，由我们分发的启动器安装包中 frpc 带有混淆，这是为了缓解 cli 版本被滥用造成启动器被杀软误杀的问题。

如果您不信任经过混淆的 frpc 二进制文件，可以考虑自行编译启动器、去掉签名校验并使用我们另外分发的无混淆版本，二者是兼容的。

## 自定义性 {#customization}

关于我们的修改版客户端，我们提供配置文件项和参数可供自定义，详情请查看 [frpc 用户手册](/frpc/manual.md) 。

要加入任何隧道参数，建议在隧道的「自定义设置」文本框中填入，从而在使用 `-f` 启动 frpc 时自动同步。

也可使用直接编辑 `frpc.ini` 的方式自定义，请从隧道列表的「配置文件」项目中复制并修改，只要不修改关键连接参数（`host`, `port`, `token`, `user`, ...），均可正常运行。

## 启动器移植 {#porting-launcher}

如果您想要自己实现启动器的话，可以参考 [SakuraFrp API 文档](https://natfrp-api.globalslb.net/docs/) 接入我们的服务。

目前存在的第三方启动器实现：

- [yuhencloud/SakuraFrpLauncher in Qt](https://github.com/yuhencloud/SakuraFrpLauncher)

## 兼容性 {#compatibility}

我们的服务兼容 [上游开源版本](https://github.com/fatedier/frp) 的客户端 `0.18.0+` 。

也就是说您可以使用几乎任何现有的 frp 客户端来使用我们的服务，只需根据隧道的「配置文件」手动填写关键连接参数，或直接复制配置文件启动即可

如果您是使用 Windows XP 或 Windows Vista 的极客用户，请使用上游的 [0.28.2 版本](https://github.com/fatedier/frp/releases/tag/v0.28.2) 。

使用任何非本网站分发的最新版客户端，均视为放弃相关支持，由此带来的任何问题请您发扬极客精神自行解决。
