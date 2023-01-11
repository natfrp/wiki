import { defaultTheme, defineUserConfig } from 'vuepress';

import markdownItAttrs from 'markdown-it-attrs';

import sections from './sections';

export default defineUserConfig({
	base: '/',

	title: 'SakuraFrp 帮助文档',
	description: 'SakuraFrp 帮助文档',

	head: [
		['meta', { name: 'application-name', content: 'SakuraFrp 帮助文档' }],
		['meta', { name: 'apple-mobile-web-app-title', content: 'SakuraFrp 帮助文档' }],
		['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
	],

	theme: defaultTheme({
		repo: 'natfrp/wiki',

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
	}),

	extendsMarkdown: (md => {
		md.use(markdownItAttrs);
	}),
});
