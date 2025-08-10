# 使用 jekyll 钩子在 minima 主题的代码段右上角加上复制按钮

## 主要思路

在 Jekyll 的 Minima 主题中为代码块加上“复制到剪切板”按钮，通常的做法是：

1. **添加复制按钮的 HTML 和 CSS**
在你的布局文件（如 `_layouts/default.html` 或包含代码块的页面模板）中，给代码块外层包裹一个容器，并添加一个复制按钮元素。
2. **引入 JavaScript 实现复制功能**
可以通过一段简单的 JavaScript 使用 `navigator.clipboard.writeText()` API 来实现点击按钮时复制代码块内容到剪切板。

具体示例步骤：

- 在你 Jekyll 项目的 `_includes` 或布局文件里，找到代码块渲染部分（Minima 主题默认会把代码块用 `<pre><code>` 包裹），然后修改成如下结构：

```html
<div class="code-container">
  <button class="copy-btn" onclick="copyCode(this)">复制</button>
  <pre><code>{{ content | escape }}</code></pre>
</div>
```

- 在你网站的 JavaScript 代码文件（例如在 `assets/js` 下新建 `copy.js`，并确保被布局引用）添加如下复制功能：

```js
function copyCode(button) {
  const code = button.nextElementSibling.querySelector('code').innerText;
  navigator.clipboard.writeText(code).then(() => {
    button.innerText = '已复制';
    setTimeout(() => { button.innerText = '复制'; }, 2000);
  }).catch(err => {
    console.error('复制失败:', err);
  });
}
```

- 添加简单样式美化按钮，比如在你的 CSS 文件（如 `assets/css/style.scss`）里：

```css
.code-container {
  position: relative;
}

.copy-btn {
  position: absolute;
  top: 5px;
  right: 5px;
  font-size: 12px;
  padding: 4px 8px;
  cursor: pointer;
  background: #eee;
  border: 1px solid #ccc;
  border-radius: 3px;
  z-index: 10;
}

.copy-btn:hover {
  background: #ddd;
}
```

这样，页面的每个代码块右上角都会有一个“复制”按钮，点击按钮后代码内容会复制到剪切板，按钮文字短暂变成“已复制”以示反馈。

总结：

- 使用 HTML 包裹代码块加按钮
- 用 JavaScript 调用 Clipboard API 实现复制
- 用 CSS 调整按钮样式和位置

这是目前给 Jekyll Minima 主题代码块添加复制按钮的推荐做法。[^1][^2]

[https://cloud.tencent.com/developer/information/如何使用Hugo和github页面自动更新内容](https://cloud.tencent.com/developer/information/如何使用Hugo和github页面自动更新内容)

[https://www.cnblogs.com/apachecn/p/18501898](https://www.cnblogs.com/apachecn/p/18501898)

[https://www.cnblogs.com/apachecn/p/18462380](https://www.cnblogs.com/apachecn/p/18462380)

## 自定义 jekyll 钩子

Jekyll 自定义钩子（Hooks）是通过编写插件来在生成网站的不同阶段插入你的代码，实现细粒度的控制。你可以在项目根目录下创建一个 `_plugins` 文件夹，里面放 Ruby 脚本文件，利用 `Jekyll::Hooks.register` 来注册钩子，钩子定义了对应的“容器”和“事件”，钩子触发时执行的代码块即可实现自定义逻辑。

具体做法：

1. 在你的 Jekyll 项目根目录创建 `_plugins` 目录（如果尚不存在）。
2. 在 `_plugins` 目录新建 Ruby 文件，如 `copy_button_hook.rb`。
3. 在这个文件中使用 `Jekyll::Hooks.register`，选择适合的容器和事件来操作代码块内容，比如在页面渲染后修改其 HTML。

一个示例，假设你想在所有页面渲染后，给页面里的所有代码块 `<pre><code>` 追加一个复制按钮的 HTML，可以写：

```ruby
Jekyll::Hooks.register :pages, :post_render do |page|
  # 取页面内容
  doc = page.output
  # 使用正则或 Nokogiri 等库替换或插入复制按钮（这里示例简单的字符串替换）
  doc.gsub!(/<pre><code>/, '<div class="code-container"><button class="copy-btn" onclick="copyCode(this)">复制</button><pre><code>')
  doc.gsub!(/<\/code><\/pre>/, '</code></pre></div>')
  # 将修改后的内容再写回 page.output
  page.output = doc
end
```

这样，每当 Jekyll 渲染页面后都会调用这个钩子，自动给页面中的代码块用 `<div>` 包裹并插入复制按钮的 HTML，避免你手动修改布局文件。

你也可以针对文档（posts 或 collections）使用不同的容器和事件，钩子支持以下容器：

- `:site`
- `:pages`
- `:posts`
- `:documents`

事件包括：

- `:pre_render`
- `:post_render`
- `:post_write`
- 等等

这是官方文档中支持的机制，你可以写更复杂的逻辑（如使用 Nokogiri 解析和修改 HTML 更安全）。

总结：

- 自定义钩子通过 `_plugins` 下的 Ruby 脚本实现
- 使用 `Jekyll::Hooks.register` 注册钩子，定义在哪个容器哪个事件触发
- 在钩子回调中对页面或文档的 HTML 内容进行修改
- 这是全站自动添加功能的优雅办法，避免全覆盖布局文件大工程

如需，我可以帮你写一个更完整的带复制按钮插入的钩子示例代码。

（参考官方插件和钩子文档中介绍）[^1]

[https://jekyllcn.com/docs/plugins/](https://jekyllcn.com/docs/plugins/)

[https://luneshao.github.io/2020/2020-03-23-jekyll-blog/](https://luneshao.github.io/2020/2020-03-23-jekyll-blog/)

[https://blog.csdn.net/gitblog_00037/article/details/145026775](https://blog.csdn.net/gitblog_00037/article/details/145026775)

[https://jekyllcn.com/docs/deployment-methods/](https://jekyllcn.com/docs/deployment-methods/)

[https://www.cnblogs.com/ityouknow/p/11904647.html](https://www.cnblogs.com/ityouknow/p/11904647.html)

[https://soptq.me/2020/03/27/jekyll-plugin-filter/](https://soptq.me/2020/03/27/jekyll-plugin-filter/)

[https://craftweeks.com/zh/webp自動生成git-hooks教學/](https://craftweeks.com/zh/webp自動生成git-hooks教學/)

[https://blog.csdn.net/gitblog_00727/article/details/141699087](https://blog.csdn.net/gitblog_00727/article/details/141699087)

[https://opensource.guide/zh-hans/best-practices/](https://opensource.guide/zh-hans/best-practices/)

[https://firebase.google.com/docs/genkit/dotprompt?authuser=8\&hl=zh-cn](https://firebase.google.com/docs/genkit/dotprompt?authuser=8\&hl=zh-cn)

## 具体代码

针对你的需求，想在 Jekyll 渲染后的页面中找到所有 `<pre ...><code ...>` 结构的节点，并插入包含复制按钮的 `<button>` 代码，同时要保留 `pre` 和 `code` 标签的属性，最安全且灵活的做法是使用 Ruby 处理插件中页面渲染后的 HTML，利用 Nokogiri 解析和修改 DOM。

下面是一个具体示范代码（放在你的 Jekyll 项目 `_plugins/copy_button_hook.rb` 文件中）：

```ruby
require 'nokogiri'

Jekyll::Hooks.register [:pages, :posts, :documents], :post_render do |doc|
  # 解析当前页面输出的HTML
  html = Nokogiri::HTML::DocumentFragment.parse(doc.output)

  # 查找所有 <pre><code> 结构的节点
  html.css('pre').each do |pre_node|
    # 找到直接包含的code节点
    code_node = pre_node.at_css('code')
    next unless code_node

    # 创建按钮节点，注意这里用 Nokogiri 创建元素，避免手写拼接HTML不安全
    button_node = Nokogiri::XML::Node.new('button', html)
    button_node['class'] = 'copy-btn'
    button_node['onclick'] = 'copyCode(this)'
    button_node.content = '复制'

    # 创建一个包裹容器div，赋class方便css定位
    container_node = Nokogiri::XML::Node.new('div', html)
    container_node['class'] = 'code-container'

    # 把按钮和 pre 节点移动到 container 中
    container_node.add_child(button_node)
    container_node.add_child(pre_node.unlink) # unlink 移动节点

    # 用 container 节点替换原来的 pre 节点
    pre_node.replace(container_node)
  end

  # 把修改后的HTML重新赋值给页面输出
  doc.output = html.to_html
end
```

要点说明：

-https://nokogiri.org/) 解析当前页面生成的 HTML 片段，能正确处理带属性的节点，而不是简](https://nokogiri.org/) 解析当前页面生成的 HTML 片段，能正确处理带属性的节点，而不是简单的字符串替换。
- 遍历所有 `<pre>` 标签，查找其中的 `<code>`，确认是代码块后处理。
- 在原 `<pre>` 前插入一个 `<button>`，并用一个包裹 `<div class="code-container">` 容器包裹按钮和代码块整体。
- 最后把修改后的 DOM 重新赋值给 `doc.output`，这样生成的页面就会带有复制按钮，且保留了 `pre`, `code` 原有属性。

你还需要在你的站点中配合前面的 JS 代码（`copyCode` 函数）和 CSS，使按钮样式生效并能复制内容。

总结：这是一个比较标准、健壮的用法，可以兼顾保留属性和灵活插入按钮，避免了直接修改布局或简单正则替换可能带来的兼容性问题。

如果需要，我也可以帮你写对应的 CSS 和 JS 代码。

[https://stackoverflow.com/questions/35977346](https://stackoverflow.com/questions/35977346/how-to-add-some-classes-in-html-file-after-rendering-with-jekyll)

[https://www.mslinn.com/jekyll_plugins/jekyll_pre.html](https://www.mslinn.com/jekyll_plugins/jekyll_pre.html)

[https://andrewtbiehl.com/blog/jekyll-tree-sitter](https://andrewtbiehl.com/blog/jekyll-tree-sitter)

[https://talk.jekyllrb.com/t/add-color-to-code-added-in-posts/1037](https://talk.jekyllrb.com/t/add-color-to-code-added-in-posts/1037)

[https://github.com/jekyll/jekyll/issues/3738](https://github.com/jekyll/jekyll/issues/3738)

[https://yunchipang.github.io/overriding-default-theme-in-jekyll.html](https://yunchipang.github.io/overriding-default-theme-in-jekyll.html)

[https://github.com/tree-sitter/ruby-tree-sitter/issues/9](https://github.com/tree-sitter/ruby-tree-sitter/issues/9)

[https://talk.jekyllrb.com/t/jekyll-capture-is-not-preserving-new-lines-carriage-returns](https://talk.jekyllrb.com/t/jekyll-capture-is-not-preserving-new-lines-carriage-returns/4160)

[https://jekyll-themes.com/cademirci/jekyll-code-style](https://jekyll-themes.com/cademirci/jekyll-code-style)

[https://nicolashery.com/fast-mobile-friendly-website-with-jekyll/](https://nicolashery.com/fast-mobile-friendly-website-with-jekyll/)

