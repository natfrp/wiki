---
home: true
tagline:
title: 首页
footer: CC-BY-NC-SA-4.0 Licensed with Additional Terms
---
 
::: tip 如何永久关闭首页到处飞的文档链接
点击右下角那个关闭按钮即可永久关闭，您也可以在控制台运行 `localStorage.close_rtfm_alert = '20220119'` 进行关闭
:::

::: warning 关于文档理解的警告
本文档中的内容倾向于为有一定基础的用户提供参考和索引，因此用词通常较为审慎。

如果您是新手用户，我们推荐您将：

- `推荐`、`希望` 等软性正面表述理解为 **必须**
- `不推荐`、`可能有问题` 等软性负面表述理解为 **绝对不**
- 对于 `可以` 等与您主目标无关的分支表述，只要看不懂就 **不要** 尝试
:::

## 帮助文档的正确使用姿势 {#how-to-use}

- 顶栏右侧有常用条目的链接，部分页面的左边栏会显示相关条目的链接
- 在顶部搜索框中输入关键字、报错信息等可进行全文搜索，请善用搜索功能
- 本文档托管于 GitHub，您可以 [前往托管仓库](https://github.com/natfrp/wiki)，或是点击页面底部的编辑链接帮助我们完善文档

::: details 点击展开图片说明

![](./_images/index-1.png)

![](./_images/index-2.png)

:::

## 重要提示 {#important-note}

所有命令建议复制使用，如果要自行输入，请注意区分 `0` (数字) 和 `O` (大写字母) 和 `o` (小写字母)。

本文档中所有 **必须参数** 使用 `<>` 标出，所有 **可选参数** 使用 `[]` 标出，多个可选项使用 `|` 分开。

在实际操作时 **不需要** 输入 `<>` 和 `[]`，当碰到 `|` 分开的选项时只能选择其中 **任意一个** 输入。

1. 例如文档中写道:

   ```ini
   force_https = <Int>
   ```

   您准备将 `force_https` 选项设置为 `302`，则 **应该** 输入:

   ```ini
   force_https = 302
   ```

   而 **不应该** 输入:

   ```ini
   force_https = <302>
   ```

2. 例如文档中写道:

   ```bash
   # 执行
   service frpc <restart|start>
   ```

   您准备执行该命令，则 **应该** 使用:

   ```bash
   service frpc restart
   # 或
   service frpc start
   ```

   而 **不应该** 使用:

   ```bash
   service frpc restart|start
   ```

## 交流群 {#community}

**加入交流群之前，请认真阅读提问指南，以确保您能获得及时、有效的帮助。**

::: tip 提问指南

- 提问时请避免使用 `有人能帮我吗？` 等无意义的问句。
- 提问时请尽可能地详细描述您所遇到的问题和您的目的，并配上截图，最好能配上您的尝试过程，这通常能节约不少时间。
- 如果您实在不会/条件受限无法截图，也请尽可能清晰地拍屏 (避免出现 [摩尔纹](https://baike.baidu.com/item/%E6%91%A9%E5%B0%94%E7%BA%B9/108352) 等影响阅读的情况)
- 大家的回答也许不能马上解决您的问题，请保持耐心，不要着急

:::

### QQ 非官方水群 {#community-qq}

::: danger 警告
加入非官方水群时请 **不要** 填写访问密钥！  
**群内没有网站管理员和客服!**
:::

::: warning 注意
请仔细阅读入群问题并填写对应的回复。入群问题不是摆设, 你不好好填是不会让你进的。  
入群问题并不是主观题。如果您找不到答案请 [Bing搜索](https://www.bing.com/)
:::

- 群号: 766865191 , 1011690081 , 1036050697 , 650510813
- 管理员会在满员时不定时清理最久不发言的成员
- 添加一个群即可, 添加多个群会被管理拒绝加入

### 社区论坛 {#community-forum}

- [点击访问 SakuraFrp BBS](https://www.natfrpbbs.com)
- **非官方论坛**，由社区人员管理

### 其他 IM 水群 {#community-other-im}

- [Telegram](https://t.me/natfrp_unofficial) 桥接至 QQ 一群
- 非官方群, **群内没有网站管理员**

### 官方 QQ 反馈群 {#community-official-qq}

::: tip 提示
官方 QQ 群需在验证问题处填写访问密钥，由机器人自动审核加群请求并绑定账户  
为了维护良好的交流环境，只有通过实名认证的用户才能加入官方反馈群
:::

请前往 [管理面板](https://www.natfrp.com/user/) 点击 `帮助 > QQ 反馈群`，阅读加群须知后点击 `确认加群` 按钮。
