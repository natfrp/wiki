# SakuraFrp 帮助文档

[faq](/faq.md ':include')

## 文档快速索引

!> 本文档内容丰富，此处索引只列出了一小部分内容，请善用搜索功能

- [Linux 使用](/frpc/usage/linux) | [Linux 开机自启](/frpc/service/systemd) | [Docker](/frpc/usage/docker)

- [Windows 使用](/launcher/usage) | [Windows XP/Vista/Server 2003](/geek#兼容性)

- NAS 相关教程: [群晖 DSM](/app/synology) | [威联通 QNAP](/app/qnap)

- 其他常见应用: [映射网页应用](/app/http) | [远程桌面](/app/rdp) | [远程开机](/app/wol)

## 文档使用指南

- 在左侧列表中根据目录查看对应内容
- 在顶部搜索框中输入关键字、报错信息等内容查询

![](_images/index-1.png)

## 重要提示

本文档中所有 **必须参数** 使用 `<>` 标出，所有 **可选参数** 使用 `[]` 标出，多个可选项使用 `|` 分开。

在实际操作时 **不需要** 输入 `<>` 和 `[]`，当碰到 `|` 分开的选项时只能选择其中 **任意一个** 输入。

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

---

本文档使用 Github Pages 服务托管，[点我前往托管仓库](https://github.com/natfrp/wiki)。

---

## QQ 交流群

### 水群

- 群号：1036050697
- 非官方群，群内没有网站管理员

### VIP 反馈群

请前往 [用户信息](https://www.natfrp.com/user/profile) 页面查看详情。
