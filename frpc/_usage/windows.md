我们不推荐在 Windows 系统上直接使用 frpc，除非您有特殊需求，否则请 [使用启动器](/launcher/usage)。

### 确认系统架构

1. 下载 frpc 前，请先确认您的处理器架构。按 `Win+R` 打开运行窗口

   ![](_images/windows-1.png)

2. 输入 `msinfo32` 然后点确定，在 “系统类型” 里查看 **系统类型** 一节

   ![](_images/windows-2.png)

3. 根据下表确认您的系统架构

   | 架构 | 系统类型 |
   | --- | --- |
   | i386 | `x86` |
   | amd64 | `x64` |
   | ARM64 | `ARM64` |

### 下载 frpc

1. 登录管理面板，转到 “软件下载” :

   ![](../../_images/download.png)

3. 选择 Windows 系统，然后根据您的系统架构选择一个合适的版本下载

   ![](_images/windows-0.png)

### 使用 frpc

请查看 [frpc 用户手册](/frpc/manual)  学习 frpc 的基本使用方法

### 操作示例

?> 下面的所有示例均以启动手册教程中的第一条隧道为例

1. 首先找到您之前下载的 frpc，在本示例中，文件名为 `frpc_windows_amd64.exe`

2. 按住 **Shift** 然后 **右键** 点击空白区域，选择 `在此处打开 Powershell 窗口`

   ![](_images/windows-3.png)

3. 然后按下图中的说明输入您下载的 frpc 文件名和启动参数，按回车启动 frpc

   ![](_images/windows-4.png)
