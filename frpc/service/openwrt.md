# OpenWRT 配置 开机启动 服务

?> 查看此教程前请确保您已阅读 [Linux 使用教程](/frpc/usage/linux)

### 前置知识

这里使用 [procd init script](https://openwrt.org/docs/guide-developer/procd-init-scripts) 来实现开机自启动


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


