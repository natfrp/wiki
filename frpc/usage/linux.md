# Linux 系统使用 frpc

如果您符合以下几种情况：
+ 对自己的技术没有信心
+ 不知道该下载什么版本
+ 不会写 systemd 服务

请使用 **一键安装脚本（由 [@renbaoshuo](https://baoshuo.ren) 提供）**：`sudo bash <(curl -Ls getfrp.sh)` （需要 root 权限）

## 注意

本文档中给出的命令大多需要 `root` 权限才能运行，请确保您现在已经处于有 `root` 权限的环境下。

如果您现在没有切换到 `root` 账户下，那么请使用 `su` 或者 `sudo -s` 命令来进行切换。

## 确认系统架构

下载 frpc 前，请先确认您的 Linux 系统的架构. 执行下面的命令，根据输出结果就可以确定系统架构

```bash
uname -m
```

| 架构 | 输出结果 |
| --- | --- |
| i386 | `i386`, `i686` |
| amd64 | `x86_64` |
| arm | `arm`, `armv7l` |
| arm64 | `aarch64`, `armv8l` |
| mips | `mips` |
| mips64 | `mips64` |
| 不支持 | `alpha`, `arc`, `blackfin`, `c6x`, `cris`, `frv`, `h8300`, `hexagon`, `ia64`, `m32r`, `m68k`, `metag`, `microblaze`, `mn10300`, `nios2`, `openrisc`, `parisc`, `parisc64`, `ppc`, `ppcle`, `ppc64`, `ppc64le`, `s390`, `s390x`, `score`, `sh`, `sh64`, `sparc`, `sparc64`, `tile`, `unicore32`, `xtensa` |

如果您看到了不在上面列表中的输出，请访问 [百度](https://www.baidu.com/) 或 [谷歌](https://www.google.com/) 进行搜索

### 安装 frpc

登录管理面板，在侧边栏点击 “软件下载” :

![](../../_images/download.png)

?> 本教程中使用的演示内核为 x86_64 架构，对应文件名为 `frpc_linux_amd64`  
实际操作时需要根据您的架构文件名会有所不同，请自行修改命令中的文件名。

找到 frpc 的各种下载地址和您的架构标志，复制右边蓝色的下载地址：

![](_images/linux-1.png)

使用下面的命令进入 `/usr/local/bin` 目录并下载文件：

```bash
cd /usr/local/bin
wget -O frpc ${downloadUrl} # ${downloadUrl} 代表您刚才复制的下载地址
```

![](_images/linux-2.png)

然后使用下面的命令设置正确的权限并检查输出

```bash
sudo chmod 755 frpc
sudo ls -ls frpc
```

![](_images/linux-3.png)

如果您看到和图里一样的输出，frpc 就安装完成并可以正常使用了。您可以执行下面的命令来再次确认

```bash
frpc -v
```

### 使用 frpc

请查看 [用户手册](/frpc/manual#普通用户) 中的 **普通用户** 一节学习 frpc 的基本使用方法

通过本文档中介绍的方法安装后，您应该可以在任何目录直接输入 `frpc <参数>` 运行 frpc ，**不需要** 输入完整路径

### 简易后台运行

!> 不推荐采用 `&` 将 frpc 放到后台运行，建议参考下面的 **配置开机自启** 一节将 frpc 注册为系统服务

因为 frpc 总是在读取 stdin，所以如果要使用 `&` 的方式将 frpc 临时放到后台运行，需要提供一个 stdin 让它读取: `echo | <cmd> &`

举个例子:
```bash
echo | frpc -f wdnmdtoken666666:12345 &
```

### 配置开机自启

如果您想让 frpc 在开机时自启或在后台运行，就需要将 frpc 注册为系统服务。

!> 由于文档维护者不了解 Upstart 和 SysV-Init 的传参模式，本文档暂不提供这两种初始化系统的配置指南  
如果您熟悉这些初始化系统并且愿意为本文档作出贡献，欢迎开启 PR 完善相关文档（[GitHub 仓库](https://github.com/natfrp/wiki)）

首先，您要搞清楚您的 Linux 系统使用的 ***初始化系统*** 是什么，常见的初始化系统：

- Systemd
- Upstart
- SysV-Init

执行下面的命令然后查看输出，找到您的初始化系统：

```bash
if [[ `/sbin/init --version` =~ upstart ]]; then echo Upstart; elif [[ `systemctl` =~ -\.mount ]]; then echo Systemd; elif [[ -f /etc/init.d/cron && ! -h /etc/init.d/cron ]]; then echo SysV-Init; else echo Unknown; fi
```

![](_images/linux-4.png)

然后，请参考下面的教程配置系统服务:

- [Systemd 配置指南](/frpc/service/systemd)
