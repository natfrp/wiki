import { defaultTheme, defineUserConfig } from 'vuepress';

import navbar from './navbar';
import sidebar from './sidebar';

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

		navbar,
		sidebar,
	}),
});
