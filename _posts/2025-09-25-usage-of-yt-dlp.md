---
layout: post
title: "yt-dlp 的一些常用下载参数"
date: 2025-09-25 11:15:33 +0800
tags: ["yt-dlp", "youtube", "bilibili", "哔哩哔哩", "视频下载"]
---

## 为什么使用 yt-dlp

yt-dlp 是非常强的网站视频下载工具, 支持的网站非常多, 可以通过 `yt-dlp --list-extractors` 命令显示出来, 将近两千行
除了 youtube, 常见的比如 哔哩哔哩, 抖音, twitter, steam 都支持

非常可靠, 配置好参数之后, 非常稳定, 更新也非常频繁

作为命令行工具, 推荐使用 chocolatey 这种工具来安装和管理更新之类的事情会比较方便(因为更新很频繁)

或者使用它自己的更新命令: `yt-dlp -U`

## Yt-dlp 下载参数

yt-dlp 因为功能非常强大, 它的参数浩如烟海, 所以这里整理了一些常用的

### 视频 / 音频格式选择

* `-f` / `--format`：选择下载的格式

  ```bash
  yt-dlp -f "bestvideo+bestaudio" <url>   # 下载最佳画质和最佳音频并合成
  yt-dlp -f "bv*[height<=1080]+ba/b" <url> # 最高 1080p
  ```

* `--merge-output-format mp4`：指定合并后的视频格式（默认 mkv）。

---

### 字幕处理

* `--write-subs` / `--write-auto-subs`：下载视频包含的字幕 / 下载自动生成的字幕
* `--sub-lang zh-CN,en`：指定语言
* `--embed-subs`：把字幕嵌入视频文件

  yt-dlp 的嵌入字幕是写入视频文件的独立数据流, 被称为软字幕 (Soft Subtitles) 而不是渲染进视频帧 (Hard Subtitles)

  * MP4：字幕存放在 trak box 中的 text track 或 tx3g 编码里
  * MKV：字幕作为 Subtitle Track（SRT/ASS/VobSub 等）独立流存储

  这种软字幕 PotPlayer、VLC 都支持. 但如果是上传哔哩哔哩, 上传的视频只保留视频和音频, 需要手动上传字幕文件 (SRT, ASS 等)

* `--convert-subs srt`：字幕转换成 SRT 格式

---

### 元数据 / 章节 / 封面

* `--embed-chapters`：嵌入章节（前面说过）
* `--add-metadata`：把视频标题、作者、发布日期等写入文件 metadata

  这个功能非常方便. 一些下载比较旧的视频可能会忘记这个视频是从哪个作者那里下的
  如果带上这个参数, 下载的视频文件右键 - 属性 - 详细信息, 就能看到它的标题, 原视频地址和 up 名字等信息:

  ![img]({{ site.baseurl }}/assets/img/2025-09-25-usage-of-yt-dlp-20250925120442.png)

* `--embed-thumbnail`：下载封面并嵌入视频 / 音频文件 (作为 独立的元数据 metadata 存放的, 不会影响视频帧)
* `--write-thumbnail`: 下载封面为单独的图片文件 (通常是 `.jpg`), 下载路径 / 文件名和视频文件一致

---

### 下载控制

* `-o "<title>.%(ext)s"`：自定义输出文件名

  ```bash
  yt-dlp -o "%(upload_date)s - %(title)s.%(ext)s" <url>
  ```

  `-o` 是 针对当前下载任务的输出路径，也就是说，它会应用到下载的文件——无论是视频、音频还是封面图片，都会用这个模板生成文件名

* `--playlist-start 3` / `--playlist-end 10`：下载播放列表指定区间
* `--limit-rate 2M`：限制下载速度
* `--download-archive downloaded.txt`：记录已下载视频，下次跳过
* `--skip-download`: 跳过下载视频文件的过程, 方便结合 `--write-subs` 等参数只下载字幕等情况

---

### 高级：提取音频 / 转码

* `-x --audio-format mp3`：直接提取音频并转 MP3
* `--audio-quality 0`：最高音质
* `--recode-video mp4`：把下载的视频统一转成 mp4

---

### 网络 / 登录

* `--cookies-from-browser firefox`: 直接从浏览器读取 cookie
  
  这个非常方便, 一般只要用这个参数, 并带上你常用的浏览器, 很多无法下载的问题都可以解决

* `--cookies cookies.txt`：导入浏览器 cookies 下载会员或受限内容
* `--username <user> --password <pass>`：登录下载需要账户的视频

---

### 其他

* `--batch-file urls.txt`：从文件批量下载
* `--exec "echo {}"`：下载后执行命令（比如重命名或移动文件）
* `--config-location ~\\yt-dlp-720.conf`: 参数太多的时候很好用, 把所有参数写在配置文件里

---
