# OpenWrt 配置 开机启动 服务

::: tip
查看此教程前请确保您已阅读 [frpc 基本使用指南](/frpc/usage.md#linux) 中的 **Linux 安装** 部分
:::

### 安装 {#openwrt-install}

SakuraFrp 分发的 frpc 均已经过 UPX 压缩 (除了 mips64 架构)，如果您的路由器剩余存储空间不足以存放 frpc，~可能需要换一个路由器~ 请自行寻找解决方案（例如插一个 U 盘）。

首先您需要下载 SakuraFrp 版本的 frpc 至您的路由器，并将其放置在 /sbin 目录下

将其中的 `<下载链接>` 根据您路由器的架构替换为 [软件下载页](https://www.natfrp.com/tunnel/download) 中具体的链接，具体如何选择请参考 Linux 使用文档

```bash
wget <下载链接> -O /sbin/natfrpc && \
chmod a+wx /sbin/natfrpc # 修改可执行权限和可写权限(用于更新)
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
    ####### 第一条隧道 #######
    procd_open_instance SakuraFrp
    procd_set_param command /sbin/natfrpc

    procd_append_param command -f <您的隧道启动参数> --update # 请修改此行为您的隧道启动参数，同时可添加远程控制隧道启停等配置
 
    procd_set_param env LANG=zh_CN.UTF-8 # 用于显示中文日志，删除即显示英文日志
    procd_set_param limits nofile="unlimited"
    procd_set_param respawn 300 5 10
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_add_jail natfrp log
    procd_close_instance

    ####### 第二条隧道 #######
    procd_open_instance SakuraFrp2 # 注意这里的名字是 SakuraFrp2，后面有个数字编号
    procd_set_param command /sbin/natfrpc

    procd_append_param command -f <另外一个启动参数> --update # 请修改此行为您的隧道启动参数，同时可添加远程控制隧道启停等配置
 
    procd_set_param env LANG=zh_CN.UTF-8 # 用于显示中文日志，删除即显示英文日志
    procd_set_param limits nofile="unlimited"
    procd_set_param respawn 300 5 10
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_add_jail natfrp log
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

### 问题排除 {#openwrt-troubleshoot}

#### jail 错误 {#jail-error}

:::tip
理论上，这个问题在 OpenWrt v23 版本已经修复，但并非所有人都会升级
:::

frpc 使用的是静态编译，而 jail 依旧会报动态 section 缺失错误，像这样：

```
jail: failed to load the .dynamic section from /sbin/natfrpc
```

此时只需要通过禁用 jail 即可解决。将 `/etc/init.d/natfrpc` 下相应代码删除或注释即可：

```bash
...
procd_set_param stderr 1
#procd_add_jail natfrp log
procd_close_instance
...
```
::: warning
所有隧道的相应字段都要删除或注释
:::

#### 证书错误 {#cert-error}

对于 OpenWrt 用户来说，因为路由器的软件常年永不更新，视固件的年代，可能出现这样的错误：

```
x509: certificate signed by unknown authority
```

此时可以通过更新`ca-certificates`包来修复：

```bash
opkg update
opkg install ca-certificates
```

对于年代更为久远的，已经散发出老坛香气的固件，在线更新 `ca-certificates` 很可能不能做到或者不可能，此时请跟随下面步骤：

1. 找到一个其他版本的 OpenWrt 源中的 `ca-certificates`包，如[此文件](https://downloads.openwrt.org/releases/21.02.1/packages/aarch64_generic/base/ca-certificates_20210119-1_all.ipk)
1. 下载到路由器中，如果您的网络仍正常工作，可以使用 `wget https://downloads.openwrt.org/releases/21.02.1/packages/aarch64_generic/base/ca-certificates_20210119-1_all.ipk -O /tmp/ca-certificates.ipk`
1. 如果上一步执行出错，请手动下载后将文件上传到 `/tmp/ca-certificates.ipk`
1. 执行 `opkg install /tmp/ca-certificates.ipk` 安装
