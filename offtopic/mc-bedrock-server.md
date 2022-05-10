# Minecraft 基岩版开服指南

> 此教程仅仅是一个简单的入门教程，遇到任何问题，请自行去 [MCBBS](https://www.mcbbs.net/ ':target=_blank') 中寻找答案或者提问。  
> 此文不建议毫无经验的小白用户阅读。  
> 此指南针对的是 **基岩版** 用户，如果您是 **Java 版** 用户，请查看 [Java 版局域网联机](/app/mc#java) 页面。

目前基岩版服务器有两种核心可用:

1. Bedrock Dedicated Server （简称 BDS）
   由微软官方开发，与所有平台的 Minecraft 基岩版有几乎相同的核心，目前可以全平台联机，适合原版生存  
   [历史版本下载(非官方)](https://mcbds.reh.tw/) | [最新版本下载(官方)](https://www.minecraft.net/zh-cn/download/server/bedrock/)
1. Nukkit  
   由第三方独立开发的开源核心，生态优于 BDS 但由于功能不完整不适合原版生存，适合搭建各类安装插件的服务器 (如小游戏服务器)

## BDS on Windows

### 开服之前

1. 准备一个可用的 Sakura Launcher 或者 frpc
1. 下载最新版本的 [BDS-Windows 核心](https://www.minecraft.net/zh-cn/download/server/bedrock/ ':target=_blank')
1. 一台装载着 **Windows 10 1703** 或 **Windows Server 2016** 或更高版本的操作系统的电脑 (官方文档建议) 
1. 准备一台 CPU 核心数不低于 2 核，并配有不低于 1GB RAM 的电脑

### 开服配置

解压 BDS 压缩包后，可以在根目录下看到配置文件 `server.properties`。

我们可以通过更改配置文件来达到初始化世界的目的。

#### 配置文件注释

!> 表中所填数据均为缺省值

```ini
server-name = Dedicated Server
# 服务器名称

gamemode = survival
# 为新玩家设置游戏模式
# 允许值: 
#   生存: survival
#   创造: creative
#   冒险: adventure

difficulty = easy
# 设定世界的难度
# 允许值: 
#   和平: peaceful
#   简单: easy
#   普通: normal
#   困难: hard

allow-cheats = false
# 是否允许使用类似命令的作弊手段。
# 允许值: 
#   是: true
#   否: false

max-players = 10
# 服务端上可以同时在线的最大玩家数。
# 允许值: [1, ∞]

online-mode = true
# 是否对所有连接的玩家进行 Xbox Live 身份验证。
# 无论此设置如何，连接到远程 (非本地) 服务端的客户端将始终需要 Xbox Live 身份验证。
# 如果服务端接受来自互联网的连接，则强烈建议启用联机模式。
# 允许值: 
#   是: true
#   否: false

allow-list = false
# 是否启用白名单模式
# 如果值为 true，则必须在 allowlist.json 文件中列出所有连接的玩家。
# 仅对 BDS 1.18.10 及更高版本有效，更低版本请使用下方的 white-list 配置项
# 允许值:
#   是: true
#   否: false

# white-list = false
# 是否启用白名单模式
# 如果值为 true，则必须在 whitelist.json 文件中列出所有连接的玩家。
# 仅对 BDS 1.18.2 及更低版本有效，使用时应删除上方的 allow-list 配置项和 white-list 前的 #。
# 允许值:
#   是: true
#   否: false

server-port = 19132
# 服务端应监听哪个IPv4端口。
# 允许值: [1, 65535]

server-portv6 = 19132
# 服务端应监听哪个IPv6端口。
# 允许值: [1, 65535]

view-distance = 32
# 允许的最大视距 (以方块数为单位) 。
# 允许值: [1, ∞]

tick-distance = 4
# 停止加载区块的距离
# 允许值 : [4, 12]

player-idle-timeout = 30
# 挂机玩家被踢出的时间
# 允许值: [0, ∞]

max-threads = 8
# 服务端使用的最大线程数，如果设置为0，服务端会尽可能多地使用所有线程。
# 允许值: [0, ∞]

level-name = Bedrock level
# 世界名称以及文件夹名

level-seed = 
# 为世界定义一个种子
# 缺省值为随机

default-player-permission-level = member
# 新玩家的游戏模式
# 允许值: 
#   游客: visitor
#   会员: member
#   管理员: operator

texturepack-required = false
# 强制客户端加载服务端资源包
# 允许值:
#   是: true
#   否: false

content-log-file-enabled = false
# 启用将会使错误内容记录到日志文件中
# 允许值:
#   是: true
#   否: false

compression-threshold = 1
# 要压缩的原始网络有效负载的最小大小
# 允许值 : [0, 65535]

server-authoritative-movement = true
# 启用服务端权威性移动。
# 如果值为 true ，则服务端将在以下位置重设本地用户输入。
#   1. 客户端的位置与服务端的位置不匹配时，发送服务端更正位置并向下发送至客户端更正。
#   2. 仅当正确的玩家移动设置为 true 时，才会进行更正。

player-movement-score-threshold = 20
# 报告异常行为之前所需的数据不一致的数量。
# 仅在 server-authoritative-movement 选项开启时生效

player-movement-distance-threshold = 0.3
# 在检测到异常行为之前，服务端与客户端数值之差。
# 仅在 server-authoritative-movement 选项开启时生效

player-movement-duration-threshold-in-ms = 500
# 服务端和客户端位置的时间长度可能不同步 (在 server-authoritative-movement 选项为"false"时失效)
# 在异常移动计数增加之前。 此值以毫秒为单位定义。
# 仅在 server-authoritative-movement 选项开启时生效

correct-player-movement = false
# 是否在移动值超过阈值时，将客户端的玩家位置校正为服务端玩家的位置。
# 允许值:
#   是: true
#   否: false

server-authoritative-block-breaking = false
# 启用服务端权威性挖掘
# 如果值为 true ，则服务端将与客户端同步计算挖掘，并且更正与服务端计算不符的非法挖掘
```

!> 数据压缩如果阈值过低，压缩会占用 CPU ，而开太高会导致流量消耗过快，请自行权衡

#### 可选配置

```ini
level-type = DEFAULT
# 世界的类型
# 可用值: DEFAULT，LEGACY，FLAT (无限，有限，超平坦) 
# LEGCY (有限) 选项仅在 1.18 前可用

world-type = 
# 是否开启教育版，实验性玩法
# 可用值: 未知

trusted-key =
# 服务端所信任的公钥，拥有该公钥的玩家不进行Xbox身份验证
# 可出现多行
```
#### 隧道配置

| 协议 | 本地端口(默认) | 远程端口 |
| ---- | :----------:  | :-----: |
| UDP  | 19132         | 任意    |

!> 使用 frpc 时 MOTD 信息无法正常显示

### 注意事项

如果您想同时在一台电脑上运行服务端和客户端，并且想通过客户端直接连接本地的话，可能会遇到一些问题：某些 Windows 版本默认不允许 UWP 应用形成本地回环，需要手动解除限制。

请使用管理员权限在 PowerShell 中执行以下命令并重启电脑：

```powershell
CheckNetIsolation.exe LoopbackExempt –a –p=S-1-15-2-1958404141-86561845-1752920682-3514627264-368642714-62675701-733520436
```

## BDS on Linux

### 开服之前

1. 一个可用的 frpc
2. 最新版本的 [BDS-Linux 核心](https://www.minecraft.net/zh-cn/download/server/bedrock/)
3. 一台装载着 **Ubuntu 18.04** 或更高版本的操作系统的电脑
4. CPU 核心数大于等于 2 核，1GB RAM

### 开服配置

请参考 [BDS on Windows](#bds-on-windows) 章节中的 [开服配置](#开服配置) 。

### 注意事项

!> Linux下无法同时运行多个服务端

RHEL 8 (CentOS 8) 可能缺少 `libnsl` 包，此时服务端将无法正常启动

请使用以下命令进行安装：

```bash
sudo dnf install -y libnsl
```

## NUKKIT on Linux

### 开服之前

1. 准备一个可用的 frpc
2. 准备最新版本的 NUKKIT bedrock 核心（请自行上网下载）
3. 准备一台安装好 Java 环境的 Linux 主机

### 开服配置

#### 配置文件注释

请参考 [BDS on Windows](#bds-on-windows) 章节中的 [配置文件注释](#配置文件注释) 。

#### 安装 JAVA

**Ubuntu / Debian**

```bash
sudo apt update
sudo apt install openjdk-8-jre-headless -y
```

**CentOS / RHEL**

```bash
sudo yum update
sudo yum install java -y
```

## BDS 核心进阶教程

### 白名单

可以直接在服务端控制台用如下指令编辑白名单：

在 1.18.10 及更高版本，使用：

| 指令                              | 作用                         |
| --------------------------------- | ---------------------------- |
| `allowlist add "Example Name"`    | 根据昵称添加白名单           |
| `allowlist remove "Example Name"` | 根据昵称移除白名单           |
| `allowlist list`                  | 输出 `allowlist.json` 的内容 |

在 1.18.2 及更低版本，使用：

| 指令                              | 作用                         |
| --------------------------------- | ---------------------------- |
| `whitelist add "Example Name"`    | 根据昵称添加白名单           |
| `whitelist remove "Example Name"` | 根据昵称移除白名单           |
| `whitelist list`                  | 输出 `whitelist.json` 的内容 |

您可以直接在 `allowlist.json` 或 `whitelist.json` 里编辑白名单：

```json
[
    {
        "ignoresPlayerLimit": false, // 是否无视玩家上限 (即使服务器满员该玩家也可进入)
        "name": "MyPlayer"
    },
    {
        "ignoresPlayerLimit": false,
        "name": "AnotherPlayer",
        "xuid": "123456789"          // 其中xuid和昵称有一个就可以，该玩家第一次登入的时候会自动补全
    }
]
```

### 规则管理

### 配置文件热更改

如果想在服务器正常运行的情况下修改配置文件的内容，可以通过以下指令管理规则：

| 指令                               | 作用             |
| ---------------------------------- | ---------------- |
| `changesetting allow-cheats true`  | 允许作弊         |
| `changesetting allow-cheats false` | 禁止作弊         |
| `changesetting difficulty peaceful`| 游戏难度设为和平 |
| `changesetting difficulty easy`    | 游戏难度设为简单 |
| `changesetting difficulty normal`  | 游戏难度设为普通 |
| `changesetting difficulty hard`    | 游戏难度设为困难 |

`peaceful` `easy` `normal` `hard` 分别可用 `0` `1` `2` `3` 代替。

### 白名单热更改

| 指令                     | 作用                                   |
| ------------------------ | -------------------------------------- |
| `allowlist on`           | 开启白名单                             |
| `allowlist off`          | 关闭白名单                             |
| `allowlist list`         | 打印 `allowlist.json` 内容             |
| `allowlist reload`       | 将 `allowlist.json` 内容重新加载到内存 |

### 管理 OP

如果 OP 想在游戏内使用指令，则必须开启允许作弊的选项 (`allow-cheats = true`)

可以通过以下指令编辑权限：

| 指令                     | 作用     |
| ------------------------ | ------- |
| `op "example players"`   | 添加权限 |
| `deop "example players"` | 剥夺权限 |
| `permission list`        | 打印 `permission.json` 内容 |
| `permission reload`      | 将 `permission.json` 内容重新加载到内存

### 踢出用户

| 指令                     | 作用     |
| ------------------------ | ------- |
| `kick "example players"` | 踢出用户 |

### 关闭服务器

| 指令   | 作用         |
| ------ | ----------- |
| `stop` | 软关闭服务器 |

### 备份服务器

| 指令         | 作用             | 说明                                                        |
| ------------ | --------------- | ------------------------------------------------------------ |
| `save hold`  | 服务器做备份准备 | 它是异步的，并将立即返回。                                   |
| `save query` | 查询备份准备进度 | 返回准备进度，它将返回需要复制的文件的文件列表。              |
| `save resume`| 删除旧文件       | 当您完成文件的复制时，您可调用这个函数来告诉服务器删除旧文件。|

### 游戏参数修改

在根目录下会有一个行为包目录 `behavior_packs`，可以通过修改这个文件来达成修改游戏数据的目的。

其中有多个小文件，名称上带有 `experience` 或者 `developing` 的是实验性行为包，如果没有开启实验性玩法的话是不用修改这个文件夹里的内容的。

### 材质包

!> 基岩版的材质包的对应关系是具体到某个世界的。将材质包放入 `resource_packs` 文件夹后需要再进行一些配置。

1. 用客户端随便创建一个世界，创建时勾选想用的材质包。
1. 进入后退出存档，在数据文件夹，找到这个世界的文件夹。
1. 找到 `world_resource_pack_history.json` 和 `world_resource_pack.json` 并将其拷贝到服务端的 `worlds/Bedrock level/` 目录下即可。
1. 如果要所有人强制使用这些材质包，则需要开启强制使用材质的选项 (`texturepack-required = true`)

### BDS 系基岩版服务端/拓展工具

!> 其中部分是通过反编译以达成修改的目的, 并不符合 EULA, 请慎用。
 
- [LiteLoader](https://github.com/LiteLDev/LiteLoaderBDS) 第三方 BDS 插件加器，支持 C++、GoLang、JavaScript、Lua
- [BDLauncher](https://github.com/BDLDev/bdlauncher) 第三方 BDS 插件加载器，已停更
- [BedrockX](https://github.com/Sysca11/BedrockX-bin) 第三方 BDS 插件加载器，已停更
- [ElementZero](https://github.com/Element-0/ElementZero) 第三方服务端，支持实验玩法和教育版
- [BDXCore](https://github.com/Sysca11/BDXCore) 第三方 BDS 插件加载器，有封装 HOOK API ，适配性强
- [BDSJSRunner](https://github.com/zhkj-liuxiaohua/BDSJSRunner-Release) 符合工业标准规范的 BDS 跨版本插件开发解决方案
- [NetJSRunner](https://github.com/zhkj-liuxiaohua/BDSJSR2) .NET 版 JS 加载平台，依赖于 BDSNetRunner
- [PFJSR](https://github.com/littlegao233/PFJSR) NetJSRunner 衍生版
- [BDSPyRunner](https://github.com/twoone-3/BDSpyrunner) python 脚本插件运行平台
- [IronPythonRunner](https://github.com/Sbaoor-fly/CSR-IronPythonRunner) IronPython 拓展平台，依赖于 BDSNetRunner.
- [IronLuaRunner](https://github.com/Sbaoor-fly/CSR-IronLuaRunner) IronPython 拓展平台，依赖于BDSNetRunner
- [IronLuaLoader](https://github.com/Sbaoor-fly/CSR-IronLuaLoader) IronPython 拓展平台，依赖于BDSNetRunner
- [BDSJavaRunner](https://github.com/zhkj-liuxiaohua/BDSJavaRunner) Jar1.8 加载器
- [BDSAddonInstaller](https://github.com/chegele/BDSAddonInstaller) Add-on/node.js 加载工具
- [MCscripts](https://github.com/TapeWerm/MCscripts) 用于备份、更新、安装、警告的系统单元，bash 脚本，聊天机器人
- [MCBEPlay](https://foxynotail.com/mcbeplay/) GUI 版 BDS
