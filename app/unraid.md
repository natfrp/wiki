# 以 Unraid 为中心的家庭服务穿透指南

Unraid 在很多社区的热度较高，而其配置较为简单，只需使用 CA(Community Applications) 搜索 Dockerhub 的镜像然后简单地配置即可。

但是因为仍有一定的门槛，且 Unraid 未官方提供直接从 Docker 镜像创建的功能，取而代之的是被称为 模板(template) 的机制，所以我们提供了一个官方的 [模板仓库](https://github.com/natfrp/unraid-docker-templates) 帮助各位简化部署。

本文旨在提供易于理解的教程，考虑到 Unraid 服务器通常本身并不提供主要服务，而是为其他内网服务做支撑，本文中的 Docker 网络模型选择了 `host` 而非 `bridge`。

## 使用前准备

### 安全警告

根据 [Unraid 官方的配置指南](https://wiki.unraid.net/index.php/Configuration_Tutorial#Security)，Unraid 在任何情况下都不应直接连接到互联网。

为了表达我们最大程度的不建议，我们将映射 Unraid 自身的教程单独放在了这篇文章的最后，并进行了折叠。

### 添加 Templates

Unraid 在 6.10.0-rc1 之后的版本中弃用了自定义 Templates Repository 的功能，我们需要将仓库文件下载到 Unraid U盘的特定路径。

我们提供使用 Unraid 终端直接下载文件的在线部署和手动复制文件的离线部署方法。

#### 在线部署（推荐）

点击 Unraid webGui 右上角的 Terminal 按钮，在打开的页面中复制粘贴下面的命令执行：

```bash
curl -o /boot/config/plugins/dockerMan/templates-user/natfrpc.xml https://nyat-static.globalslb.net/natfrp/misc/natfrpc.xml
```

![](_images/unraid-terminal-btn.png)

此时模板文件已经被下载到指定位置，可以使用了。

如果在后面创建容器时发现不可用，请检查 `/boot/config/plugins/dockerMan/templates-user/natfrpc.xml` 文件的内容。

#### 离线部署 :id=tpl-offline

?> 通常情况下离线部署并无必要，如果您发现自己对 Linux 命令行操作过敏，请考虑离线部署。

要离线部署，请先将 Unraid 服务器关机，将启动盘拔出插到 PC 上。

手动下载 [模板文件](https://nyat-static.globalslb.net/natfrp/misc/natfrpc.xml)，将此文件放置到 `X:\config\plugins\dockerMan\templates-user` （X 为 Unraid 启动盘盘符）。

![](_images/unraid-usbstick-tpl.png)

## 穿透内网其他服务 :id=others

### 创建隧道

使用内网访问时的端口和 ip 在 [隧道列表](https://www.natfrp.com/tunnel/) 页面使用“新建隧道”即可，因为我们使用 `host` 网络，此处限制较少。

对于 HTTP 访问的限制 和 部分机房合规要求访问认证 仍存在，请在创建隧道时注意。

### 创建容器 :id=start-container

 在 Docker 页中点击 `Add Container` ，并选择 `natfrpc` 模板后配置即可，其中的 隧道 ID 可以在 [隧道列表](https://www.natfrp.com/tunnel/) 页面获得。

 共有高达两个需配置的输入框，请在确保均已被配置后点击 Apply 按钮创建容器实例并启动。

 ![](_images/unraid-add-container.png)

 添加完成的界面如下图所示，如果您的英语水平无法阅读，请注意关键词 `finished successfully`，即为成功。请注意此图中会存在明文暴露访问密钥，即红框处，截图分享时请注意打码。

 ![](_images/unraid-add-done.png)

 点击 Done 后页面将跳转回 Docker 页的首页，此时即可看到新创建的实例：

 ![](_images/unraid-running-container.png)

#### 查看日志

 此时点击已经完成创建的容器图标（图中为问号）即可进行管理，点击此菜单中的 Logs 项即可在弹出的新窗口中查看运行日志。在向他人提问时请务必截图并提供此窗口内容。

 ![](_images/unraid-log-dropdown.png)

 ![](_images/unraid-log-window.png)

<details id='unraid-self'>
<summary>在点击展开前，请确认您完全理解自己正在做的行为，并了解其中的安全风险</summary>

## 穿透 Unraid web 控制台

!> 请在阅读前完全理解自己正在做的行为，并了解其中的安全风险

!> 下面所有的内容均为文档作者半梦半醒的呓语，操作会导致巨大的安全风险，您**不应**照做

### 设置隧道

因为我们的模板使用 `host` 网络模型，我们只需在创建隧道时将 本地 IP 设置为 `127.0.0.1`，本地端口 设置为 `80` 即可。

但请注意，不要选择一个不支持 HTTPS 的节点使用。

Unraid 不提供 HTTPS 控制台，因为我们的大部分节点均不允许使用 HTTP 访问，请将 自动 HTTPS 配置项设为 自动 或您使用的域名。

为了给 Unraid 提供保护，您**不得**将访问密码留空，且**必须**在此处填写一个足够强的长密码。

### 创建容器

参考上面的 [运行隧道](#start-container) 即可。

### 访问隧道

在运行隧道后，我们就可以在日志中得到访问地址了，此处以 `114.5.1.4:1919` 为例。

因为我们打开了访问认证（即设置了访问密码），您需要首先打开 `https://114.5.1.4:1919` 并在此页面进行登录。

在登录后，使用 `https://114.5.1.4:1919/Main` 即可访问您的控制台。

?> 因为 Unraid 控制台的自动跳转功能，使用 `https://114.5.1.4:1919/` 会被跳转到 `http://114.5.1.4:1919/Main` （没有 s）从而无法访问，所以请务必访问 `https://114.5.1.4:1919/Main`

</details>