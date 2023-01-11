import { defaultTheme, defineUserConfig } from 'vuepress';

import { mdEnhancePlugin } from 'vuepress-plugin-md-enhance';
import { nextSearchPlugin } from 'vuepress-plugin-next-search';

import { html5Media as mdItHtml5Media } from 'markdown-it-html5-media';

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
				text: '配置指南',
				children: [
					...sections.app.children,
					sections.bestpractice,
				],
			},
			sections.faq,
			sections.client,
			sections.misc,
		],
		sidebar: {
			'/': Object.values(sections),

			'/faq': sections.faq.children,

			'/app': [sections.app, sections.bestpractice],
			'/bestpractice': [sections.app, sections.bestpractice],

			'/frpc/': sections.client.children,
			'/launcher/': sections.client.children,
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
		md.use(mdItHtml5Media);
	}),

	plugins: [
		mdEnhancePlugin({
			tabs: true,
			attrs: true,
			footnote: true,
			include: {
				currentPath: (env) => env.filePath,
			},
		}),
		nextSearchPlugin({
			fullText: true,
			placeholder: '搜索',
			frontmatter: {
				tag: '标签',
				category: '分类',
			}
		}),
	],
});
