---
sidebar: false
contributors: false
---

# 由 SakuraFrp 提供的 RustDesk 服务

RustDesk 是一款开源的远程桌面软件，支持多个主流平台。我们最初计划将其用于远程技术支持，不过由于其功能强大，目前也对部分用户开放试用。

## 使用限制

- **严禁** 将此服务用于非法控制他人设备、窃取信息、电信诈骗等非法用途
- 主控和被控都必须登录 **已完成实名认证** 且 **具有使用权限** 的 SakuraFrp 账户
- 被控默认只接受登录了同一个账户的设备连接，如需授权其他人连接请在 [会话管理](https://www.natfrp.com/remote/rd_session) 界面为被控配置授权 UID
- 目前普通用户可登录 5 个客户端，VIP 用户可登录 50 个客户端
- 原则上我们不支持使用 TCP 隧道功能，滥用该功能可能会造成您的账户被封禁
- 文件传输功能同理，滥用（频繁传输超大文件等）可能会造成您的账户被封禁
- 不对红队用户开放，请自建中继服务器或者用市面上其他成熟的服务 😔

目前我们只对部分用户开放此服务，请 [联系我们](/about.md#contact-us) 申请使用权限。

## 下载软件

您可以选用 [RustDesk 官方发布的版本](https://github.com/rustdesk/rustdesk/releases/latest) 或是 [SakuraFrp 分发的版本](https://github.com/natfrp/rustdesk/releases/latest)。

- 由 SakuraFrp 分发的客户端无需配置服务器，且针对我们的服务进行了优化。  
  适合大部分用户使用
- 官方版本需 [配置服务器](#configure) 才能正常连接 SakuraFrp 提供的 RustDesk 服务。  
  该版本经过了数字签名，如果您非常在意数字签名请使用此版本

::: warning 客户端兼容性说明
~~RustDesk 官方发布的 v1.1.9 版本已一年多未更新过，与我们的 HBBS 存在兼容问题，请下载 Nightly 版本使用~~  
就在我们写这篇文档的时候，RustDesk 官方发布了 `1.2.0` 版本，使用该版本即可正常连接我们的中继服务器
:::

## 配置指南 {#configure}

官方客户端需配置 **ID/中继服务器** 以连接到 SakuraFrp。如果您使用的是 SakuraFrp 分发的客户端，请 [跳过](#login) 这一步。

::: tabs

@tab 桌面客户端

1. 复制下方内容，请确保复制完整、没有多余字符：
  
   ```base64
   9JSPRt2Z2IzQ5cnbrcGZ0gXYDZ1Qx8kYLR1QsZ2aqhHNut2ca5kVWVWOi5WV1JiOikXZrJCLiQmcv02bj5CcyZGdh5mLpBXYv8iOzBHd0hmI6ISawFmIsIiI6ISehxWZyJCLiQWdvx2YuAncmRXYu5SMtQmciojI0N3boJye
   ```

1. 转到 `RustDesk 设置 > 网络`，解锁网络设置后点击 `ID/中继服务器` 卡片右上角的导入按钮：

   ![](./_images/configure-network-desktop.png)

@tab Android 客户端

将下列信息填写到 `设置 > ID/中继服务器` 中：

| 配置项 | 内容 |
| --- | --- |
| ID 服务器 | `rd-1.natfrp.cloud` |
| API 服务器 | `https://api.natfrp.com/rd` |
| Key | `uUnb9eVVNZskn4xjkflCTKbO1CVCax4dg+nw9C26gkQ=` |

请确保 **复制粘贴** 所有内容，避免因输入错误而无法连接。

![](./_images/configure-network-android.png)

:::

## 登录客户端 {#login}

推荐使用您的 SakuraFrp **用户名** 和 **访问密钥** 登录客户端，这样可以在面板显示设备信息。

您也可以点击下面的 `使用 Nyatwork OpenID`（官方客户端 < 1.2.2 显示为 `使用 GitHub`）按钮打开浏览器进行登录。

![](./_images/login.png)

登录完成后，就可以正常使用 RustDesk 远程管理您的设备了。目前您只能管理登录到同一个账户的设备。

## 常见问题

### 开始连接后不到几秒就弹出 Timeout 错误

您可能使用的是 2023.07.01 之前构建的 Nightly 版本，请更新客户端。

### Android / iOS 客户端设置 API 服务器时提示 invalid port value

该问题已于 `1.2.0` 版本被修复，请更新客户端。

### “正在连接” 一段时间后提示连接错误，点击中继连接可正常使用

这是由于官方版本无论 NAT 类型如何均会尝试进行直连。请在连接 ID 后加上 `/r` 强制走中继服务器连接。

### 会话管理页面设备信息显示未知

这是由于您使用了 Nyatwork OpenID 登录，使用用户名 + 访问密钥登录才会记录设备信息。
