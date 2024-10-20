# OpenWrt 配置 开机启动 服务

::: tip
我们目前提供 Openwrt IPK 包及 LuCI 插件，我们推荐您先尝试 [使用启动器](/launcher/usage.md#openwrt)  
如果发现系统配置不足后可尝试本教程的方案

查看此教程前请确保您已阅读 [frpc 基本使用指南](/frpc/usage.md#linux) 中的 **Linux 安装** 部分
:::

### 安装 {#openwrt-install}

SakuraFrp 分发的 frpc 均已经过 UPX 压缩 (除了 mips64 架构)，如果您的路由器剩余存储空间仍不足以存放经过压缩后的程序文件，~可能需要换一个路由器~ 请自行寻找解决方案（例如插一个 U 盘）。

首先您需要下载 SakuraFrp 版本的 frpc 至您的路由器，并将其放置在 /sbin 目录下

将其中的 `<下载链接>` 根据您路由器的架构替换为 [软件下载页](https://www.natfrp.com/tunnel/download) 中具体的链接，具体如何选择请参考 Linux 使用文档

```bash
wget <下载链接> -O /sbin/natfrpc && \
chmod a+wx /sbin/natfrpc
```

如果您的固件太过古老，上面指令可能因为无法正确验证服务端证书而出错，您可以尝试关闭检查：

```bash
wget <下载链接> -O /sbin/natfrpc --no-check-certificate && \
chmod a+wx /sbin/natfrpc
```

此时您就可以使用 `natfrpc` 命令来执行 frpc 了，但是还需下面的操作实现自启动

### 开机自启动 {#openwrt-autostart}

我们这里以 [Procd Init Script](https://openwrt.org/docs/guide-developer/procd-init-scripts) 实现自启动

需要注意的是 OpenWrt 自 bb(Barrier Breaker) 后引入了该系统，如果您使用 aa 或更早的上古系统，您可能需要使用 sysV 格式写启动脚本

创建一个名为 `/etc/init.d/natfrpc` 的文件，内容如下（请注意修改下面的启动参数）：

```bash
#!/bin/sh /etc/rc.common

USE_PROCD=1
START=90

start_service() {
    procd_open_instance SakuraFrp
    procd_set_param command /sbin/natfrpc

    # 替换下面的隧道启动参数，在隧道列表中选中需要的隧道，选择 批量操作->配置文件 即可在弹出的框中复制启动参数
    # 形如 -f xxx:xxx,xxx，请注意不要有重复的 -f
    procd_append_param command -f <您的隧道启动参数> 
 
    procd_set_param env LANG=zh_CN.UTF-8 # 用于显示中文日志，删除即显示英文日志
    procd_set_param limits nofile="unlimited"
    procd_set_param respawn 300 5 10
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
```

然后执行：

```bash
sed -i 's/\r//' /etc/init.d/natfrpc # 如果您在 Windows 创建了上述文件并上传，执行此命令去除 \r 换行符
chmod +x /etc/init.d/natfrpc # 为其赋予可执行权限
/etc/init.d/natfrpc start # 启动服务
/etc/init.d/natfrpc enable # 如果需要，启用开机自启动
```

### 网页控制台 {#openwrt-web-panel}

此时您已经可以在 OpenWrt 的 Web 面板，即 LuCI 中查看 frpc 的状态

如在 `状态 - 系统日志` 可以看到 frpc 的运行日志和连接信息（新日志内容在底部，请下滑）：

![](./_images/openwrt-syslog.png)

在 `系统 - 启动项` 中可以看到名为 `natfrpc` 的项目，并控制开机自启情况，启动/停止/重启等操作
