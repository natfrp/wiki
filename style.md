---
sidebar: false
---

# 文档格式约定

本文档采用 [markdownlint](https://www.npmjs.com/package/markdownlint) 作为所有 Markdown 文件的格式化工具，格式规则存储于 [.markdownlint.jsonc](https://github.com/natfrp/wiki/blob/master/.markdownlint.jsonc) 文件中，原则上所有 Markdown 文件均需通过验证、没有任何错误或警告信息才能提交到存储库中。

推荐使用 [Visual Studio Code](https://code.visualstudio.com/Download) 作为本文档的编辑器，并安装 `.vscode/extensions.json` 中推荐的拓展以获得最佳编辑体验。

## 标题格式 {#heading}

- 每个标题均由简短的几个字组成，向用户说明下一节内容的大致格式
- 除首个大标题外，所有标题均应在末尾带有一个空格分隔的 `{#<ID>}` 来指定一个合理的 URL slug
- URL slug 应由若干翻译准确、能清晰体现标题内容的英文单词组成，中间用 `-` 隔开。若标题本身由英文组成，请提供一个全小写、由 `-` 替换下划线的 slug

## 用语约定 {#term}

| 对象 | 用语 |
| --- | --- |
| 文档阅读者 | `您` |
| 本平台 | `SakuraFrp` |
| 计算机知识丰富的 Geek / 专业用户 | `高级用户` |
| HTTP 或 HTTPS 隧道 | `HTTP(S) 隧道` |
| 提供内网穿透的服务器 | `节点` |
| 用于演示的节点域名 | `idea-leaper-1.natfrp.cloud`、`idea-leaper-2.natfrp.cloud` 等 |
| 用于演示的隧道名称 | `ExampleTunnel1`、`ExampleTunnel2`、`SampleTunnel1`、`SampleTunnel2` 等 |
| 用于演示的节点 ID 和名称 | `#233 一个神奇的节点`、`#5 Demo Node` |
| 用于演示的 TLD | `example.com`、`example.net` 或其他 [RFC2606](https://tools.ietf.org/html/rfc2606) 中规定的 TLD |

如果您发明了一个新名词，请注意在不同地方使用时保持其一致性。

## 符号约定 {#symbol}

- 用 `空格` 而不是 `Tab` 进行缩进，缩进请交给 markdownlint 处理
- 用 `\n` 进行换行，文件内通常不应出现 `\r`
- 空行不能包含空白字符，应该为单纯的 `\n\n`，请交给 markdownlint 处理
- 在没有特殊说明的地方均使用半角符号，如: `:`，`.`，`<`，`>`，`(`，`)`。通常这些符号后面需要加上一个空格来确保间距合理
- 在文字段落中均采用 `，` 逗号，每句话结尾需添加 `。` 句号，段末通常以 `。` 或 `:` 结尾
- 列表条目、`tip`/`warning`/`danger` 等提示容器中的文本通常不以 `。` 结尾

## 文件结构 {#filesystem}

- 将所有图片放置于和 Markdown 文件位于同一级的 `_images` 文件夹中
- 将所有视频放置于和 Markdown 文件位于同一级的 `_videos` 文件夹中

## 设计元素 {#design-elements}

:::: tabs

@tab 基本说明

本文档支持引入视频、音频并展示播放组件，引入方式和图片一样，采用 `![](./_videos/example.mp4)` 的形式。

本文档启用了 [Markdown Enhance](https://vuepress-theme-hope.github.io/v2/md-enhance/zh/guide/) 插件的
[选项卡](https://vuepress-theme-hope.github.io/v2/md-enhance/zh/guide/tabs.html)、
[属性支持](https://vuepress-theme-hope.github.io/v2/md-enhance/zh/guide/attrs.html)、
[脚注](https://vuepress-theme-hope.github.io/v2/md-enhance/zh/guide/footnote.html) 和
[导入文件](https://vuepress-theme-hope.github.io/v2/md-enhance/zh/guide/include.html) 模块。

本文档启用了 VuePress 默认主题的 [内置组件](https://v2.vuepress.vuejs.org/zh/reference/default-theme/components.html) 和 [自定义容器](https://v2.vuepress.vuejs.org/zh/reference/default-theme/markdown.html) 支持。

需要注意的是，目前在 `details` 容器中嵌入 `tip`、`warning`、`error` 容器时会出现底部边距消失的 Bug，如果需要进行此类嵌套请在最后一行添加一个 `&nbsp`。

此外，本文档还有其他自己实现的功能和自定义 CSS 类，例如 **并排显示**，请切换到其他标签查看。

@tab 并排显示

需要并排显示两块内容（较为常用的场景是并排展示代码块）时，请使用 `natfrp-side-by-side` 类，示例如下：

````markdown
<div class="natfrp-side-by-side"><div>

```javascript
console.info('114514')
```

</div><div>

```javascript
console.info('1919')
```

</div></div>
````

展现效果：

<div class="natfrp-side-by-side"><div>

```javascript
console.info('114514')
```

</div><div>

```javascript
console.info('1919')
```

</div></div>

::::

## 文本间距 {#spacing}

在正常文本和半角标点之间应添加空格，半角标点和全角标点之间无需空格:

```markdown
文本文本 `修饰块` 文本文本 **修饰块** 文本
       ^ 空格   ^ 空格   ^ 空格     ^ 空格

文本文本 `修饰块`，文本文本 (文本文本) 文本
       ^ 空格            ^ 空格     ^ 空格

文本文本。`修饰块`、文本文本
         ^ 半角、全角标点之间无需空格
```

## 文本修饰 {#markup}

::: warning
markdownlint 被配置为不自动修复粗体或斜体的修饰字符，请注意遵守下方规则
:::

使用 `*` 添加粗体、斜体效果:

```markdown
*斜体*

**粗体**

***粗斜体***
```

如果需要添加一条 `*` 开头的斜体提示，可以使用 `_` 包裹 `*`：

```markdown
_* 这是一条温馨提示_
```

## 链接格式 {#links}

- 在链接到文档内部元素时，请使用 `/` 开头的绝对路径链接，并确保链接中包含了文件扩展名 `.md`  
  例：`![prprrpr](/pa47.md)`
- 在链接到外部站点时，请清理链接中不必要的追踪参数  
  正确示例：`![这是好的](https://www.bilibili.com/video/BV1va411w7aM/)`  
  错误示例：`![这很不好](https://www.bilibili.com/video/BV1va411w7aM/?share_source=xxx&yyy=zzz)`

## 无序列表 {#unordered-list}

使用 `-` 作为列表标记，标记后添加一个空格:

```markdown
- ItemA
- ItemB
```

## 有序列表 {#ordered-list}

使用 `1.` 作为列表标记，也可以按个人喜好用 `1.`、`2.`、`3.` 等进行标记，只要保持整个文件一致即可。

标记后添加一个空格与内容分开:

```markdown
1. ItemA
1. ItemB
1. ItemC
```
