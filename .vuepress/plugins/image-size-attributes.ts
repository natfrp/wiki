import { existsSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';

import { getDirname, path } from '@vuepress/utils';

const __dirname = getDirname(import.meta.url);
const sourceDir = path.resolve(__dirname, '../..');

interface ImageSize {
	width: number;
	height: number;
}

interface MarkdownEnv {
	filePath?: string;
	filePathRelative?: string;
	path?: string;
	relativePath?: string;
}

const imageSizeCache = new Map<string, ImageSize | null>();

const isExternalImage = (src: string): boolean => /^(?:[a-z][a-z\d+.-]*:|\/\/)/i.test(src);

const cleanImageSrc = (src: string): string | null => {
	const cleanSrc = src.replace(/[?#].*$/, '');

	try {
		return decodeURIComponent(cleanSrc);
	} catch {
		return cleanSrc;
	}
};

const isInsideSourceDir = (filePath: string): boolean => {
	const relativePath = path.relative(sourceDir, filePath);

	return relativePath === '' || (!relativePath.startsWith('..') && !path.isAbsolute(relativePath));
};

const getMarkdownFilePath = (env: MarkdownEnv): string | null => {
	const filePath = env.filePath ?? env.path;

	if (filePath) {
		return path.isAbsolute(filePath) ? filePath : path.resolve(sourceDir, filePath);
	}

	const filePathRelative = env.filePathRelative ?? env.relativePath;

	return filePathRelative ? path.resolve(sourceDir, filePathRelative) : null;
};

const resolveLocalImagePath = (src: string, env: MarkdownEnv): string | null => {
	if (!src || isExternalImage(src)) return null;

	const cleanSrc = cleanImageSrc(src);

	if (!cleanSrc) return null;

	const imagePath = cleanSrc.startsWith('@source/')
		? path.resolve(sourceDir, cleanSrc.slice('@source/'.length))
		: cleanSrc.startsWith('/')
			? path.resolve(sourceDir, cleanSrc.slice(1))
			: path.resolve(path.dirname(getMarkdownFilePath(env) ?? sourceDir), cleanSrc);

	return isInsideSourceDir(imagePath) && existsSync(imagePath) ? imagePath : null;
};

const parsePngSize = (buffer: Buffer): ImageSize | null => {
	const isPng = buffer.length >= 24
		&& buffer[0] === 0x89
		&& buffer.toString('ascii', 1, 4) === 'PNG';

	if (!isPng) return null;

	return {
		width: buffer.readUInt32BE(16),
		height: buffer.readUInt32BE(20),
	};
};

const parseGifSize = (buffer: Buffer): ImageSize | null => {
	const header = buffer.toString('ascii', 0, 6);

	if (buffer.length < 10 || (header !== 'GIF87a' && header !== 'GIF89a')) return null;

	return {
		width: buffer.readUInt16LE(6),
		height: buffer.readUInt16LE(8),
	};
};

const parseJpegSize = (buffer: Buffer): ImageSize | null => {
	if (buffer.length < 4 || buffer[0] !== 0xff || buffer[1] !== 0xd8) return null;

	let offset = 2;

	while (offset < buffer.length) {
		while (buffer[offset] === 0xff) offset += 1;

		const marker = buffer[offset];
		offset += 1;

		if (marker === 0xd9 || marker === 0xda || offset + 2 > buffer.length) break;

		const segmentLength = buffer.readUInt16BE(offset);

		if (segmentLength < 2 || offset + segmentLength > buffer.length) break;

		if (
			(marker >= 0xc0 && marker <= 0xc3)
			|| (marker >= 0xc5 && marker <= 0xc7)
			|| (marker >= 0xc9 && marker <= 0xcb)
			|| (marker >= 0xcd && marker <= 0xcf)
		) {
			return {
				width: buffer.readUInt16BE(offset + 5),
				height: buffer.readUInt16BE(offset + 3),
			};
		}

		offset += segmentLength;
	}

	return null;
};

const parseBmpSize = (buffer: Buffer): ImageSize | null => {
	if (buffer.length < 26 || buffer.toString('ascii', 0, 2) !== 'BM') return null;

	return {
		width: Math.abs(buffer.readInt32LE(18)),
		height: Math.abs(buffer.readInt32LE(22)),
	};
};

const parseSvgLength = (value: string | undefined): number | null => {
	const match = value?.trim().match(/^(\d+(?:\.\d+)?)(?:px)?$/i);

	return match ? Number(match[1]) : null;
};

const parseSvgSize = (buffer: Buffer): ImageSize | null => {
	const text = buffer.toString('utf8', 0, Math.min(buffer.length, 4096));
	const svgMatch = text.match(/<svg\b[^>]*>/i);

	if (!svgMatch) return null;

	const svgTag = svgMatch[0];
	const width = parseSvgLength(svgTag.match(/\bwidth=(["'])(.*?)\1/i)?.[2]);
	const height = parseSvgLength(svgTag.match(/\bheight=(["'])(.*?)\1/i)?.[2]);

	if (width && height) return { width: Math.round(width), height: Math.round(height) };

	const viewBox = svgTag.match(/\bviewBox=(["'])(.*?)\1/i)?.[2]
		.trim()
		.split(/[\s,]+/)
		.map(Number);

	if (viewBox?.length === 4 && viewBox.every(Number.isFinite)) {
		return {
			width: Math.round(viewBox[2]),
			height: Math.round(viewBox[3]),
		};
	}

	return null;
};

const readImageSize = (filePath: string): ImageSize | null => {
	if (imageSizeCache.has(filePath)) return imageSizeCache.get(filePath) ?? null;

	const buffer = readFileSync(filePath);
	const extension = path.extname(filePath).toLowerCase();
	const size = parsePngSize(buffer)
		?? parseGifSize(buffer)
		?? parseJpegSize(buffer)
		?? parseBmpSize(buffer)
		?? (extension === '.svg' ? parseSvgSize(buffer) : null);

	imageSizeCache.set(filePath, size);

	return size;
};

const imageSizeMarkdownPlugin = (md: any): void => {
	const originalImageRender = md.renderer.rules.image;

	md.renderer.rules.image = (tokens: any[], index: number, options: any, env: MarkdownEnv, self: any): string => {
		const token = tokens[index];
		const src = token.attrGet('src');

		if (src && !token.attrGet('width') && !token.attrGet('height')) {
			const imagePath = resolveLocalImagePath(src, env);
			const size = imagePath ? readImageSize(imagePath) : null;

			if (size) {
				token.attrSet('width', String(size.width));
				token.attrSet('height', String(size.height));
			}
		}

		return originalImageRender(tokens, index, options, env, self);
	};
};

const getHtmlAttribute = (attributes: string, name: string): string | null => {
	const match = attributes.match(new RegExp(`\\b${name}\\s*=\\s*(["'])(.*?)\\1`, 'i'));

	return match?.[2] ?? null;
};

const addImageSizeAttributesToHtml = (html: string, env: MarkdownEnv): string => html.replace(
	/<img\b([^>]*?)>/gi,
	(match, attributes) => {
		if (/\bwidth\s*=/i.test(attributes) || /\bheight\s*=/i.test(attributes)) return match;

		const src = getHtmlAttribute(attributes, 'src');
		const imagePath = src ? resolveLocalImagePath(src, env) : null;
		const size = imagePath ? readImageSize(imagePath) : null;

		if (!size) return match;

		const ending = match.endsWith('/>') ? '/>' : '>';

		return `${match.slice(0, -ending.length)} width="${size.width}" height="${size.height}"${ending}`;
	},
);

const patchPreparedPageComponents = (directory: string): void => {
	if (!existsSync(directory)) return;

	for (const entry of readdirSync(directory, { withFileTypes: true })) {
		const filePath = path.join(directory, entry.name);

		if (entry.isDirectory()) {
			patchPreparedPageComponents(filePath);
		} else if (entry.isFile() && filePath.endsWith('.vue')) {
			const content = readFileSync(filePath, 'utf8');
			const updatedContent = addImageSizeAttributesToHtml(content, {});

			if (updatedContent !== content) {
				writeFileSync(filePath, updatedContent);
			}
		}
	}
};

export const imageSizeAttributesPlugin = {
	name: 'image-size-attributes',
	extendsMarkdown: (md: any): void => {
		md.use(imageSizeMarkdownPlugin);
	},
	extendsPage: (page: any): void => {
		page.contentRendered = addImageSizeAttributesToHtml(page.contentRendered, {
			filePath: page.filePath ?? undefined,
			filePathRelative: page.filePathRelative ?? undefined,
		});
	},
	onPrepared: (app: any): void => {
		patchPreparedPageComponents(app.dir.temp('pages'));
	},
};
