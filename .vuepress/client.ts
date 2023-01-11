import { defineClientConfig } from '@vuepress/client';

export default defineClientConfig({
	enhance({ app, router, siteData }) {
		router.beforeEach((to, _, next) => {
			// Comtability redirect for docsify paths
			if (to.fullPath.startsWith('/#/')) {
				const url = new URL(to.fullPath.substring(2), 'https://doc.natfrp.com');
				next({
					path: url.pathname,
					hash: url.hash,
					replace: true
				});
			} else {
				next();
			}
		});
	},
	setup() {
		//
	},
	rootComponents: [],
});
