# 威联通 (QNAP) NAS 穿透指南

这篇指南只提供 Docker 部署方案。如果您有其他想法，欢迎点击页面底部的编辑按钮帮助我们完善这篇文档。

## 使用准备 {#preparation}

1. 打开控制台，勾选 `使用安全连接(HTTPS)`，并记下下面的 **端口号** 作为 **本地端口**：

   ![](./_images/qnap-settings.png)

1. 在 `App Center` 中安装 `Container Station` 以使用 Docker：

   ![](./_images/qnap-install-docker.png)

1. 在 `Container Station` 如下图读出 **IP地址 / 网络** 的内容作为 **本地 IP**：

   ![](./_images/qnap-gateway-ip.png)

## 创建隧道 {#create-tunnel}

1. 前往 Sakura Frp 管理面板，使用上一步中记下的信息创建隧道：

   ![](./_images/qnap-new-tunnel.png)

1. 在隧道列表中点击刚才创建的隧道右边三个点，选择 **配置文件** 并在弹出的对话框中复制隧道的 **启动参数**：

   ![](./_images/dsm-launch-args.png)

## 启动隧道 {#start-tunnel}

1. 在 `Container Station` 中找到并下载 `natfrp/frpc` 的 `latest` 标签：

   ![](./_images/qnap-docker-pull.png)

   ![](./_images/qnap-docker-tag-latest.png)

1. 然后在 **命令** 栏中粘贴刚才复制的启动参数，如果有需要可以在后面加上其他自定义选项：

   ![](./_images/qnap-docker-setup.png)

   最后点创建就可以了。

## 获取连接信息 {#connection-method}

1. 打开 Docker Container 的详情信息就能看到连接信息了，报错也可以在这里看到：

   ![](./_images/qnap-docker-info.png)

1. 在访问地址前面加上 `https://`，到浏览器试一下：

   ![](./_images/qnap-docker-try.png)

## 更新 frpc {#update}

::: danger
请务必在有备用连接手段时升级，否则可能造成失联
:::

QNAP 的 Container Station 并不像它在 DSM 的兄弟那样升级便捷。

您需要删除掉正在运行的 Container（容器），然后在 `镜像文件` 菜单中删除已有的 `natfrp/frpc`，最后跟随 [启动隧道](#start-tunnel) 重来一遍。
