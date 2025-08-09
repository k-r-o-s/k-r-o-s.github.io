---
layout: post
title: "诡异的日期折腾几个小时"
date: 2025-08-10 07:30:00 +0800
tags: ["jekyll"]
---

第一次尝试 `jekyll` + `Github pages` 构建博客, 其他都正常, 就是每次打开首页都是空的

反复尝试了非常多办法

结果最后居然是因为用了 `jekyll-post` 这个 VSCode 插件

这东西用来自动生成文件名和 `YAML Front Matter`

但它生成的 post 的 `YAML Front Matter` 的日期字段格式类似于 `2025-08-10 07:30`

而 `Github Action` 需要 `2025-08-10 07:30:00 +0800` 这种格式才能识别

太特喵无语了

就为这折腾几个小时, `Github Action` 那边无任何报错或者提示
