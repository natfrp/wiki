# 将 SakuraFrp 启动器添加到杀软白名单中

有时杀毒软件会误杀启动器或 frpc，造成 **隧道启动失败: 拒绝访问** 的错误，或者出现 **无法成功完成操作，因为文件包含病毒或潜在的垃圾软件** 的提示。

如果您信任由我们分发的软件，可以参考本文在杀软中添加对应的白名单以确保软件正常工作。如果您更信任杀软，您可以卸载启动器并使用上游开源 frpc。

::: tip
如果添加白名单后启动器启动器仍提示 **找不到文件** 等错误或无法正常工作，可能是杀软删除 / 隔离了相关文件，可以试着重装一下启动器
:::

:::: tabs

@tab Windows Defender

1. 首先，[点击这里](ms-settings:windowsdefender) 打开 Windows 安全中心

   ![](./_images/av-wd-1.png)

1. 前往 **病毒与威胁防护** 设置，向下滚动找到并点击点击 **管理设置**

   ![](./_images/av-wd-2.png)

1. 向下滚动找到 **排除项**，点击 **添加或删除排除项**

   ![](./_images/av-wd-3.png)

1. 点击 **添加排除项** 按钮，选择 **文件夹** 类型

   ![](./_images/av-wd-4.png)

1. 前往 `C:\Program Files\SakuraFrpLauncher` 目录，点击 **选择文件夹**

   ![](./_images/av-wd-5.png)

1. 确认排除已添加完成，现在应该可以正常使用启动器了

   ![](./_images/av-wd-6.png)

@tab 火绒安全软件

1. 打开火绒主程序，点击右上角的菜单按钮，然后打开 **信任区**

   ![](./_images/av-huorong-1.png)

1. 点击右下角 **添加文件夹** 按钮，选中 `C:\Program Files\SakuraFrpLauncher` 目录，最后点击 **确定**

   ![](./_images/av-huorong-2.png)

1. 确认排除已添加完成，现在应该可以正常使用启动器了

   ![](./_images/av-huorong-3.png)

::::
