# UGREEEN 绿联 NAS 穿透指南

::: tip
此文档由 [社区贡献者 @Aewait 提供](https://github.com/natfrp/wiki/pull/223)，其内容不受 SakuraFrp 项目工作人员支持，供您参考。
:::

截至 `2022-11-27`，绿联 NAS 客户端穿透方式未被此文档作者发现。

本教程只适用于使用 SakuraFrp 穿透 docker 容器端口，如 qBittorrent 或 Jellyfin，本教程以 qBitorrent 为例。

## Docker安装

在绿联 NAS 操作面板中找到 **docker - 镜像管理**，搜索 `natfrp/frpc`，安装最新版本（latest）：

![](./_images/ugreen-add-docker-img.png)

### 创建隧道

打开 **docker - 网络管理**，记录下 bridge 的**网关 IP**，即 `172.17.0.1`：

![](./_images/ugreen-docker-bridge.png)

进入 SakuraFrp，打开 **服务 - 隧道列表**，按需创建一个隧道（示例穿透网页应用，故使用 TCP）。

其中本地 IP 填上面记下的 **网关 IP**（此处为 `172.17.0.1`），本地端口填您需要穿透的 docker 容器端口，
如穿透的 app 使用 http 则需开启 `自动 https`：

> 示例所用 qBitorrent 的 WebUI 本地端口为 8990，SakuraFrp 设置中的本地端口即填写 8990

![](./_images/ugreen-add-tcp.png)

配置完后，点击创建。创建成功后，点击右侧三个点，选择配置文件：

![](./_images/ugreen-tcp-settings.png)

记录下这里的 **token** 和 **隧道 ID**。

token 是您在 SakuraFrp 的身份令牌，请不要交给任何您不信任的人：

![](./_images/ugreen-token-id.png)

### 配置容器

点击 **镜像管理 - 本地镜像**，选择刚刚下载的 `natfrp/frpc` 容器，创建容器：

![](./_images/ugreen-docker-settings-1.png)

前面的设置都无需改动，点击下一步，选择 `环境` 进行环境变量的设置：

- 在环境变量中添加 `LANG`，值为 `en_US.UTF-8`
- 修改 `NATFPR_TOKEN` 为刚刚记录下来的用户 token
- 修改 `NATFRP_TRRGET` 为刚刚记录下来的隧道 id

修改完毕后，点击 **下一步 - 确认** 创建容器：

![](./_images/ugreen-docker-settings-2.png)

回到 docker 主页面，启动容器后，点击 **详细 - 日志**。

![](./_images/ugreen-docker-settings-3.png)

如果一切顺利，在日志里，您可以看到两个链接选项。在链接前面加上 `https://`，即可访问穿透端口了：

> 如使用 `https://idea-leaper-1.natfrp.cloud:23333` 或 `https://114.51.4.191:23333` 来访问穿透的端口。这里的链接仅为示例，应改成日志中显示的内容。

![](./_images/ugreen-docker-settings-4.png)

如图，qBittorrent 穿透完成，成功使用 SakuraFrp 的链接打开 qbittorrent 的 WebUI：

![](./_images/ugreen-docker-settings-5.png)
