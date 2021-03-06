# Minecraft 基岩版开服指南

> 此教程仅仅是一个简单的入门教程，遇到任何问题，请自行去 [MCBBS](https://www.mcbbs.net/ ':target=_blank') 中寻找答案或者提问。  
> 此文不建议毫无经验的小白用户阅读。  
> 此指南针对的是 **基岩版** 用户，如果您是 **Java 版** 用户，请查看 [Java 版局域网联机](/app/mc#java) 页面。

目前基岩版服务器有两种核心可用:

+ Bedrock Dedicated Server (简称 BDS)  
  由微软官方开发，与 **安卓版**、**Windows 10 版**、**iOS版** Minecraft 相同的核心，适合原版生存
  但相比于原版核心，websocket指令无法使用
+ Nukkit  
  由第三方独立开发的开源核心，生态优于 BDS 但由于功能不完整不适合原版生存，适合搭建各类安装插件的服务器 (如小游戏服务器)

## BDS on Windows

### 开服之前

1. 准备一个可用的 Sakura Launcher 或者 frpc
2. 下载最新版本的 [BDS-Windows 核心](https://www.minecraft.net/en-us/download/server/bedrock/ ':target=_blank')
3. 一台装载着 **Windows 10 1703** 或 **Windows Server 2016** 或更高版本的操作系统的电脑(官方文档建议)
>原因为缺少chakara.dll，如果您有能力可以尝试自己增加补丁
4. 准备一台 CPU 核心数不低于2核，并配有不低于 1GB RAM 的电脑

### 开服配置

解压 BDS 压缩包后，可以在根目录下看到配置文件 `server.properties`。

我们可以通过更改配置文件来达到初始化世界的目的。

#### 配置文件注释

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

white-list = false
# 是否启用白名单模式
# 如果值为 true，则必须在 whitelist.json 文件中列出所有连接的玩家。
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
```

!> 数据压缩如果阈值过低，压缩会占用 CPU ，而开太高会导致流量消耗过快，请自行权衡

#### 可选配置

```ini
level-type = DEFAULT
# 世界的类型
# 可用值: DEFAULT，LEGACY，FLAT (无限，有限，超平坦) 

world-type = 
# 是否开启教育版，实验性玩法
# 可用值: 未知
```
#### 隧道配置

| 协议 | 本地端口(默认) | 远程端口 |
| ---- | :----------:  | :-----: |
| UDP  | 19132         | 任意    |

### 注意事项

如果您想同时在一台电脑上运行服务端和客户端，并且想通过客户端直接连接本地的话，可能会碰上点麻烦：某些 Windows 版本默认不允许 UWP 应用形成 127 回环，需要手动解除限制。

请使用管理员权限在 PowerShell 中执行以下两条命令之一并重启电脑：

```powershell
CheckNetIsolation.exe LoopbackExempt –a –p=S-1-15-2-1958404141-86561845-1752920682-3514627264-368642714-62675701-733520436
```

```powershell
CheckNetIsolation LoopbackExempt -a -n="Microsoft.MinecraftUWP_8wekyb3d8bbwe"
```

## BDS on Linux

### 开服之前

1. 一个可用的 frpc
2. 最新版本的 [BDS-Linux 核心](https://www.minecraft.net/en-us/download/server/bedrock/)
3. 一台装载着 **Ubuntu 18.04** 或更高版本的操作系统的电脑
4. CPU 核心数大于等于 2 核，1GB RAM

### 开服配置

请参考 [BDS on Windows](#bds-on-windows) 章节中的 [开服配置](#开服配置) 。

## NUKKIT on Linux

### 开服之前

1. 准备一个可用的 frpc
2. 准备最新版本的 NUKKIT bedrock 核心（请自行上网下载）
3. 准备一台安装好 Java 环境的 Linux 主机

### 开服配置

#### 配置文件注释

请参考 [BDS on Windows](#bds-on-windows) 章节中的 [配置文件注释](#配置文件注释) 。

#### 安装 JAVA

##### Ubuntu / Debian
  ```bash
  audo apt update
  sudo apt install openjdk-8-jre-headless -y
  ```

##### CentOS / RHEL
  ```bash
  sudo yum install java -y
  ```

## BDS 核心进阶教程

### 白名单

可以直接在服务端控制台用如下指令编辑白名单：

| 指令 | 作用 |
| --- | --- |
| `whitelist add "Example Name"` | 根据昵称添加白名单 |
| `whitelist remove "Example Name"` | 根据昵称移除白名单 |
| `whitelist list` | 输出 `whitelist.json` 的内容 |

您可以直接在 `whitelist.json` 里编辑白名单：

```json
[
    {
        "ignoresPlayerLimit": false, // 是否无视玩家上线 (即使服务器满员该玩家也可进入)
        "name": "MyPlayer"
    },
    {
        "ignoresPlayerLimit": false,
        "name": "AnotherPlayer",
        "xuid": "123456789"          // 其中xuid和昵称有一个就可以，该玩家第一次登入的时候会自动补全
    }
]
```

### 玩家管理

### 管理 OP

如果 OP 想在游戏内使用指令，则必须开启允许作弊的选项 (`allow-cheat = true`)

可以通过以下指令编辑权限：

| 指令                     | 作用     |
| ------------------------ | ------- |
| `op "example players"`   | 添加权限 |
| `deop "example players"` | 剥夺权限 |

### 踢出用户

| 指令                     | 作用     |
| ------------------------ | ------- |
| `kick "example players"` | 踢出用户 |

### 关闭服务器

| 指令   | 作用         |
| ------ | ----------- |
| `stop` | 软关闭服务器 |

### 游戏参数修改

在根目录下会有一个行为包目录 `behavior_packs`，可以通过修改这个文件来达成修改游戏数据的目的。

其中有多个小文件，名称上带有 `experience` 或者 `developing` 的是实验性行为包，如果没有开启实验性玩法的话是不用修改这个文件夹里的内容的。

### 材质包

!> 基岩版的材质包的对应关系是具体到某个世界的。将材质包放入 `resource_packs` 文件夹后需要再进行一些配置。

1. 用客户端随便创建一个世界，创建时勾选想用的材质包。
2. 进入后退出存档，在数据文件夹，找到这个世界服的文件夹。
3. 找到 `world_resource_pack_history.json` 和 `world_resource_pack.json` 并将其拷贝到服务端的`worlds/Bedrock level/` 目录下即可。
4. 如果要所有人强制使用这些材质包，则需要开启强制使用材质的选项 (`texturepack-required = true`)
