# OpenWRT 配置 开机启动 服务

?> 查看此教程前请确保您已阅读 [Linux 使用教程](/frpc/usage/linux)

### 前置知识

这里使用 [procd init script](https://openwrt.org/docs/guide-developer/procd-init-scripts) 来实现开机自启动

需要注意的是 Openwrt 自 bb(Barrier Breaker) 后引入了该系统，如果您使用 aa 或更早的上古系统，请使用 sysV 格式写启动脚本

对于存储空间不足的路由器，可能需要（~换一个~）[使用 UPX 压缩二进制文件体积](https://github.com/upx/upx/releases)

### 前置问题排除

对于 Openwrt 用户来说，因为路由器的软件常年永不更新，视固件的年代，可能出现这样的错误：

```
x509: certificate signed by unknown authority
```

此时可以通过更新`ca-certificates`包来修复：

```bash
opkg update
opkg install ca-certificates
```

对于固件年代更为久远的，已经散发出老坛香气的固件，更新`ca-certificates`很可能不能做到或者不可能，此时请跟随下面步骤：

1. 找到一个比较新的 Linux 系统（更新的 openwrt 更佳，或直接拆包新版本的`ca-certificates`包最佳 如[此文件](https://downloads.openwrt.org/releases/19.07.6/packages/arm_cortex-a9/base/ca-certificates_20200601-1_all.ipk)）
1. 使用`tar cf`打包它的`/etc/ssl/certs`目录
1. 迁移到你的路由器同目录中

### 添加步骤如下

1. 新建开机启动脚本：/etc/init.d/frp 脚本代码如下：

```bash
#!/bin/sh /etc/rc.common
# Copyright (C) 2008 OpenWrt.org

START=99
USE_PROCD=1
PROG="/usr/local/bin/frpc_linux_mipsle" #根据你自己的frp客户端填写

start_service() {
    rm -f /frpc_overload*.log* # remove old logt/logp files
    procd_open_instance
    procd_set_param command "$PROG"
    procd_append_param command -f <访问密钥>:隧道ID,隧道ID...
    procd_set_param stdout 1 # forward stdout of the command to logd
    procd_set_param stderr 1 # same for stder
    procd_set_param respawn
    procd_close_instance
}
```

2. 设置运行权限，打开开机自启动：

```bash
chmod +x /etc/init.d/frp && /etc/init.d/frp enable
```

3. 此时系统每次开机就会自动启动服务了，当然你也可以手动启动服务

```bash
/etc/init.d/frp start
```
