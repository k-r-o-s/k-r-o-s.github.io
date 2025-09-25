# 因为 Jekyll 和 Github pages 的一些问题, 这里需要一些特殊处理

# ---- 图片
# 文中用到的图片需要这样引用 ![图片描述](/assets/img/my-photo.jpg)
# 这代表从项目的根目录找到 assets, 然后找到里面的 img/my-photo.jpg
# 如果发布到 Github pages, 就是 `博客的根目录/assets/img/my-photo.jpg`
# 我使用的 `vscode/paste image` 这个扩展默认会把图片生成在 md 文件所在目录的 img 目录
# 但这个目录在 Github pages 生成时会被忽略
# 所以这里最好拷贝一下
# 当然也可以考虑生成符号链接 (Symlinks) 的方式避免冗余, 但 Github pages 生成时不支持符号链接

cp -rf _posts/img assets/img