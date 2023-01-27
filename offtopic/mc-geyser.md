# Minecraft Geyser 互通服开服指南

> **互通** 即使 Java 版 与 基岩版 间的玩家和服务器可建立连接，而不只局限于 Java 版玩家加入 Java 版服务器、基岩版玩家加入基岩版服务器。

Minecraft 的国际版存在多种互通方案。

1. Geyser:
   利用一个 Geyser 服务端作为代理
   Java 版玩家正常连接原版服务端
   基岩版玩家则连接该 Geyser 代理服务端，由它将玩家发送的数据转为 Java 版，并发送至 Java 服务端
1. Floodgate:
   这是用于扩展服务端对 Geyser 进行管理的插件

因此，本教程所适用的环境是 **使基岩版玩家加入 Java 版服务端**，而 **不能** 用于使 Java 版玩家加入基岩版服务端。
若它不适用于您的使用环境，请移步 [Java 版局域网联机](/app/mc.md#java) 页面或 [Minecraft 基岩版开服指南](/offtopic/mc-bedrock-server.md) 页面。

## 准备事项

### 软硬件

1. SakuraFrp Launcher 或 frpc
1. 最新版本的 [Java 版服务端](https://www.minecraft.net/zh-hans/download/server)
   | 第三方服务端：
   [Spigot](https://www.spigotmc.org/) | [Spigot](https://papermc.io/) | [Fabric](https://fabricmc.net/) | [CatServer](https://catmc.org/) | [MohistMC](https://mohistmc.com/)
1. 最新版本的 [Geyser 服务端](https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/)
1. JDK 17 运行环境 [下载](https://www.oracle.com/java/technologies/downloads/#jdk17-windows)
   | 较低版本的 Java 版服务端可能需要 JDK16 等历史版本，请参阅相应的服务端文档
1. 一台装载着 **Windows 10 1703** 或 **Windows Server 2016** 或更高版本的操作系统的电脑 (官方文档建议)
1. 电脑： CPU 核心数至少 2 核，RAM 至少 4GB

### 配置运行环境

下载完成各个资源后，您会得到这些文件：

1. `server.jar`
   Java 版服务端
1. `geyser.jar`
   Geyser 服务端
1. `jdk-17_windows-x64_bin.exe`
   JDK 运行环境

#### 安装 JDK 环境

直接双击 `jdk-17_windows-x64_bin.exe` 并一路 Next 以安装。

#### 编辑启动脚本

您应将上述文件列表中的 Java 版服务端及 Geyser 服务端放置到不同的文件夹中。

这里使用 `mcje` 文件夹代表放置 `server.jar` 的文件夹；使用 `geyser` 代表放置 `geyser.jar` 的文件夹。

接下来，您应在 `mcje` 和 `geyser` 目录中分别新建一个 `start.txt` 文件，并使用文本编辑工具打开它。

 `mcje` 中，应填写

```bat
java -Xmx<最大内存>M -Xms<启动内存>M -jar server.jar nogui
```

例如：

```bat
java -Xmx8192M -Xms2048M -jar server.jar nogui
# 即最大内存为 8192MB，启动内存为 2048MB
# 并运行 server.jar，附加参数为 nogui
```

`geyser` 中，则应填写：

```bat
java -Xmx<最大内存>M -Xms<启动内存>M -jar geyser.jar
```

**参数说明**

1. `最大内存`：
   服务端运行后的内存上限，单位为 MB。
1. `启动内存`：
   服务端启动时占用的内存，单位为 MB。

请根据需要设置内存上下限。

最后，您应将这两个文件的后缀名由 `.txt` 改为 `.bat`。

### 编辑 Java 版服务端配置文件

运行 `mcje` 中的 `start.bat` 文件。
数秒后它将自动退出，并生成一些其他文件。

接下来即可编辑配置文件。

#### 同意 EULA

::: warning
[EULA](https://account.mojang.com/documents/minecraft_eula) (End User License Agreement, 终端用户许可协议) 是 Java 版服务端的协议文件。在运行服务端前，必须同意该文件，才能正常启动。
:::

1. 打开运行服务端后自动生成的 `eula.txt`
1. 将其中的 `eula=false` 改为 `eula=true`

#### 编辑配置文件

打开自动生成的 `server.properties` 文件，这就是服务端配置文件。

**配置文件注释**

```ini
#Minecraft server properties
#[星期] [月份] [日期] [时间] CST [年份]
# 自动生成配置文件时附带的时间记录功能，可删除或忽略。

enable-jmx-monitoring = false
# 是否允许 JMX 监视
# 允许值:
#   是: true
#   否: false

rcon.port = 25575
# 远程控制端口
# 允许值: [1, 65535]

level-seed =
# 为世界定义一个种子
# 缺省值为随机

gamemode = survival
# 为新玩家设置游戏模式
# 允许值: 
#   生存: survival
#   创造: creative
#   冒险: adventure

enable-command-block = false
# 是否启用命令方块
# 允许值:
#   是: true
#   否: false

enable-query = false
# 是否启用查询功能
# 允许值:
#   是: true
#   否: false

generator-settings = {}
# 世界生成器设置

level-name = world
# 世界名称

motd = A Minecraft Server
# MOTD 时显示的服务器名称

query.port = 25565
# 查询端口
# 允许值: [1, 65535]

pvp = true
# 是否允许 PVP (玩家间攻击)

generate-structures = true
# 是否允许自然生成结构
# 允许值:
#   是: true
#   否: false

difficulty = easy
# 设定世界的难度
# 允许值: 
#   和平: peaceful
#   简单: easy
#   普通: normal
#   困难: hard

network-compression-threshold = 256
# 要压缩的原始网络有效负载的最小大小
# 允许值 : [0, 65535]

require-resource-pack = false
# 强制客户端加载服务端资源包
# 允许值:
#   是: true
#   否: false

max-tick-time = 60000
# 最长单个游戏刻时间。单个游戏刻加载超过此时长后，服务器将自动关闭。
# 允许值: [0, ∞]

use-native-transport = true
# 是否启用 Linux 的数据包优化功能
# 允许值:
#   是: true
#   否: false

max-players = 20
# 服务端上可以同时在线的最大玩家数。
# 允许值: [1, ∞]

online-mode = true
# 是否根据 Minecraft 账号数据库对玩家进行身份验证
# 启用后，仅正版账号玩家可加入游戏。
# 允许值: 
#   是: true
#   否: false

enable-status = true
# 是否允许在玩家的服务器列表界面中显示在线状态
# 允许值: 
#   是: true
#   否: false

allow-flight = false
# 在安装了可飞行的 mod 时，是否允许生存模式玩家飞行
# 若设置为否，则玩家悬空 5 秒后将被踢出游戏。
# 允许值: 
#   是: true
#   否: false

broadcast-rcon-to-ops = true
# 是否将远程控制台命令的输出发送给所有在线的管理员
# 允许值: 
#   是: true
#   否: false

view-distance = 10
# 设置服务端向客户端发送的区块数量半径，即视距。
# 允许值: [3, 32]

server-ip =
# 设置进入服务器的玩家是否仅限于指定的 IP 地址。
# 缺省值为不作限制

resource-pack-prompt =
# 设置在使用资源包时，在资源包提示符上显示的自定义文本。
# 仅在 require-resource-pack 启用时有效。
# 缺省值为不自定义文本

allow-nether = true
# 是否允许玩家前往下界
# 允许值: 
#   是: true
#   否: false

server-port = 25565
# 设置服务端监听的端口。
# 允许值: [1, 65535]

enable-rcon = false
# 是否允许服务器对控制台的远程访问
# 允许值: 
#   是: true
#   否: false

sync-chunk-writes = true
# 是否允许同步区块写入
# 允许值: 
#   是: true
#   否: false

op-permission-level = 4
# 设置管理员的权限级别。
# 允许值: [0, 4]

prevent-proxy-connections = false
# 是否禁止使用代理连接服务器
# 如果从服务器发送的 ISP/AS 与 Mojang 认证服务器发送的不同，则玩家将被踢出。
# 允许值: 
#   是: true
#   否: false

hide-online-players = false
# 是否在服务器列表中的状态信息中显示在线玩家列表
# 允许值: 
#   是: true
#   否: false

resource-pack =
# 资源包的 URL 地址。
# URL 中，: 及 = 需要在其前一个字符的位置添加 \ 以转义。
# 缺省值为不设置

entity-broadcast-range-percentage = 100
# 设置实体信息发送至客户端前，需离相应玩家有多近。
# 使用百分比表示，如 50 为正常值的一半。
# 允许值: [0, 100]

simulation-distance = 10
# 设置模拟距离半径。
# 若一个实体在该范围之外，则玩家不会看到该实体。
# 允许值: [1, ∞]

rcon.password =
# 设置远程控制的密码。
# 缺省值为不设置

player-idle-timeout = 0
# 设置玩家无操作后踢出的时间，单位为分钟。
# 在服务器收到如下数据包类型之一时，该计时将被重置：
#   单击窗口、附魔物品、更新签名、挖掘、放置方块、更改手持物品、
#   播放动画、与实体交互、客户端状态变化、发送消息、使用实体。
# 允许值: [1, ∞]

force-gamemode = false
# 设置游戏模式。
# 允许值: 
#   生存: survival
#   创造: creative
#   冒险: adventure

rate-limit = 0
# 设置用户被踢出前最多可发送的数据包量。
# 允许值: [1, ∞]

hardcore = false
# 是否启用极限模式
# 在设置为 "是" 后，服务器难度将被忽略并始终固定为困难。
# 玩家死亡后，其游戏模式将被切换为旁观者模式。
# 允许值: 
#   是: true
#   否: false

white-list = false
# 是否启用白名单模式
# 如果值为 true，则必须在 whitelist.json 文件中列出所有连接的玩家。
# 允许值:
#   是: true
#   否: false

broadcast-console-to-ops = true
# 是否将控制台输出发送至所有在线管理员
# 允许值:
#   是: true
#   否: false

spawn-npcs = true
# 是否允许生成村民
# 允许值:
#   是: true
#   否: false

spawn-animals = true
# 是否生成动物
# 允许值:
#   是: true
#   否: false

function-permission-level = 2
# 函数文件的默认权限等级
# 允许值: [0, 4]

level-type = default
# 设置世界类型
# 允许值:
#   标准: default
#   平坦: flat
#   巨型生物群系: largeBiomes
#   放大: amplified

text-filtering-config =
# (需要更多信息)

spawn-monsters = true
# 是否生成怪物
# 允许值:
#   是: true
#   否: false

enforce-whitelist = false
# 是否强制执行白名单
# 启用后，在 whitelist.json 文件重载后，不在白名单中的在线玩家将被踢出游戏。
# 允许值:
#   是: true
#   否: false

resource-pack-sha1 =
# 设置资源包的 SHA1 值，以验证资源包完整性。

spawn-protection = 16
# 设置出生保护区域的大小，0 为禁用该功能。
# 允许值: [0, ∞]

max-world-size = 29999984
# 设置最大的世界边界半径，单位为方块。
# 允许值: [1, 29999984]

# max-chained-neighbor-updates = 0
# 设置连锁更新 NC 的数量，超过此限制的 NC 更新会被跳过。若为负数则无限制。
# 仅在 1.19 及更高版本有效。
# 允许值: [∞, ∞]

# enforce-secure-profile = true
# 是否强制要求使用签名公钥
# 启用后，玩家必须具有由 Mojang 签名的公钥，才能进入服务器。
# 仅在 1.19 及更高版本有效，1.19 默认值为 false。
# 允许值:
#   是: true
#   否: false

# previews-chat = true
# 是否启用聊天预览功能
# 仅在 1.19 至 1.19.2 有效。
# 允许值:
#   是: true
#   否: false

initial-disabled-packs =
# 不会自动启用的数据包名称
# 仅在 1.19.3 及更高版本有效。

initial-enabled-packs = vanilla
# 在创建世界过程中，需要启用并加载的数据包名称
# 仅在 1.19.3 及更高版本有效。
```

### 编辑 Geyser 服务端配置文件

运行 `geyser` 中的 `start.bat` 文件，随后等待加载。

```log
[HH:MM:SS INFO] 完成 (X.XXXs)! 执行 /geyser help 来获取帮助信息!
```

在看到上述信息后，执行 `Ctrl+C` 以关闭 Geyser 服务端。

#### 编辑配置文件

打开自动生成的 `config.yml` 文件，这就是服务端配置文件。

**配置文件注释**

```ini
# --------------------------------
# Geyser 配置文件
#
# 这是一个在 Minecraft: Java 版与 Minecraft: 基岩版间的桥梁。
#
# GitHub 地址: https://github.com/GeyserMC/Geyser
# Discord 地址: https://discord.geysermc.org/
# --------------------------------

bedrock:
# 基岩版玩家连接时的配置信息

  address: 0.0.0.0
  # 设置监听的地址
  # 使用 0.0.0.0 为不限制，任何地址均可连接。
  
  port: 19132
  # 设置监听玩家连接的端口
  # 允许值: [1, 65535]
  
  clone-remote-port: false
  # 是否克隆远程端口
  # 仅插件版 Geyser 服务端可用。
  # 允许值:
  #   是: true
  #   否: false
  
  motd1: "Geyser"
  motd2: "Another Geyser server."
  # 设置基岩版 MOTD 显示信息
  # 在 passthrough-motd 配置项设为 true 时无效
  # 若二者均为空，则会显示 Geyser。
  
  server-name: "Geyser"
  # 设置服务器名称
  
  compression-level: 6
  # 设置数据压缩等级，设为 -1 以禁用此功能。
  # 等级越高，CPU 占用率将越高，反之流量消耗越快，请自行权衡。
  # 允许值: [-1, 9]
  
  enable-proxy-protocol: false
  # 是否允许 proxy-protocol
  # 即是否启用代理的 proxy-protocol 功能，以获取访问者真实 IP。
  # 允许值:
  #   是: true
  #   否: false
  
  proxy-protocol-whitelisted-ips: [ "127.0.0.1", "172.18.0.0/16" ]
  # 设置允许使用代理连接的 IP 地址，仅在 enable-proxy-protocol 配置项设为 true 时有效。
  # IP 地址和子网地址均可使用。
  # 删除此项配置，以禁用该功能。
  
remote:
# 连接到 Java 版服务端的配置信息

  address: auto
  # 设置 Java 版服务端的 IP 地址。
  # 允许值:
  #   本地主机 (127.0.0.1): auto
  #   自定义 IP 地址: (自定义地址)
  
  port: 25565
  # 设置 Java 版服务端的监听端口。
  # 对于插件版，若 address 配置项为 auto，则监听端口将自动设置。
  # 允许值: [1, 65535]
  
  auth-type: online
  # 设置玩家进入服务器时的验证方式。
  # 允许值:
  #   正版登录: online
  #   离线登录: offline
  #   Floodgate 插件: floodgate
  
  allow-password-authentication: true
  # 是否允许使用密码进行登录验证，仅在 auth-type 配置项设为 online 时有效。
  # 允许值:
  #   是: true
  #   否: false
  
  use-proxy-protocol: false
  # 是否使用 proxy-protocol
  # 仅在支持 proxy-protocol 的服务端中有效，如 BungeeCord。
  # 允许值:
  #   是: true
  #   否: false
  
  forward-hostname: false
  # 是否将使用基岩版客户端进入服务器的玩家的主机名用于连接 Java 版服务端
  # 允许值:
  #   是: true
  #   否: false


# 以下是全局配置项

floodgate-key-file: key.pem
# 设置 Floodgate 密钥文件
# 未使用 Floodgate 时，请保留默认值。

saved-user-logins:
  - ThisExampleUsernameShouldBeLongEnoughToNeverBeAnXboxUsername
  - ThisOtherExampleUsernameShouldAlsoBeLongEnough
# 设置用于正版验证的 token。
# 如上方所示，应填写两个足够长的字符串，并确保其不会是一个 Xbox 用户名。
# 相关缓存保存在 saved-refresh-tokens.json 文件中。

pending-authentication-timeout: 120
# 设置在用户通过 Geyser 登录 Microsoft 账号时的最长等待时间，单位为秒。
# 允许值: [1, ∞]

command-suggestions: true
# 是否启用命令建议功能
# 允许值:
#   是: true
#   否: false

passthrough-motd: false
# 是否将 Java 版服务端的 MOTD 信息同步至基岩版
# 允许值:
#   是: true
#   否: false

passthrough-protocol-name: false
# 是否将 Java 版服务端的协议名称同步至基岩版
# 允许值:
#   是: true
#   否: false

passthrough-player-counts: false
# 是否将 Java 版服务端的在线玩家数和玩家数上限同步至基岩版
# 允许值:
#   是: true
#   否: false

legacy-ping-passthrough: false
# 是否启用传统的 ping 同步模式
# 除非 MOTD 信息或在线玩家数未正确显示，否则没有启用此功能的必要。
# 此功能在 Geyser 独立版中无效。
# 允许值:
#   是: true
#   否: false

ping-passthrough-interval: 3
# 设置 ping Java 版服务端的频率，单位为秒。
# 仅适用于 Geyser 独立版或将 legacy-ping-passthrough 配置项设为 true 的情况。
# 允许值: [1, ∞]

forward-player-ping: false
# 是否将玩家的 ping 请求转发至 Java 版服务端
# 启用后将使基岩版玩家获得更准确的 ping，但可能使玩家更易连接超时。
# 允许值:
#   是: true
#   否: false

max-players: 100
# 设置显示的最大在线玩家数。
# 仅用于显示，并不会真正限制在线玩家数。
# 允许值: [1, ∞]

debug-mode: false
# 是否启用调试模式
# 启用后，调试信息将被发送至控制台。
# 允许值:
#   是: true
#   否: false

# Allow third party capes to be visible. Currently allowing:
# OptiFine capes, LabyMod capes, 5Zig capes and MinecraftCapes
allow-third-party-capes: true
# 是否允许使用第三方披风
# 目前支持 OptiFine 披风、LabyMod 披风、5Zig 披风及 Minecraft 披风。
# 允许值:
#   是: true
#   否: false

allow-third-party-ears: false
# 是否允许第三方 deadmau5 监听器可见
# 目前支持 Minecraft 披风。
# 允许值:
#   是: true
#   否: false

show-cooldown: title
# 设置是否、如何为基岩版玩家显示一个假的攻击冷却指针。
# 允许值:
#   显示到标题处: title
#   显示到活动栏处: actionbar
#   不启用此功能: false

show-coordinates: true
# 是否允许显示坐标
# 允许值:
#   是: true
#   否: false

disable-bedrock-scaffolding: false
# 是否禁止基岩版玩家使用脚手架的方式搭桥
# 允许值:
#   是: true
#   否: false

always-quick-change-armor: false
# 是否允许基岩版玩家将正在手持的盔甲穿戴到盔甲栏
# 允许值:
#   是: true
#   否: false

emote-offhand-workaround: "disabled"
# 是否启用表情副手解决方案
# 启用后，当基岩版玩家发送表情时，其主、副手中的物品将如 Java 版一样呼唤。
# 允许值:
#   已禁用: disabled
#   无表情: no-emotes
#   交换物品: emotes-and-offhand

# default-locale: en_us
# 设置默认语言环境
# 这决定了当服务端中已有的语言不包括客户端请求使用的语言时，将使用的语言类型。

cache-images: 0
# 设置从网络下载的图像保存在缓存中的最长天数，单位为天。
# 设为 0 以禁用此功能。
# 允许值: [1, ∞]

allow-custom-skulls: true
# 是否允许自定义生物头颅
# 在早期或低配设备中保持允许，可能会导致性能下降。
# 允许值:
#   是: true
#   否: false

add-non-bedrock-items: true
# 是否在基岩版中添加非基岩版物品
# 目前仅对 Java 版的熔炉矿车生效。禁用此功能后，Java 版的熔炉矿车在基岩版中将被转换为漏斗矿车。
# 更改此配置项后，必须重启 Geyser 服务端以应用。
# 允许值:
#   是: true
#   否: false

above-bedrock-nether-building: false
# 是否禁用基岩版在下界 Y127 以上位置禁止建造方块的功能
# 启用后，Geyser 将通过把下界的维度 ID 改为末地的维度 ID 以实现此功能。
# 相应的，此时的下界将只能使用红色的迷雾，而不能在每个生物群系中有不同迷雾。
# 允许值:
#   是: true
#   否: false

force-resource-packs: true
# 是否强制加载 Java 服务端中的资源包
# 允许值:
#   是: true
#   否: false

xbox-achievements-enabled: false
# 是否解锁 Xbox 进度 (成就)
# 解锁后，将禁用所有成功在基岩版中运行的命令。
# 允许值:
#   是: true
#   否: false

metrics:
# metrics 配置项
# bStats 是一个用于追踪服务器运行状况 (如在线人数) 的平台。
# 前往 https://bstats.org/plugin/server-implementation/GeyserMC 查看更多信息。

  enabled: true
  # 是否启用 mertics
  # 允许值:
  #   是: true
  #   否: false
  
  uuid: 72780cd2-5033-4d42-a329-30845a70f646
  # 设置服务器的 UUID。
  # 请勿修改此配置项。


# 以下是高级选项
# 在修改前，请确认您清楚自己在做什么。

scoreboard-packet-threshold: 20
# 设置计分板数据包每秒的数量。
# 允许值: [4, 20]

enable-proxy-connections: false
# 是否允许来自 ProxyPass 和 Waterdog 的连接
# 更多信息见 https://www.spigotmc.org/wiki/firewall-guide/
# 允许值:
#   是: true
#   否: false

mtu: 1400
# 设置 MTU 值。
# 允许值: [0, 1492]

use-direct-connection: true
# 是否直接连接至 Java 服务端，而不是创建 TCP 连接
# 只应在数据包或网络无法正常与 Geyser 正常工作时禁用此功能。
# 若在插件版本中启用，则将忽略 Java 版服务端地址及监听端口配置项。
# 若在插件版本中禁用，则性能将会下降，同时延迟将会增加。
# 允许值:
#   是: true
#   否: false

config-version: 4
# 设置配置文件版本
# 允许值: [0, ∞]
```

### 配置隧道

为使 Java 版玩家与基岩版玩家均可正常进入服务器，至少需要配置两条隧道。

#### Java 版玩家隧道

Java 版玩家使用 TCP 隧道进入服务器。

| 节点 | 协议 | 本地端口(默认) | 远程端口 |           本地 IP         | 其他配置项 |
| ---- | ---- | :----------:  | :-----: | :-------------------------: | :--------: |
| 任意 | TCP  | 25565         | 任意    | Java 版服务端运行的 IP 地址 | 保留默认值或留空 |

#### 基岩版玩家隧道

Java 版玩家使用 UDP 隧道进入服务器。

|        节点       | 协议 | 本地端口(默认) | 远程端口 |           本地 IP         |
| :---------------: | ---- | :----------:  | :-----: | :-------------------------: |
| 未屏蔽 UDP 的节点 | UDP  | 19132         | 任意    | Geyser 服务端运行的 IP 地址 |

::: warning
使用 frpc 时 MOTD 信息无法正常显示
:::

## 运行服务端

### 运行 Java 版服务端

运行 `mcje` 中的 `start.bat` 以开始运行 Java 版服务端。

若您看到如下内容，说明 **Java 版服务端已启动成功**：

```log
[HH:MM:SS] [Server thread/INFO] Done(X.XXXs)! For help, type "help"
```

### 运行 Geyser 服务端

运行 `geyser` 中的 `start.bat` 以开始运行 Geyser 服务端。

若您看到如下内容，说明 **Geyser 服务端已启动成功**：

```log
[HH:MM:SS INFO] 完成 (X.XXXs)! 执行 /geyser help 来获取帮助信息!
```

> **什么是 `mcje` 和 `geyser` ？**
>
> 如果你有这样的疑问，请回到 准备事项 部分阅读更多信息。

### 管理 Geyser 服务端

#### 检查更新

在 Geyser 控制台中执行 `geyser version` 以检查更新。

#### 关闭 Geyser 服务端

有三种关闭 Geyser 服务端的方式，均在 Geyser 控制台中执行。

1. `geyser shutdown`
1. `geyser stop`
1. `Ctrl+C`

::: warning
**请不要通过直接关闭 Geyser 服务端窗口的方式关闭 Geyser 服务端**，这将导致端口仍被占用。
:::

#### 命令列表

| 命令名称        | 条件   | 释义                                   |
| --------------- | ------ | -------------------------------------- |
| geyser list     | 控制台 | 列出通过 Geyser 连接服务器的所有玩家   |
| geyser version  | 控制台 | 显示当前的 Geyser 版本并检查更新       |
| geyser help     | 控制台 | 显示所有已注册命令的帮助               |
| geyser ?        | 控制台 | 显示所有已注册命令的帮助               |
| geyser reload   | 控制台 | 重载 Geyser 配置文件并踢出所有玩家     |
| geyser dump     | 控制台 | 转储 Geyser 调试信息以获得更多错误报告 |
| geyser shutdown | 控制台 | 关闭 Geyser                            |
| geyser stop     | 控制台 | 关闭 Geyser                            |

## 进阶：使用 MCSManager 管理面板运行 Geyser 服务端

> 此进阶教程以在 MCSManager 中安装 Geyser 为主，MCSManager 版本为 9.4.4

### 准备事项

1. 安装好 MCSManager 的电脑 | 安装过程请前往 [MCSManager 官方文档](https://docs.mcsmanager.com/) 查看
1. Geyser 服务端

### 创建实例

进入 MCSManager 9 管理面板的 `应用实例` 界面。

选择守护进程后，点击 `新建实例`。

| 步骤                 | 内容                    |
| -------------------- | ----------------------- |
| `选择相应的实例类型` | 基岩版 Minecraft 服务端 |
| `关于创建方式`       | 上传单个服务端软件      |
| `实例名称`           | 任意字符串              |

#### 启动命令模板

```ini
java -Xmx<最大内存>M -Xms<启动内存>M -Dfile.encoding=UTF-8 -Duser.language=cn -Duser.country=ZH -jar geyser.jar nogui
```

随后，上传 `Geyser.jar` 服务端文件，并等待自动创建。

### 编辑实例参数

| 项目         | 内容             |
| ------------ | -------          |
| 终端输入编码 | `UTF-8`          |
| 终端输出编码 | `UTF-8`          |
| 文件管理编码 | `UTF-8`          |
| 关闭实例命令 | `^C`             |
| 更新程序命令 | `geyser version` |
