export type SidebarChild = string | SidebarItem;

export type SidebarItem = {
	text: string;
	link?: string;
	children?: SidebarChild[];
	collapsible?: boolean;
	sidebarPageText?: string;
};

type SidebarOptions = {
	hashLinks?: 'full' | 'hash-only';
};

type SidebarGroupSelector = number | string;

const normalizeSidebarLink = (link: string): string => (
	link.startsWith('/') ? link.replace(/#.*$/, '') : link
);

const isLocalHashLink = (link: string): boolean => (
	link.startsWith('/') && link.includes('#')
);

const toHashOnlyLink = (link: string): string => link.replace(/^[^#]*/, '');

const toSidebarChildren = (
	children: SidebarChild[],
	options: SidebarOptions = {},
	parentText?: string,
	parentSidebarPageText?: string,
): SidebarChild[] => {
	const pageItems = new Map<string, SidebarItem>();
	const seenPageLinks = new Set<string>();
	const sidebarChildren: SidebarChild[] = [];

	for (const child of children) {
		if (typeof child === 'string') {
			sidebarChildren.push(child);
			continue;
		}

		if (child.link && isLocalHashLink(child.link) && !child.children) {
			const pageLink = normalizeSidebarLink(child.link);
			let pageItem = pageItems.get(pageLink);

			if (!pageItem) {
				pageItem = {
					text: parentSidebarPageText ?? parentText ?? child.text,
					link: pageLink,
					children: [],
				};
				pageItems.set(pageLink, pageItem);
				seenPageLinks.add(pageLink);
				sidebarChildren.push(pageItem);
			}

			pageItem.children?.push({
				...child,
				link: options.hashLinks === 'hash-only'
					? toHashOnlyLink(child.link)
					: child.link,
			});
			continue;
		}

		const sidebarChild = toSidebarItem(child, options);

		if (sidebarChild.link && !sidebarChild.children) {
			if (seenPageLinks.has(sidebarChild.link)) {
				continue;
			}

			seenPageLinks.add(sidebarChild.link);
		}

		sidebarChildren.push(sidebarChild);
	}

	return sidebarChildren;
};

const toSidebarItem = (
	item: SidebarItem,
	options: SidebarOptions = {},
): SidebarItem => {
	const link = item.link ? normalizeSidebarLink(item.link) : undefined;

	return {
		...item,
		text: item.text,
		...(link ? { link } : {}),
		...(item.children ? { children: toSidebarChildren(item.children, options, item.text, item.sidebarPageText) } : {}),
	};
};

const getSidebarChildren = (item: SidebarChild | undefined): SidebarChild[] => (
	item && typeof item !== 'string' && item.children ? item.children : []
);

export const createSidebarTree = (
	item: SidebarItem,
	options: SidebarOptions = {},
) => {
	const root = toSidebarItem(item, options);
	const children = getSidebarChildren(root);
	const groupIndex = (selector: SidebarGroupSelector): number => {
		if (typeof selector === 'number') {
			return selector;
		}

		return children.findIndex((child) => typeof child !== 'string' && child.text === selector);
	};
	const group = (selector: SidebarGroupSelector): SidebarChild[] => (
		getSidebarChildren(children[groupIndex(selector)])
	);

	return {
		root,
		children,
		group,
		after: (selector: SidebarGroupSelector): SidebarChild[] => {
			const index = groupIndex(selector);
			return index === -1 ? [] : children.slice(index + 1);
		},
	};
};

export const createSidebarVariants = (
	item: SidebarItem,
) => ({
	full: createSidebarTree(item),
	page: createSidebarTree(item, {
		hashLinks: 'hash-only',
	}),
});
