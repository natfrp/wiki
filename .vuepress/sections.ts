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
					'/faq/client-error.md',
					'/faq/site-inaccessible.md',
				],
			},
			{
				text: '管理面板',
				children: [
					'/faq/realname.md',
					'/faq/beian.md',
					'/faq/payment.md',
					'/faq/account.md',
				],
			},
			{
				text: '客户端',
				children: [
					'/faq/launcher.md',
					'/faq/frpc.md',
				],
			},
			{
				text: '其他',
				children: [
					'/faq/network.md',
					'/faq/misc.md',
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
					'/launcher/usage.md',
					'/launcher/remote.md',
					'/launcher/service.md',
				],
			},
			{
				text: 'frpc 客户端',
				children: [
					'/frpc/usage.md',
					'/frpc/manual.md',
					'/frpc/remote.md',
					'/frpc/ssl.md',
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
					'/app/http.md',
					'/app/rdp.md',
					'/app/sftp.md',
					'/app/wol.md',
					'/app/mc.md',
					'/app/ftp.md',
				],
			},
			{
				text: 'NAS 配置',
				children: [
					'/app/synology.md',
					'/app/qnap.md',
					'/app/unraid.md',
					'/app/ugreen.md',
				],
			},
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
		],
	},
	bestpractice: {
		text: '最佳实践',
		children: [
			'/bestpractice/security.md',
			'/bestpractice/realip.md',
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
