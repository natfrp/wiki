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
				text: '出现错误',
				children: [
					{ text: '客户端错误', link: '/faq/client-error.html' },
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
				text: '客户端',
				children: [
					{ text: '启动器使用问题', link: '/faq/launcher.html' },
					{ text: 'frpc 使用问题', link: '/faq/frpc.html' },
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
					{ text: '基本使用指南', link: '/launcher/usage.html' },
					{ text: '远程管理', link: '/launcher/remote.html' },
					{ text: '配置系统服务', link: '/launcher/service.html' },
				],
			},
			{
				text: 'frpc 客户端',
				children: [
					{ text: '基本使用指南', link: '/frpc/usage.html' },
					{ text: '远程管理', link: '/frpc/remote.html' },
					{ text: '配置 SSL 证书', link: '/frpc/ssl.html' },
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
					{ text: '搭建网站 (HTTP/HTTPS)', link: '/app/http.html' },
					{ text: '远程桌面 (RDP)', link: '/app/rdp.html' },
					{ text: 'SFTP 文件传输', link: '/app/sftp.html' },
					{ text: 'FTP 文件传输', link: '/app/ftp.html' },
					{ text: '远程开机 (WOL 网络唤醒)', link: '/app/wol.html' },
					{ text: '我的世界 (Minecraft) 联机', link: '/app/mc.html' },
				],
			},
			{
				text: 'NAS 配置',
				children: [
					{ text: '群晖 / Synology', link: '/app/synology.html' },
					{ text: '威联通 / QNAP', link: '/app/qnap.html' },
					{ text: 'unRAID', link: '/app/unraid.html' },
					{ text: '绿联 / UGREEN', link: '/app/ugreen.html' },
				],
			},
		],
	},
	bestpractice: {
		text: '最佳实践',
		children: [
			'/bestpractice/security.md',
			'/bestpractice/frpc-auth.md',
			'/bestpractice/realip.md',
		],
	},
	offtopic:
	{
		text: '杂项教程',
		children: [
			'/offtopic/mc-bedrock-server.md',
			'/offtopic/mc-geyser.md',
			'/offtopic/source.md',
			'/offtopic/proxy-protocol.md',
			'/offtopic/auth-guest.md',
			'/offtopic/mail.md',
		],
	},
	misc: {
		text: '其他',
		children: [
			'/style.md',
			'/geek.md',
			'/about.md',
		],
	},
};
export default sections;
