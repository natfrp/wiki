# 如何使用基岩版专用服务器(Bedrock Dedicated Server/BDS)
# How to use the dedicated server
## 免责声明 Disclaimer
这是一个早期版本(alpha)，我们还未完全支持它。它可能包含严重的问题，我们也可能随时结束对其的支持。

This is an early release (alpha) which we don't fully support yet. It might contain severe issues and we could stop supporting it at any time.
## 推荐配置 Recommended Hardware
我们建议您在至少拥有两个内核和1GB RAM的64位英特尔或者AMD处理器上运行基岩版专用服务器。

We recommend running the Bedrock Minecraft Server on 64-bit Intel or AMD processor machines with at least 2 cores and 1 Gb RAM.
## 平台 Platforms
### Linux
Linux版本的基岩版专用服务器需要 Ubuntu 18 或更高版本的操作系统。不支持其他发行版。解压容器文件到空文件夹中。用以下命令启动服务器。

The Linux version of the Bedrock Server requires Ubuntu 18 or later. Other distributions are not supported. Unzip the container file into an empty folder. Start the server with the following command:
```-bash
LD_LIBRARY_PATH=. ./bedrock_server
```
### Windows
Windows版本的基岩版专用服务器需要:

The Windows version of the Bedrock Server requires either:
* Windows 10 1703 或更高版本
* Windows server 2016 或更高版本
* Windows 10 version 1703 or later
* Windows Server 2016 or later

解压容器文件到空文件夹。通过执行`bedrock_server.exe`文件以来启动服务器。

Unzip the container file into an empty folder. Start the server by executing the bedrock_server.exe file.

在某些版本的系统中，当您想使用位于同一台设备上的客户端连接服务器时，您需要通过以下指令解除Minecraft客户端的UWP回环限制:

On some systems, when you wish to connect to the server using a client running on the same machine as the server is running on, you will need to exempt the Minecraft client from UWP loopback restrictions:

```powershell
CheckNetIsolation.exe LoopbackExempt –a –p=S-1-15-2-1958404141-86561845-1752920682-3514627264-368642714-62675701-733520436
```

## 配置 Configuration
服务器将尝试读取一个名为`server.properties`的文件。其中一些选项仅在创建新世界时读取，而其他选项则在每次启动时读取。文件中应该包含一个选项列表，其中选项与值用等号分隔，每行一个。

The server will try to read a file named server.properties. Some of these options are only read when a new world is created, while some others are read every startup. The file should contain a list with keys and values separated with an equal sign, one per line.

以下选项是可以设置的。如果括号中值为数，则该项可以使用数字而不是文本值

The following options are available. If a value as a number in parenthesis, that number can be used instead of the text value.

| 选项名称 Option name|可用值 Possible values|默认值 Default value|何时调用 When is it used|其他注意事项 Notes|
|---|---|---|---|---|
|gamemode	|survival (0), creative (1), adventure (2)	|survival	|Always or only for new players|	
|游戏模式|生存(0)，创造(1)，冒险(2)|生存|总是或者只为新玩家|
|force-gamemode	|true, false	|false	|Always|	force-gamemode=false(or force-gamemode is not defined in the server.properties file) prevents the server for sending to the client gamemode values other than the gamemode value saved by the server during world creation even if those values are set in server.properties file after world creation.force-gamemode=true forces the server to send to the client gamemode values other than the gamemode value saved by the server during world creation if those values are set in server.properties file after world creation.|
|强制游戏模式|是，否|否|总是|当值为否时(或`server.properties`中未定义该项时)服务器不会再次向客户端发送保存在服务端的当世界创建时`server.properties`中的游戏模式信息。当值为是时，则强制服务器向客户端发送保存在服务端的当世界创建时定义在`server.properties`中的游戏模式信息。|
|difficulty|	peaceful (0), easy (1), normal (2), hard (3)|	easy|	Always|	
|游戏难度|和平(0)，简单(1)，普通(2)，困难(3)|简单|总是|
|level-type|	FLAT, LEGACY, DEFAULT|	DEFAULT|	World creation|	
|世界种类|平坦，传统的，默认|默认|世界创建时|
|server-name|	Any string|	Dedicated Server|	Always|	This is the server name shown in the in-game server list.|
|服务器名称|任意值|Dedicated Server|总是|这是玩家在游戏内服务器列表中将看到的名称|
|max-players|	Any integer|	10|	Always|	The maximum numbers of players that should be able to play on the server. Higher values have performance impact.|
|玩家上限|任意值|10|总是|服务器能容纳的最大玩家数量。该值设置过高将影响性能。|
|server-port|	Any integer|	19132|	Always|	
|监听端口(ipv4)|任意值|19132|总是|
|server-portv6|	Any integer|	19133|	Always|
|监听端口(ipv6)|任意值|19133|总是|	
|level-name|	Any string|	Bedrock level|	Always|	The name of level to be used/generated. Each level has its own folder in /worlds.|
|世界名称|任意值|Bedrock level|总是|当一个世界被创建/打开时的名字。每个世界都有独特的/worlds下路径。|
|level-seed|	Any string|	|	World creation|	The seed to be used for randomizing the world. If left empty a seed will be chosen at random.|
|世界种子|任意值| |世界创建时|种子将用于生成世界。如果此项留空则使用随机种子。|
|online-mode|	true, false|	true|	Always|	If true then all connected players must be authenticated to Xbox Live. Clients connecting to remote (non-LAN) servers will always require Xbox Live authentication regardless of this setting. If the server accepts connections from the Internet, then it's highly recommended to enable online-mode.|
|在线模式|是，否|是|总是|如果值为是，则所有连接的玩家必须通过Xbox Live验证。连接到远程（非局域网）服务器的客户端将始终需要 Xbox 实时身份验证，无论此设置如何。如果服务器开放在公网，则强烈建议启用在线模式。|
|white-list|	true, false|	false|	Always|	If true then all connected players must be listed in the separate whitelist.json file. See the Whitelist section.|
|白名单|是，否|否|总是|如果值为是，则只有在`whitelist.json`中列出的玩家能进入服务器。详细方法请看白名单部分。|
|allow-cheats|	true, false|	false|	Always|	
|允许使用控制台指令|是，否|否|总是|
|view-distance|	Any integer|	10|	Always|	The maximum allowed view distance. Higher values have performance impact.|
|视野范围|任意值|10|总是|最大允许的视野范围。该值设置过高将影响性能。|
|player-idle-timeout|	Any integer|	30|	Always|	After a player has idled for this many minutes they will be kicked. If set to 0 then players can idle indefinitely.|
|玩家挂机踢出时间|任意值|30|总是|当玩家挂机超过该时间后将玩家踢出。如果该值为0则玩家永远不会被踢出。|
|max-threads|	Any integer|	8|	Always|	Maximum number of threads the server will try to use.|
|最高线程占用|任意值|8|总是|服务端线程使用的上限|
|tick-distance|	An integer in the range [4, 12]|	4|	Always|	The world will be ticked this many chunks away from any player. Higher values have performance impact.|
|加载距离|[4,12]中的任意整数|4|总是|世界将会以玩家为中心加载以该值为半径内所有的区块(直线距离)。该值设置过高将影响性能。|
|default-player-permission-level|	visitor, member, operator|	member|	Always|	Which permission level new players will have when they join for the first time.|
|世界内玩家的权限|访客，成员，管理员|成员|总是|新玩家第一次加入该世界时所赋予的权限|
|texturepack-required|	true, false|	false|	Always|	If the world uses any specific texture packs then this setting will force the client to use it.|
|强制使用材质包|是，否|否|总是|当该世界使用材质包时是否会强制客户端也使用相同材质包|
|content-log-file-enabled|	true, false|	false|	Always|	Enables logging content errors to a file.|
|日志是否记录|是，否|否|总是|登录错误产生时将会记录在日志中|
|compression-threshold|	An integer in the range [0-65535]|	1|	Always|	Determines the smallest size of raw network payload to compress. Can be used to experiment with CPU-bandwidth tradeoffs.|
|数据包压缩阈值|[0-65535]中的任意整数|1|总是|要压缩的原始网络有效负载的最小大小。|
|server-authoritative-movement|	true, false|	true|	Always|	Enables server authoritative movement. If true, the server will replay local user input on the server and send down corrections when the client's position doesn't match the server's. Corrections will only happen if correct-player-movement is set to true.|
|服务器权威性移动|是，否|是|总是|启用服务器权威性移动时，服务器将会与客户端进行平行运算，并在与客户端运算结果不符时进行更正。|
|player-movement-score-threshold|	Any positive integer|	20|	Always|	The number of incongruent time intervals needed before abnormal behavior is reported. In other words, how many times a player does something suspicious before we take action. Only relevant for server-authoritative-movement.|
|报告异常行为所需的数据不一致的数量|任意正整数|20|总是|报告异常行为之前所需的异常动作数量。换句话说，在我们采取行动之前，玩家最多做多少次可疑的事情。|
|player-movement-distance-threshold|	Any positive float|	0.3|	Always|	The difference between server and client positions that needs to be exceeded before abnormal behavior is registered. Only relevant for server-authoritative-movement.|
|矫正玩家位置所需的偏移量|任意浮点值|0.3|总是|报告异常行为之前所需的服务器与客户端位置偏移量。|
|player-movement-duration-threshold-in-ms|	Any positive integer|	500|	Always|	The duration of time the server and client positions can be out of sync (as defined by player-movement-distance-threshold) before the abnormal movement score is incremented. This value is defined in milliseconds. Only relevant for server-authoritative-movement.|
|所允许的产生偏差的时间延迟(毫秒)|任意值|500|总是|因网络延迟引起的异常动作将不被计算到报告异常行为的阈值计算中，此值定义最大可能出现的延迟|
|correct-player-movement|	true, false|	false|	Always|	If true, the client position will get corrected to the server position if the movement score exceeds the threshold. Only relevant for server-authoritative-movement. We don't recommend enabling this as of yet; work is still in progress.|
|纠正玩家位置|是，否|否|总是|如果该值为是，则服务端将会在玩家异常偏移量超过所设置阈值时纠正玩家的位置|

##  Folders
拆包时，您将看到几个文件夹和可执行的二进制文件。首次启动服务器时将会创建一堆新的(空)文件夹。您应该注意的文件夹如下：

When unpacking you will see a few folders and the binary executable. When starting the server for the first time a bunch of new (empty) folders will be created. The folders you should care about are the following:

|文件夹名称 Folder name|功能 Purpose|
|---|---|
|behavior_packs|	This is where new behavior packs can be installed. At the moment there's no way of activating them in a level.|
|behavior_packs|这是安装新行为包的地方，首先应当在世界中激活这些行为包|
|resource_packs|	This is where new resource packs can be installed. At the moment there's no way of activating them in a level.|
|resource_packs|这是安装新资源包的地方，首先应当在世界中激活这些资源包|
|worlds|	This folder will be created at startup if it doesn't already exist. Every world created will have a folder named according to their level-name inside the server.properties file.|
|worlds|如果该文件夹不存在，将在启动时创建。每个世界创建时将会根据`server.properties`中`level-name`的值所命名|

## 白名单 Whitelist
如果白名单在`server.properties`中启动，则服务器将只允许记录在册的玩家连接。为了使玩家能够连接，你需要知道他们的Xbox Live游戏内名称。将玩家添加到白名单的最简单方法是使用命令`whitelist add <gametag>`(例:`whitelist add ExampleName`)。如果玩家名称含有空格，则需要附上双引号:`whitelist add "Example Name"`

the white-list property is enabled in `server.properties` then the server will only allow selected users to connect. To allow a user to connect you need to know their Xbox Live Gamertag. The easiest way to add a user to the whitelist is to use the command `whitelist add <Gamertag>` (eg: `whitelist add ExampleName`). Note: If there is a white-space in the Gamertag you need to enclose it with double quotes: `whitelist add "Example Name"`

如果您想从白名单移除某位玩家可以使用命令`whitelist remove <gametag>`

If you later want to remove someone from the list you can use the command whitelist remove <Gamertag>.

白名单将会被保存在`whitelist.json`文件内。如果您想自动从中添加或删除玩家，您可以这样做。在编辑该文件后您需要运行指令`whitelist reload`来确定服务器已经知晓新名单。

The whitelist will be saved in a file called whitelist.json. If you want to automate the process of adding or removing players from it you can do so. After you've modified the file you need to run the command whitelist reload to make sure that the server knows about your new change.

该文件包含以下选项/值的对象的 JSON 阵列。

The file contains a JSON array with objects that contains the following key/values.

`whitelist.json`文件示例:

Example whitelist.json file:
```json
[
    {
        "ignoresPlayerLimit": false,
        "name": "MyPlayer"
    },
    {
        "ignoresPlayerLimit": false,
        "name": "AnotherPlayer",
        "xuid": "274817248"
    }
]
```

## 权限 Permissions

微软废话怎么那么多，不翻了，大意就是在`permissions.json`中可以储存玩家权限，在该文件中修改权限后需要执行`permission reload`来把这里头的内容重新拉进内存。

You can adjust player specific permissions by assigning them roles in the permissions.json that is placed in the same directory as the server executable. The file contains a simple JSON object with XUIDs and permissions. Valid permissions are: operator, member, visitor. Every player that connects with these accounts will be treated according to the set premission. If you change this file while the server is running, then run the command permission reload to make sure that the server knows about your new change. You could also list the current permissions with permission list. Note that online-mode needs to be enabled for this feature to work since xuid requires online verification of the user account. If a new player that is not in this list connects, the default-player-permission-level option will apply.

`permissions.json`文件示例：

Example permissions.json file:

```json
[
    {
        "permission": "operator",
        "xuid": "451298348"
    },
    {
        "permission": "member",
        "xuid": "52819329"
    },
    {
        "permission": "visitor",
        "xuid": "234114123"
    }
]
```

## 崩溃报告 Crash reporting
如果服务器崩溃，它将自动向我们发送各种信息以来帮助我们(Microsoft)能做出改进。

If the server crashes it will automatically send us various information that helps us solve it for the future.

## 备份 Backup
服务器支持在服务器运行时获取世界文件的备份。它对于手动备份不是特别友好，但在自动化备份时很快。备份（从服务器的角度来看）由三个命令组成。

|命令 Command|描述 Description|
|---|---|
|save hold|	This will ask the server to prepare for a backup. It’s asynchronous and will return immediately.|
|save hold|告诉服务器准备进行备份。它是异步的，并将立即返回。|
|save query|	After calling save hold you should call this command repeatedly to see if the preparation has finished. When it returns a success it will return a file list (with lengths for each file) of the files you need to copy. The server will not pause while this is happening, so some files can be modified while the backup is taking place. As long as you only copy the files in the given file list and truncate the copied files to the specified lengths, then the backup should be valid.|
|save query|执行`save hold`后，您应该反复调用此命令，查看准备工作是否已完成。当它返回成功时，它将返回您需要复制的文件的文件列表（包括每个文件的长度）。但服务器不会暂停，所以一些文件可以被修改。只要您只复制给定文件列表中的文件并将复制的文件截断为指定长度，那么备份就应该有效。
|save resume|	When you’re finished with copying the files you should call this to tell the server that it’s okay to remove old files again.|
|save resume|当您完成文件的复制时，您可调用这个函数来告诉服务器删除旧文件。|
