# 使用 SakuraFrp AuthPanel GuestTool 制作专用的访问认证工具

如果您已按照 [最佳实践/安全](/bestpractice/security) 中 frpc 访问认证 一节配置的访问认证面板，想必您会对于经常需要打开浏览器进行验证感到厌烦。

除了参考上述文档中给出的示例制作 bash 脚本外，您可以使用 SakuraFrp AuthPanel GuestTool 制作内嵌地址和密码的访问认证工具，分发给其他访客时也会更加方便。

?> 下面示例以 Windows 系统为例，其它系统大同小异，不再赘述

## 下载 SakuraFrp AuthPanel GuestTool

请于 [GitHub Release](https://github.com/natfrp/auth-guest/releases/latest) 按照您的系统和架构下载程序。

## 制作访问认证工具

1. 打开一个终端窗口

2. 在终端窗口中执行您下载到的程序，根据您的实际情况修改格式和对应参数：`./auth-guest -u <访问认证面板的地址，如https://cn-sb-vv-1.natfrp.cloud:12345> -p <访问认证密码>`

3. 您会在同目录下看到文件名为 `authpass_generated.exe` 的程序，只需执行该程序即会自动进行访问认证，无需打开浏览器

![](_images/auth-guest-gened.jpg)

4. 您的访客在访问前只需执行生成的此程序即可通过访问认证

![](_images/auth-guest-run.jpg)

## 其他参数

SakuraFrp AuthPanel GuestTool 提供的其他可自定义项，请通过 `-h` 参数查看。
