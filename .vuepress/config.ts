import { defaultTheme, defineUserConfig } from 'vuepress';

import markdownItAttrs from 'markdown-it-attrs';

import sections from './sections';

export default defineUserConfig({
	base: '/',
	pagePatterns: ['**/*.md', '!README.md', '!.vuepress', '!node_modules'],

	lang: 'zh-CN',
	title: 'SakuraFrp 帮助文档',
	description: 'SakuraFrp 帮助文档',

	head: [
		['meta', { name: 'application-name', content: 'SakuraFrp 帮助文档' }],
		['meta', { name: 'apple-mobile-web-app-title', content: 'SakuraFrp 帮助文档' }],
		['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
	],

	theme: defaultTheme({
		navbar: [
			{
				text: '快速上手',
				children: [
					'/basics.md',
				],
			},
			sections.faq,
			sections.client,
			sections.app,
			sections.bestpractice,
			{
				text: '其他',
				children: [
					'/style.md',
					'/geek.md',
					'/about.md',
				],
			},
		],
		sidebar: {
			'/': Object.values(sections),

			'/faq/': sections.faq.children,

			'/frpc/': sections.client.children,
			'/launcher/': sections.client.children,

			'/bestpractice/': sections.bestpractice.children,
		},

		docsRepo: 'natfrp/wiki',
		docsBranch: 'master',

		editLinkText: '在 GitHub 上编辑此页',
		lastUpdatedText: '更新时间',
		contributorsText: '贡献者',

		tip: '提示',
		warning: '注意',
		danger: '警告',

		notFound: [
			'页面不存在',
		],
		backToHome: '返回首页',

		openInNewWindow: '在新窗口打开',
		toggleColorMode: '切换夜间模式',
		toggleSidebar: '开关侧边栏',
	}),

	extendsMarkdown: (md => {
		md.use(markdownItAttrs);
	}),
});
