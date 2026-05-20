# 场景 5：视频号 → 团队 PPT

## 一句话定位
微信视频号（或 B 站 / 抖音）链接 → 提取音视频 → Whisper 转写 → NotebookLM 生成 PPT。

## 触发词

- 「视频号生成 PPT」「这个视频做 PPT」
- 「B站视频做团队分享 PPT」
- 「短视频转 PPT」

## 为什么单独做？

视频号是国内**最难抓**的内容源之一：
- ❌ 没有公开播放 URL（仅限微信内打开）
- ❌ 反爬严格，不能像 YouTube 那样直接 yt-dlp
- ✅ 唯一可靠路径：屏幕录制 → 提取音轨 → 转写

B 站 / 抖音 / 小红书视频则可以走标准 yt-dlp 路径。

## 输入

| 字段 | 必填 | 说明 |
|---|---|---|
| 视频号链接 / B站 BV 号 / 视频文件 | ✅ | 三选一 |
| PPT 风格 | ⬜ | `团队分享` / `客户汇报` / `极简风`，默认团队分享 |
| 页数偏好 | ⬜ | `15-20` / `25-30` / `40+`，默认 25 |
| 输出格式 | ⬜ | `PDF` / `PPTX` / `Marp md`，默认 PDF |

## 输出

- PPT 文件（PDF / PPTX / Marp）
- 演讲者备注（speaker notes）
- 视频转写文字稿（含时间戳）
- 关键截图（每页配图来源于视频帧）

## 工作流

```
[Step 1] 视频获取（按来源分流）

  CASE A: 微信视频号
    ├─ AI 引导用户：用 QuickTime / 微信电脑版录屏
    ├─ 用户提供本地视频文件
    └─ 输出：video.mp4

  CASE B: B站
    ├─ yt-dlp <BV 号或链接>
    └─ 输出：video.mp4 + 字幕 srt（如有）

  CASE C: 抖音 / 小红书
    ├─ yt-dlp（部分支持）
    └─ 失败则同 CASE A

  CASE D: 用户直接给本地视频
    └─ 跳到 Step 2

[Step 2] 提取音轨 + 关键帧
  ├─ ffmpeg -i video.mp4 -vn audio.m4a
  ├─ ffmpeg 按时间间隔（每 30s 一张）抽关键帧 → frames/
  └─ 输出：audio.m4a + frames/{ts}.jpg

[Step 3] 转写
  ├─ 优先：Get笔记 API（带说话人分离）
  ├─ 次选：Whisper.cpp 本地（large-v3 模型）
  └─ 输出：transcript.txt（含时间戳）

[Step 4] 上传 NotebookLM
  ├─ source 1：transcript.txt
  ├─ source 2：（可选）视频元数据（标题、UP 主、简介）
  └─ 等待索引

[Step 5] 生成 PPT 大纲（核心）
  ├─ 调用 NotebookLM 自定义 prompt（见下）
  ├─ 输出：JSON（每页：标题/要点/讲者备注/对应视频时间戳）
  └─ 输出：outline.json

[Step 6] 选配封面图（关键帧匹配）
  ├─ 每页根据时间戳，从 frames/ 取最接近的关键帧
  ├─ 对截图做轻度增强（去模糊、加 watermark "原视频:<UP主>"）
  └─ 输出：每页配图

[Step 7] 渲染 PPT
  if 格式 == PDF/PPTX:
    → 用 python-pptx 模板填充
  if 格式 == Marp md:
    → 输出 .md，让用户自己用 Marp / Slidev 渲染
  └─ 输出：deck.pdf/pptx/md

[Step 8] 输出
  └─ ~/Downloads/notebooklm-cn/video-to-ppt/<日期>/
```

## PPT 大纲生成 Prompt

```
你是一位专业的内容设计师，把视频转写整理成一份给团队分享用的 PPT。

输入：视频转写（含时间戳）
输出：JSON 数组，每个对象 = 1 页 PPT

要求：
- 总页数 25 ± 3
- 第 1 页：封面（标题、副标题、原视频出处）
- 第 2 页：本次分享的 3 个目标
- 第 3 - N-2 页：核心内容
  - 每页 1 个核心论点 + 3-5 条要点
  - 标题用动词开头，避免名词堆叠
  - 要点不超过 15 字 / 条
- 倒数第 2 页：行动建议
- 最后一页：Q&A / 谢谢

每页 schema：
{
  "page": 1,
  "title": "...",
  "bullets": ["...", "..."],
  "notes": "讲者备注 200 字",
  "ts": "00:12:34"   // 对应视频时间戳，用于截图
}
```

## 渲染选择

| 格式 | 优点 | 适合 |
|---|---|---|
| **PDF** | 跨平台，立即可用 | 临时分享 |
| **PPTX** | 可二次编辑 | 正式汇报、需要美化 |
| **Marp md** | 版本化，纯文本 | 程序员、需要长期维护 |

## 降级方案

| 失败点 | 降级 |
|---|---|
| 视频号无法录屏（手机用户） | 让用户上传视频文件 |
| Whisper 转写不准（方言/口音） | 询问是否切到 Get笔记 API（更鲁棒） |
| NotebookLM 生成大纲超长 | 拆 source（每 30 分钟一段），分页生成 |
| python-pptx 渲染失败 | fallback 到 Marp md |

## 输出物示例

```
~/Downloads/notebooklm-cn/video-to-ppt/2026-05-20/
├── video.mp4               # 原视频缓存
├── audio.m4a
├── transcript.txt
├── frames/                 # 关键帧
├── outline.json            # PPT JSON
├── deck.pdf                # 25 页 PDF
├── deck.pptx               # 可编辑版
└── speaker-notes.md        # 讲稿
```

## 进阶：批量处理

```
把这 5 个 B 站 BV 号都做成 PPT，并合并成一份"AI Agent 入门"系列分享
```

AI 内部：每个视频独立 pipeline → 最后用 LLM 做章节合并 → 输出一份完整 deck。
