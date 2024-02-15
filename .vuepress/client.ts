import { defineClientConfig } from 'vuepress/client';
// import { defineClientConfig } from 'vuepress/dist/client';

export default defineClientConfig({
	enhance({ router }) {
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
});
