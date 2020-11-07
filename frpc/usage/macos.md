# macOS 系统使用 frpc

## 创建 root 账户
?> 如果您拥有 `root` 账户并记得密码，可以跳过这一步

登录管理面板，在侧边栏点击 “软件下载” :

![](../../_images/download.png)

翻到页面底部，找到 macOS 并复制右边蓝色的下载地址

![](_images/macos-0.png)

按下键盘上的 `command+空格` 调出聚焦搜索并键入 `终端`  
双击终端图表以打开终端

![](_images/macos-1.png)
![](_images/macos-2.png)

使用下面的命令创建 `root` 用户

```bash
sudo passwd root
```

![](_images/macos-3.png)

输入你当前账户的密码并按下回车

![](_images/macos-4.png)

在 `New password:` 处，输入你想要的 `root` 账户密码并回车  
在 `Retype new password:` 处，重复你的 `root` 账户密码并回车

?> 你会发现终端并没有显示，不用担心，“摸黑”输入密码后按下回车即可，退格按键同样可用
!> 您应像保管任何重要密码一样保管您的 `root` 账户密码

![](_images/macos-5.png)

如果您看到和图里一样的输出，说明 `root` 账户已成功创建

## 安装 frpc

打开终端，输入 `su` 并回车  
输入您的 `root` 账户密码并回车，如图所示即成功进入 `root` 账户

![](_images/macos-6.png)

使用下面的命令进入 `/usr/local/bin` 文件夹并下载文件

```bash
mkdir -p -m 755 /usr/local/bin && cd /usr/local/bin
curl -Lo frpc https://getfrp.sh/d/frpc_darwin_amd64
```

![](_images/macos-7.png)

使用下面的命令设置权限并检查输出

```bash
chmod 755 frpc
ls -ls frpc
```

![](_images/macos-8.png)

如果您看到和图里一样的输出，说明 frpc 已完成安装并准备就绪  
您可以执行下面的命令再次确认以及查看 frpc 版本号

```bash
frpc -v
```

## 使用 frpc

请查看 [用户手册](/frpc/manual#普通用户) 中的 **普通用户** 一节学习 frpc 的基本使用方法

通过本文档中介绍的方法安装后，您应该可以在任何目录直接输入 `frpc <参数>` 运行 frpc ，**不需要** 输入完整路径
