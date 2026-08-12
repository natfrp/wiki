# SakuraFrp 启动器更新指南

此指南旨在帮助您更新 SakuraFrp 启动器到最新版本。

请根据系统和部署方式，进行选择：

::::: tabs

@tab Windows {#windows}

### 使用启动器内更新（推荐）

找到 `设置` - `核心服务` - 打开 `自动下载更新` 后，点击 `立即检查`。

### 手动安装

到 [软件下载页](https://www.natfrp.com/tunnel/download) 下载安装包更新即可。

@tab Linux {#linux}

仅包含常规 Linux 系统，如果您使用 Openwrt，请查看 Openwrt 选项卡。

### 使用启动器内更新（推荐）

::: tip Docker 部署无法使用启动器内自更新
为确保 Docker 部署的原子性和可靠性，Docker 部署的启动器无法进行应用内更新，请参考下面手动更新节中符合的情况进行操作。
:::

找到 `设置` - `核心服务` - 打开 `自动下载更新` 后，点击 `立即检查`。

### 手动更新 {#linux-manual}

#### 使用一键脚本安装的情况

再次执行一键脚本重新安装即可：

```bash
sudo bash -c ". <(curl -sSL https://doc.natfrp.com/launcher.sh)"

# 或者使用 wget, 脚本会自动通过包管理器安装 curl
sudo bash -c ". <(wget -O- https://doc.natfrp.com/launcher.sh)"

# 如果需要绕过 Docker 检测强制安装到系统中
sudo bash -c ". <(curl -sSL https://doc.natfrp.com/launcher.sh) direct"
```

#### 手动使用 Docker 部署的情况

您可以手动重建镜像来更新启动器。

对于未使用 `-v` 参数挂载配置文件的情况，更新后您将需要手动重新配置。  
对于使用了 `-v` 参数挂载配置文件的，请在重建时正确配置参数。

您也可以使用 Watchtower 来管理更新，其可以帮助您自动检查并更新，具体参考 [此节](#docker-watchtower)。

#### 使用 Docker Compose 管理部署的情况

请确认您的 `docker-compose.yml` 文件中，`image` 字段为最新版本的镜像地址，然后执行：

```bash
docker compose pull
docker compose up -d
```

#### 使用 Watchtower 管理更新的情况 {#docker-watchtower}

您可能使用 Watchtower 来管理 Docker 容器的更新，请参考其 [官方文档](https://containrrr.dev/watchtower/) 来使用。

如果只想使其更新 SakuraFrp 启动器，您可以使用：

```bash
docker run -d \
 --name watchtower \
 --restart=unless-stopped \
 -v /var/run/docker.sock:/var/run/docker.sock \
 containrrr/watchtower \
 --interval 86400 --cleanup <被更新的容器名称，如natfrp-service>
```

来每天自动检查更新并自动更新 SakuraFrp 启动器。

#### 使用 Portainer 部署的情况

请选中容器，使用 `重建` (Rebuild)功能，选择 `拉取最新镜像` (Re-Pull image) 后，点击 `重建并启动` 即可。

#### 使用其他 Docker GUI 部署的情况

请参考对应 GUI 系统教程中的更新部分：

- [Synology](/app/synology.md)
- [QNAP](/app/qnap.md)
- [unRAID](/app/unraid.md)
- [fnOS](/app/fnos.md)
- [UGOS Pro](/app/ugos-pro.md)

#### 使用手动部署的情况

请参照手动部署方法，下载最新的 SakuraFrp 启动器压缩包，解压后覆盖原有文件即可。

@tab Openwrt {#openwrt}

请参考 [Openwrt 部署指南](/launcher/usage.html#openwrt)，重新下载软件包并覆盖安装即可。

@tab macOS {#macos}

请到 [软件下载页](https://www.natfrp.com/tunnel/download) 下载 dmg 映像包，  
在状态栏中找到 SakuraFrp 启动器图标，右键点击并选择 `彻底退出`，然后使用下载的映像包覆盖即可。

对于使用 brew 安装管理的，请使用 `brew upgrade --cask sakura` 来更新。
