<!-- markdownlint-disable MD041 -->

SakuraFrp 提供 frpc 镜像 ([Docker Hub](https://hub.docker.com/r/natfrp/frpc), [GitHub Packages](https://github.com/orgs/natfrp/packages/container/package/frpc)) 以便您借助 Docker 运行 frpc。

### 图形用户界面 {#docker-gui}

本教程只介绍命令行操作，如果您使用以下平台，点击链接可查看对应的 GUI 操作说明：

- [群晖 DSM](/app/synology.md)
- [威联通 QNAP](/app/qnap.md)
- [Unraid](/app/unraid)
- [绿联 NAS](/app/ugreen.md)

### 设置隧道的本地 IP {#docker-create-tunnel}

因为 Docker 的网络模型不同，把隧道的 **本地IP** 设置为 `127.0.0.1` 已经不再奏效，必须修改 **本地IP**。

因为默认的 `bridge` 网桥模式兼容性和安全性更高，**下面的教程默认采用此方案**。

首先运行下面的命令检查 Docker 默认网桥的 **网关IP**：

```bash
ip addr show docker0 |grep inet

# 输出大概长这样：
#     inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
#     inet6 fe80::xx:xxxx:xxxx:xxxx/64 scope link
```

其中 `172.17.0.1` 我们后面要用到的 **网关IP**，在创建隧道时请将其设置为 **本地IP**：

![](../_images/docker-tunnel-new.png)

或者在 [隧道列表](https://www.natfrp.com/tunnel/) 中编辑要启动的隧道，将 **本地IP** 修改为正确的内容：

![](../_images/docker-tunnel-mod.png)

### 创建容器并启动 frpc {#docker-setup-docker}

::: warning
切记不要创建不同名字、相同启动参数的容器，这会造成严重的冲突，隧道将无法正常启动  
可以用 `docker ps` 查看已启动的容器
:::

执行下面的命令就能创建一个容器并启动 frpc：

```bash
docker run \
    -d \
    --restart=on-failure:5 \
    --pull=always \
    --name=sakura1 \
    natfrp/frpc \
    -f <启动参数> --remote_control <远程控制密码>
```

请注意每行（除了最后一行）末尾都有一个 `\`，并且 `\` 后面没有任何东西（包括空格）。

下面是对各行参数的说明：

| 参数 | 说明 |
| --- | --- |
| `-d` | 在后台运行 |
| `--restart=on-failure:5` | 系统重启或隧道崩溃时自动重启 frpc |
| `--pull=always` | 总是检查镜像更新 |
| `--name=sakura1` | 为容器设定一个名字，这里以 `sakura1` 为例 |
| `natfrp/frpc` | 使用 DockerHub 源，也可以换成其他的。<br>- 阿里云香港镜像，适合内地用户：<br>&nbsp;&nbsp;`registry.cn-hongkong.aliyuncs.com/natfrp/frpc`<br>- GitHub Packages：<br>&nbsp;&nbsp;`ghcr.io/natfrp/frpc` |
| `--remote_control <远程控制密码>` | 远程管理功能的相关配置，如果不需要可以不写 |

如果一切顺利，Docker 会为我们下载并启动镜像，您会看到一行 Hash 输出，这就是容器的 ID。

### 获取连接信息 {#docker-how-to-connect}

连接信息在容器的日志中会输出，执行 `docker logs <容器名字|容器ID>` 即可查看。

在上面的示例命令中容器名是 `sakura1`，因此您应该执行 `docker logs sakura1` 进行查看。

### 停止、删除与更新容器 {#docker-stop-delete-update}

停止：`docker stop <容器名字|容器ID>`

删除：`docker rm <容器名字|容器ID>`

更新：停止并删除当前容器，然后使用带有 `--pull=always` 的启动指令重新启动。

### 挂载文件到容器内 {#docker-mount-file}

::: tip
Docker 镜像的工作目录默认为 `/run/frpc/`
:::

如果您需要挂载文件到容器内（例如为自动 HTTPS 配置自定义证书），您可以在启动命令中加入 `-v` 参数，语法为 `-v <容器外文件>:<容器内路径>:ro`。

下面的例子将容器外的 `/root/my.{crt,key}` 挂载到容器内的 `/run/frpc/example.com.{crt,key}`，并且设置为只读：

```bash
docker run \
    -d \ # 后台运行
    --restart=on-failure:5 \
    --pull=always \
    --name=sakura1 \
    -v /root/my.crt:/run/frpc/example.com.crt:ro \
    -v /root/my.key:/run/frpc/example.com.key:ro \
    natfrp/frpc \
    -f <启动参数> --remote_control <远程控制密码>
```
