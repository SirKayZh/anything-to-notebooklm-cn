---
name: anything-to-notebooklm-cn
description: 把公众号/小宇宙播客/知识星球/财新/视频号/B站等中文内容一键丢进 Google NotebookLM，自动生成播客、PPT、思维导图、深度报告。基于上游 joeseesun/qiaomu-anything-to-notebooklm 的 WorkBuddy 国内化适配版，预置 5 大杀手场景模板，与 IMA 笔记、飞书文档无缝联动。Use when 用户说「丢进 NotebookLM」「转成播客」「公众号转播客」「PDF 做思维导图」「文章生成 PPT」等。
description_zh: NotebookLM 中文场景包（公众号/小宇宙/知识星球/财新/视频号）
description_en: NotebookLM China Scenario Pack (WeChat / Xiaoyuzhou / Caixin / Video)
disable: false
agent_created: true
upstream: https://github.com/joeseesun/qiaomu-anything-to-notebooklm
license: MIT
version: 0.1.0
---

# anything-to-notebooklm-cn

把任何中文内容丢进 NotebookLM，生成播客 / PPT / 思维导图 / 深度分析。

## 触发词

「丢进 NotebookLM」「生成 NotebookLM」「转成播客」「做成 PPT」「做成思维导图」「深度分析这篇」「转 IMA 笔记 / 飞书」

## 5 大场景路由（命中后读对应文档）

| 场景 | 输入 | 文档 |
|---|---|---|
| 公众号深度分析 → IMA / 飞书 | 公众号 URL | `scenarios/01-wechat-to-ima.md` |
| 小宇宙播客 → 飞书 / IMA 摘要 | 小宇宙 URL | `scenarios/02-xiaoyuzhou-to-feishu.md` |
| 知识星球精华 → 思维导图 | 帖子文本 | `scenarios/03-zsxq-to-mindmap.md` |
| 财新文章 → 通勤播客 | 财新 URL | `scenarios/04-caixin-to-podcast.md` |
| 视频号 / B站 → 团队 PPT | 视频链接 | `scenarios/05-shipinhao-to-ppt.md` |

## 工作流（所有场景统一）

```
1. 抓取 → 2. 清洗 → 3. NotebookLM 生成 → 4. 落地（IMA / 飞书 / 本地）
```

匹配场景 → 读 `scenarios/0X-xxx.md` → 按 SOP 执行 → 失败走 `references/troubleshooting.md` 降级。

## 按需查阅

| 何时 | 读什么 |
|---|---|
| **调用任何工具前** | `references/tool-map.md` 🔴 必读 |
| 用户首次使用 | `references/installation-cn.md` |
| 网络问题 | `references/china-network.md` |
| 抓不到内容 | `references/paywall-strategies-cn.md` |
| 任意环节报错 | `references/troubleshooting.md` |

## 协同

`WebFetch`（内置抓取）/ `lark-master`（飞书）/ `ima-skill:notes` 或 `:knowledge-base`（IMA，注意区别！）/ `feishu-md-cleaner`（格式清理）/ `agent-browser`（兜底浏览器）

⚠️ **每个工具的能力/触发/坑请查 `references/tool-map.md`**，不要凭名字猜用法。

## License & Credits

MIT · 上游：[joeseesun/qiaomu-anything-to-notebooklm](https://github.com/joeseesun/qiaomu-anything-to-notebooklm) · 适配：[SirKayZh](https://github.com/SirKayZh/anything-to-notebooklm-cn)
