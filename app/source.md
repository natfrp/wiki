# 起源引擎(CSGO,求生之路2)等游戏服务器穿透指南  How To Use SakuraFrp On Your Source Dedicated Server
> 阅读本教程后，您将学会使用SakuraFrp来简单将您的服务器穿透供其他玩家游玩\n
> 如需进行更高级的穿透，或对穿透有任何疑问，请访问本页面编写者[一纸荒年Trace](https://wtrace3zh.com)的博客中寻找答案\n
> 本教程主要针对正版（通过Steam认证）的服务器\n
\n\n
欢迎，在我们开始进行穿透之前，您需要先了解一些关于起源引擎服务器基础知识，这些知识将在您遇到困难时提供有利的帮助信息。
\n\n
## 有些事情你需要知道
### 哪些游戏属于起源引擎游戏？这篇文章适用于我搭建的游戏服务器吗？
!> 反恐精英1.6，Sven CO-OP，半条命等属于GoldSource金源引擎游戏，不适用于本教程！
起源引擎游戏服务器指使用起源引擎制作的支持网络对战的游戏，比较知名的游戏有反恐精英：全球攻势（CSGO）,求生之路1/2（Left 4 Dead 1/2），军团要塞，反恐精英：起源，盖瑞模组（Garry's Mod）等。\n
\n\n
这些游戏（或模组）都遵循Valve制定的起源专用服务器（Source Dedicated Server）规则，注意！不是所有由起源引擎开发的网络对战游戏都遵循Source Dedicated Server规则（如原罪前传）\n
如何判断您准备穿透的是否遵循Source Dedicated Server规则？很简单！如果您的游戏服务器启动程序为srcds_run（Windows下为srcds.exe）则表明遵循该规则。
### 命令行与server配置文件
遵循Source Dedicated Server规则的游戏服务器在启动时一般都会先加载cfg文件夹下的server.cfg文件，该文件定义了服务器必要的基本参数（如服务器名称，玩家人数等），这个文件本质上是一些游戏命令的合集，即在服务器初始化之前执行这些命令。如何编写server.cfg不在本文的讨论范围内，且根据游戏不同配置文件的编写内容也不同。但起源引擎有一些命令适用于所有起源引擎制作的游戏——特别是网络通信方面的！\n
\n\n
srcds支持启动时增加命令，命令又分为服务器内命令与启动命令，两者的主要区别就是以“+”或“-”号开头\n
\n\n
在Linux下添加启动命令，您只需要将命令添加到启动代码后面即可！\n
```bash
./srcds_run -game xxxx -port xxx +maxplayers 114514 +map 1919810
```
在Windows下添加启动命令，您需要先将srcds.exe添加快捷方式，随后修改“目标”一栏中修改\n
```powershell
./srcds.exe -game sodayo -port xxx +maxplayers 114514 +map 1919810
```
### 端口
!> Source Dedicated Server要求启动时指定的游戏端口与实际游戏服务器端口一致！这意味着您在启动时-port 指定的端口必须与隧道的tcp/udp端口号相同！
Source Dedicated Server 官方标准是使用27015到27019为游戏数据传输（其他端口也可以）, pings 和 rcon端口。27020为Source TV端口（游戏观战），27005为客户端端口（玩家端口），26900为服务器与Steam通信端口。\n
\n\n
这些端口都有启动命令可以更改，但本教程只更改**游戏数据传输端口**，即可满足玩家游玩的要求。\n
\n\n
| 端口名称 | 更改命令 |
| --- | --- |
| 游戏数据传输端口 | -port |
| Source TV | +tv_port |
| 客户端端口 | -clientport |
| Steam通信 | -sport |
\n\n
## 开始穿透
### SakuraFrp上的工作
一个游戏服务器需要两个隧道，分别是TCP隧道与UDP隧道。如果您需要在一台服务器上架设两个求生之路2服务器，您需要申请4个隧道（两个tcp两个udp）。\n
回到您的服务器上，查看您的内网ip，请不要使用127.0.0.1，这样会导致srcds出现一些奇奇怪怪的bug！\n
在Linux下
```bash
ifconfig
```
\n\n
在Windows下
```powershell
ipconfig
```
\n\n
1. 这样您就得到了您的内网ip，在申请隧道时，隧道类型请选择**tcp隧道**，然后将您得到的**内网ip**填写在**本地IP**中。\n
2. **本地端口**随意填写一个，因为我们现在还没有得知隧道的远程端口是什么（您也可以指定远程端口，指定的**远程端口**与**本地端口**需相同！），其他保留默认值。\n
3. 点击创建，您就获得了一条tcp隧道，在SakuraFrp控制面板中您可以看到新建隧道的远程端口，它位于**类型**下**TCP**旁边。\n
4. 随后点击操作——编辑，将**远程端口号**输入进**本地端口**一栏中，点击保存。\n
5. 再次创建一条**UDP隧道**，此时的**本地端口**与**远程端口**处均填写**tcp隧道远程端口**\n
\n\n
至此，隧道工作准备完成，您可以在服务器上启动SakuraFrp程序了！
### 起源引擎游戏服务器上的工作
您需要先确定下在服务器防火墙上，**tcp隧道远程端口**处于打开状态（TCP/UDP均被打开）！如何操作防火墙不在本文讨论范围内，且部分idc供应商会使用自己的防火面板（如阿里云的安全组，腾讯云的防火墙）\n
\n\n
1. 确认好端口开通后，您需要修改server.cfg文件并在任意位置向其添加
```ini
sv_lan 1
```
?> 由于Valve新规定，部分游戏服务器需要在server.cfg中使用Steam 游戏服务器帐户令牌才能连接，请访问[GSTL令牌帐户管理](https://steamcommunity.com/dev/managegameservers)获取详情
### 启动！
在启动服务器时，您需要在原版启动指令上做一些修改。\n
\n\n
您需要在原版启动指令的基础上添加三个参数
```bash
-port <您的tcp隧道远程端口> -ip <您的内网ip> +hostip <可选，但荒年还是建议您添加：您的内网ip> +sv_setsteamaccount <可选，声明令牌>
```
### 举例
- 启动并穿透求生之路2服务器
```bash
./srcds_run -game left4dead2 -port 33562 -ip 192.168.2.103 +hostip 192.168.2.103 +map c1m1_hotel
```
\n\n
- 启动并穿透反恐精英全球攻势（CSGO）服务器
```bash
./srcds_run -game csgo -port 33562 -ip 192.168.2.168 +hostip 192.168.2.168 +map de_dust2 +maxplayers 10 +sv_setsteamaccount 1145141919810sodayo 
```
\n\n
!> 启动CSGO服务器需要GSTL令牌，使用+sv_setsteamaccount 来在服务器启动时使用你的账户令牌