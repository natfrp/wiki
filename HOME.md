# Sakura Frp 帮助文档

## 重要提示

本文档中所有 **必须参数** 使用 `<>` 标出，所有 **可选参数** 使用 `[]` 标出，多个可选项使用 `|` 分开

在实际操作时 **不需要** 输入 `<>` 和 `[]`，当碰到 `|` 分开的选项时只能选择其中 **任意一个** 输入

1. 例如文档中写道:

   ```
   force_https = <Int>
   ```

   您准备将 `force_https` 选项设置为 `302`，则 **应该** 输入:

   ```
   force_https = 302
   ```

   而 **不应该** 输入:

   ```
   force_https = <302>
   ```

2. 例如文档中写道:

   ```
   执行 service frpc <restart|start>
   ```

   您准备执该命令，则 **应该** 使用:

   ```
   service frpc restart
   或
   service frpc start
   ```

   而 **不应该** 使用:

   ```
   service frpc restart|start
   ```

## 如何查询

- 在左侧列表中按照分类查看对应内容。
- **您可以在左侧搜索框中输入关键字、报错信息等内容查询。**

本文档使用 Github Pages 服务托管，[点我前往托管仓库](https://github.com/natfrp/wiki)。

## **非官方** QQ 交流群

$群号：\bold{1149532962}\ \ \ \small{验证问题答案：\large{1}}\ \ \ \ $
<small>（也可点击链接快速加群：<https://jq.qq.com/?_wv=1027&k=Em3grmqF>）</small>

## 提示

- Sakura Frp 并没有可用性保障，由本服务可用性问题所造成的损失概不负责。
- 将您的内网服务暴露在公网将带来一定的安全风险，请做好安全措施。
- 企业用户请慎重考虑使用本服务，原因请 [点此查看前车之鉴](https://www.v2ex.com/t/692012 ':target=_blank')
