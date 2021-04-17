# OpenWRT 配置 开机启动 服务

?> 查看此文档前请确保您已阅读 [Linux 使用](/frpc/usage/linux)

### 相关知识

建议在 OpenWRT 中使用 [procd init script](https://openwrt.org/docs/guide-developer/procd-init-scripts) 来实现开机自启动

需要注意的是 Openwrt 自 bb(Barrier Breaker) 后引入了该系统，如果您使用 aa 或更早的上古系统，您可能需要使用 sysV 格式写启动脚本

对于存储空间不足的路由器，可能需要（~换一个~）[使用 UPX 压缩二进制文件体积](https://github.com/upx/upx/releases)

### 问题排除

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

### LuCI GUI 操作 :id=luci

目前我们暂时不提供 LuCI app 支持, 但是我们为某著名的小白化 lede 固件的 luci-app 提供了[更新](https://github.com/coolsnowwolf/lede/pull/6496), 以确保它可以正常使用