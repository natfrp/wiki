import { defineUserConfig } from 'vuepress';
import { viteBundler } from '@vuepress/bundler-vite';
import { defaultTheme } from '@vuepress/theme-default';
import { getDirname, path } from '@vuepress/utils';

import { sitemapPlugin } from '@vuepress/plugin-sitemap';
import { mdEnhancePlugin } from 'vuepress-plugin-md-enhance';
import { registerComponentsPlugin } from '@vuepress/plugin-register-components';

import { html5Media as mdItHtml5Media } from 'markdown-it-html5-media';

import sections from './sections';

const __dirname = getDirname(import.meta.url);

export default defineUserConfig({
	base: '/',
	pagePatterns: [
		'**/*.md',
		'!frpc/_usage/*.md',
		'!README.md',
		'!.vuepress',
		'!node_modules'
	],

	lang: 'zh-CN',
	title: 'SakuraFrp 帮助文档',
	description: 'SakuraFrp 帮助文档',

	bundler: viteBundler({
		viteOptions: {
			ssr: {
				noExternal: ['naive-ui'],
			},
		},
	}),

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
			sections.offtopic,
			sections.misc,
		],
		sidebar: {
			'/': Object.values(sections),

			'/faq': sections.faq.children,

			'/app': [sections.app, sections.bestpractice],
			'/bestpractice': [sections.app, sections.bestpractice],

			'/offtopic': sections.offtopic.children,

			'/frpc/': sections.client.children,
			'/launcher/': sections.client.children,
		},
		themePlugins: {
			activeHeaderLinks: false,
			sitemap: false,
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
		registerComponentsPlugin({
			componentsDir: path.resolve(__dirname, './components'),
		}),
		mdEnhancePlugin({
			tabs: true,
			attrs: true,
			sup: true,
			sub: true,
			footnote: true,
			include: true,
			imgSize: true,
			figure: true,
			imgMark: true,
			flowchart: true,
		}),
		sitemapPlugin({
			// The sitemap plugin from theme is somehow broken
			hostname: 'doc.natfrp.com',
			excludePaths: [
				'/404.html',
				'/frpc/service/docker.html',
				'/frpc/usage/docker.html',
				'/frpc/usage/linux.html',
				'/frpc/usage/macos.html',
				'/frpc/usage/windows.html',
			],
		}),
	],
});
