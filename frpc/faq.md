<style>
orange {
    color: orange;
}
</style>

# frpc 常见问题

### 隧道启动成功后么查看数字 IP

ping 一下就有了, 例如你获取到的域名是 `cn-zz-bgp.sakurafrp.com`

![](_images/image-13.png)

请直接执行命令 `ping cn-zz-bgp.sakurafrp.com`

![](_images/image-14.png)

### 提示信息怎么是英文的, 能汉化一下吗?

汉化提示信息会造成部分用户无法正确理解 FAQ 内容, 也会增大版本更新时的工作量, 因此我们暂时没有这类打算

### frpc 日志怎么看

下面会列出 frpc 中常见错误日志简单解读, 请注意标题中 **<orange>高亮</orange>** 的部分, 看到这些关键字就可以直接根据相关条目进行排查了

#### <orange>connect to local service</orange> [xxxx:xxxx] error: dial tcp 127.0.0.1:25565: connectex: <orange>No connection could be made because the target machine actively refused it.</orange>

这类日志说明 frp 在正常工作中, 但是 frpc 无法连接到你的本地服务, 请检查

 - 本地服务 (例如 Minecraft 服务器, HTTP 服务器) 是否已经正常启动
 - 创建隧道时填写的 **本地端口、本地地址** 是否有误
 - 防火墙或杀毒软件是否拦截了 frpc 请求本地服务

#### <orange>Request failed after </orange> 3 <orange>retries:</orange> /xxxxx

这类日志说明 frpc 无法连接到我们的 API 服务器并获取配置文件、更新数据等信息, 请检查

 - 你的设备是否能正常访问 API 服务器
   - DNS 解析是否正常? 可以使用 `ping api.natfrp.com` 命令检查, 如果获取到 `127.0.0.1` 则不正常, 请排查 DNS 问题
   - SSL 证书是否正常? 
     - Windows 系统请使用 **Internet Explorer** 访问 `https://api.natfrp.com/` 查看是否出现安全警告, 如果出现请参考 [这篇 FAQ](/launcher/faq#远程证书无效) 安装根证书
     - Linux 系统可以使用 `curl https://api.natfrp.com/` 查看是否存在错误输出, 如果出现证书错误可以尝试安装 `ca-certificates` 包解决
 - 防火墙或杀毒软件是否拦截了 frpc 的请求
 - 我们的服务是否出现可用性问题

#### <orange>start error: router config conflict</orange>

这类日志说明 frp 服务端已存在相同的绑定域名, 无法创建 HTTP(S) 隧道, 请检查

 - 创建隧道时填写的域名是否有误
 - 本地/其他设备上是否已经开启了 frpc 或存在 frpc 进程残留, 占用了这个隧道
 - 如果您确认上面两条都没有问题, 通常稍等 2~3 分钟即可正常连接到服务端, 请注意等待期间不要尝试连接
