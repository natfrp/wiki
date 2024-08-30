const sections = {
	root: {
		text: '快速上手',
		children: [
			'/basics.md',
		],
	},
	faq: {
		text: '常见问题',
		children: [
			{
				text: '客户端',
				children: [
					{ text: '启动器使用问题', link: '/faq/launcher.html' },
					{ text: 'frpc 使用问题', link: '/faq/frpc.html' },
				],
			},
			{
				text: '出现错误',
				children: [
					{ text: '客户端报错', link: '/faq/client-error.html' },
					{ text: '无法访问映射的网站', link: '/faq/site-inaccessible.html' },
				],
			},
			{
				text: '管理面板',
				children: [
					{ text: '实名认证', link: '/faq/realname.html' },
					{ text: '备案相关问题', link: '/faq/beian.html' },
					{ text: '付款、订单问题', link: '/faq/payment.html' },
					{ text: '账户相关问题', link: '/faq/account.html' },
				],
			},
			{
				text: '其他',
				children: [
					{ text: '网络相关问题', link: '/faq/network.html' },
					{ text: '其他常见问题', link: '/faq/misc.html' },
				],
			},
		],
	},
	client: {
		text: '客户端',
		children: [
			{
				text: 'SakuraFrp 启动器',
				children: [
					{ text: '安装、使用指南', link: '/launcher/usage.html' },
					{ text: '远程管理', link: '/launcher/remote-v2.html' },
					{ text: '配置杀软白名单', link: '/launcher/antivirus.html' },
					{ text: '用户手册', link: '/launcher/manual.html' },
				],
			},
			{
				text: 'frpc 客户端',
				children: [
					{ text: '安装、使用指南', link: '/frpc/usage.html' },
					{ text: '配置 SSL 证书', link: '/frpc/ssl.html' },
					{ text: '自动 HTTPS', link: '/frpc/auto-https.html' },
					{ text: '端口导出 (P2P)', link: '/frpc/export-port.html' },
					{ text: '用户手册', link: '/frpc/manual.html' },
				],
			},
		],
	},
	app: {
		text: '配置指南',
		children: [
			{
				text: '常见应用',
				children: [
					{ text: 'Web 应用 (HTTP/HTTPS)', link: '/app/http.html' },
					{ text: '远程桌面 (RDP)', link: '/app/rdp.html' },
					{ text: 'SFTP 文件传输', link: '/app/sftp.html' },
					{ text: 'FTP 文件传输', link: '/app/ftp.html' },
					{ text: '远程开机 (WOL 网络唤醒)', link: '/app/wol.html' },
					{ text: '其他应用', link: '/app/misc.html' },
				],
			},
			{
				text: '游戏联机',
				children: [
					{ text: '我的世界 (Minecraft)', link: '/app/mc.html' },
					{ text: '幻兽帕鲁 (Palworld)', link: '/app/palworld.html' },
					{ text: '星露谷物语 (Stardew Valley)', link: '/app/stardew-valley.html' },
				],
			},
			{
				text: 'NAS 配置',
				children: [
					{ text: '群晖 / Synology', link: '/app/synology.html' },
					{ text: '威联通 / QNAP', link: '/app/qnap.html' },
					{ text: 'unRAID', link: '/app/unraid.html' },
					// { text: '绿联 / UGREEN', link: '/app/ugreen.html' },
					{ text: '飞牛 / fnOS', link: '/app/fnos.html' },
				],
			},
		],
	},
	bestpractice: {
		text: '最佳实践',
		children: [
			'/bestpractice/security.md',
			'/bestpractice/domain-bind.md',
			'/bestpractice/frpc-auth.md',
			'/bestpractice/realip.md',
		],
	},
	offtopic: {
		text: '杂项教程',
		children: [
			{
				text: 'Minecraft 相关教程',
				children: [
					{ text: 'Java 版开服指南', link: '/offtopic/mc-java-server.html' },
					{ text: '基岩版开服指南', link: '/offtopic/mc-bedrock-server.html' },
					{ text: 'Geyser 互通服开服指南', link: '/offtopic/mc-geyser.html' },
				],
			},
			{
				text: '其他教程',
				children: [
					'/offtopic/source.md',
					'/offtopic/auth-guest.md',
					'/offtopic/auth-widget.md',
					'/offtopic/mail.md',
				],
			},
		],
	},
	misc: {
		text: '其他',
		children: [
			'/geek.md',
			'/style.md',
			'/devcontainer.md',
			'/about.md',
			{ text: 'SakuraFrp API', link: 'https://api.natfrp.com/docs/' },
		],
	},
};
export default sections;
