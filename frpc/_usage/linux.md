本文档中给出的命令大多需要 `root` 权限才能运行，请确保您现在已经处于有 `root` 权限的环境下。

如果您现在没有切换到 `root` 账户下，那么请使用 `su` 或者 `sudo -s` 命令来进行切换。

### 确认处理器架构 {#linux-check-arch}

下载 frpc 前，请先确认您的处理器架构。执行下面的命令，根据输出结果查表：

```bash
uname -m
```

| 输出 | 架构 |
| --- | --- |
| `i386`, `i686` | i386 |
| `x86_64` | amd64 |
| `arm`, `armel` | arm_garbage |
| `armv7l`, `armhf` | _armv7*_ |
| `aarch64`, `armv8l` | arm64 |
| `mips` | _mips*_ |
| `mips64` | _mips64*_ |

- 如果您使用 `armv7` 版时出现 `Illegal instruction` 报错，请下载 `arm_garbage` 版本重试
- mips/mips64 架构还需要确认字节序，请参考 [下一节](#linux-check-endian) 进行操作，其他架构无需执行此操作
- 如果您使用 Termux+PRoot 运行其他发行版，或使用某 "开源手机 AI 开发框架"，可能会碰到 `Segmentation fault` 报错。这是一个已知的 UPX 与 PRoot 及部分 Linux 内核协作的 Bug，请使用 `upx -d` 解压程序使用，或在下载地址后加 `_noupx` 下载已解压的版本

### 确认处理器字节序 (mips/mips64) {#linux-check-endian}

```bash
# 一般来说只需要使用这条命令:
echo -n I | hexdump -o | awk '{print substr($2,6,1); exit}'

# 如果上面的命令报错，请尝试这条:
echo -n I | od -to2 | awk '{print substr($2,6,1); exit}'
```

| 输出 | 架构 |
| --- | --- |
| `0` | mips / mips64 |
| `1` | mipsle / mips64le |

### 安装 frpc {#linux-install-frpc}

1. 登录管理面板，转到 “软件下载” :

   ![](../../_images/download.png)

2. 选择 Linux 系统，然后选择正确的架构，点击按钮复制下载链接：

   ![](_images/linux-1.png)

3. 使用下面的命令进入 `/usr/local/bin` 目录并下载文件：

   ```bash
   cd /usr/local/bin

   # 一般来说只需要使用这条命令:
   wget -O frpc <下载地址>

   # 如果上面的命令报错，请尝试这条:
   curl -Lo frpc <下载地址>

   # Linux frpc 通常已经过 UPX 压缩，如需下载未压缩的版本请在下载地址尾部加上 _noupx
   ```

   ![](_images/linux-2.png)

4. 然后设置权限并校验文件是否有损坏：

   ```bash
   chmod 755 frpc
   ls -ls frpc
   md5sum frpc
   ```

   ![](_images/linux-3.png)

5. 此时 frpc 就安装完成并可以正常使用了。您可以用此命令查看 frpc 版本号：

   ```bash
   frpc -v
   ```

### 使用 frpc {#linux-usage}

请查看 [启动隧道](#running-frpc) 一节了解如何启动 frpc 并连接到您的隧道。

通过本文档中介绍的方法安装后，您应该可以在任何目录直接输入 `frpc <参数>` 运行 frpc ，**不需要** 输入完整路径

### 简易后台运行 {#linux-simple-background}

!> 不推荐采用 `&` 将 frpc 放到后台运行，建议参考下面的 **配置开机自启** 一节将 frpc 注册为系统服务

如果要临时将 frpc 放到后台运行，可以在运行命令的后面加 `&`，例如：

```bash
frpc -f wdnmdtoken666666:12345 &
```

### 配置开机自启 {#linux-autostart}

?> 本文档暂未覆盖到 Upstart 和 SysV-Init，如果您熟悉这些初始化系统，[欢迎提交 PR](https://github.com/natfrp/wiki/pulls)

本文档提供下列初始化系统的自启配置指南：

- [Systemd](/frpc/service/systemd)
- ~Upstart~
- ~SysV~

以及下列发行版的服务配置指南：

- [OpenWrt](/frpc/service/openwrt)

如果您不清楚您的 Linux 系统使用的 **初始化系统** 是什么，请执行下面的命令然后查看输出：

```bash
if [[ `/sbin/init --version` =~ upstart ]]; then echo Upstart; elif [[ `systemctl` =~ -\.mount ]]; then echo Systemd; elif [[ -f /etc/init.d/cron && ! -h /etc/init.d/cron ]]; then echo SysV-Init; else echo Unknown; fi
```

![](_images/linux-4.png)
