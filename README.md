# anything-to-notebooklm-cn

> 把任何中文内容（公众号/小宇宙/知识星球/财新/视频号）丢进 Google NotebookLM，生成播客、PPT、思维导图、深度分析。

**这是 [joeseesun/qiaomu-anything-to-notebooklm](https://github.com/joeseesun/qiaomu-anything-to-notebooklm)（MIT，4.1k stars）的 WorkBuddy 国内化适配版**，鸣谢原作者。

---

## 这个 Skill 解决什么

原版主要面向海外网络环境，国内用户装上常遇三大问题：

1. **跑不起来** —— 路径、配置不匹配 WorkBuddy
2. **抓不到** —— 6 层付费墙策略 1/2/4/5 层在国内基本无效
3. **没场景** —— 通用示例多，国内典型工作流（公众号→IMA、播客→飞书等）没有现成模板

本 Skill 在原版基础上做的事：

| 维度 | 增强 |
|---|---|
| **WorkBuddy 适配** | MCP 注册路径、SKILL.md frontmatter、安装目录全对齐 |
| **国内化** | 付费墙策略重排、补充国内站点（财新/虎嗅/星球/视频号）、代理/直连方案 |
| **5 大场景模板** | 公众号→IMA / 播客→飞书 / 星球→思维导图 / 财新→播客 / 视频号→PPT |
| **协同** | 与 lark-master / ima-skill / feishu-md-cleaner 联动 |

---

## 快速开始

### 1. 安装上游

```bash
mkdir -p ~/.workbuddy/skills/
cd ~/.workbuddy/skills/
git clone https://github.com/joeseesun/qiaomu-anything-to-notebooklm
cd qiaomu-anything-to-notebooklm
./install.sh
```

### 2. 注册 MCP（编辑 `~/.workbuddy/mcp.json`）

```json
{
  "mcpServers": {
    "wexin-read": {
      "command": "python3",
      "args": ["/Users/<你>/.workbuddy/skills/qiaomu-anything-to-notebooklm/wexin-read-mcp/src/server.py"]
    },
    "feishu-read": {
      "command": "python3",
      "args": ["/Users/<你>/.workbuddy/skills/qiaomu-anything-to-notebooklm/feishu-read-mcp/src/server.py"]
    }
  }
}
```

重启 WorkBuddy → 连接器管理 → Trust 新 MCP。

### 3. 登录 NotebookLM

```bash
python3 -m notebooklm login
```

国内网络方案 → 见 `references/china-network.md`。

### 4. 试跑

```
（在 WorkBuddy 对话里）把这篇公众号文章生成播客并写入 IMA：
https://mp.weixin.qq.com/s/Hu3LHuxqD4xaKEjox4lXyg
```

---

## 5 大杀手场景

| # | 场景 | 输入 | 输出 |
|---|---|---|---|
| 1 | [公众号深度分析](scenarios/01-wechat-to-ima.md) | 公众号 URL | 12 问深度分析 → IMA / 飞书 |
| 2 | [小宇宙播客摘要](scenarios/02-xiaoyuzhou-to-feishu.md) | 单集 URL | 转写 + 结构化摘要 → 飞书 / IMA |
| 3 | [知识星球精华](scenarios/03-zsxq-to-mindmap.md) | 帖子文本 | 思维导图（Markdown + Mermaid） |
| 4 | [财新文章 → 通勤播客](scenarios/04-caixin-to-podcast.md) | 财新付费文章 URL | 双人对话 mp3 |
| 5 | [视频号 → 团队 PPT](scenarios/05-shipinhao-to-ppt.md) | 视频号/B站链接 | 25 页 PDF/PPTX |

---

## 文档地图

```
anything-to-notebooklm-cn/
├── SKILL.md                              # AI 入口（触发词 + 工作流）
├── README.md                             # 你正在看的文件
├── references/
│   ├── installation-cn.md                # 国内化安装详细步骤
│   ├── china-network.md                  # 国内网络方案
│   ├── tool-map.md                       # 工具能力地图（AI 调用前必读）
│   ├── paywall-strategies-cn.md          # 付费墙国内重排
│   └── troubleshooting.md                # 排错
├── scenarios/                            # 5 个场景 SOP
│   ├── 01-wechat-to-ima.md
│   ├── 02-xiaoyuzhou-to-feishu.md
│   ├── 03-zsxq-to-mindmap.md
│   ├── 04-caixin-to-podcast.md
│   └── 05-shipinhao-to-ppt.md
└── scripts/
    ├── check-prereq.sh                   # 前置依赖检查
    └── paywall-priority.json             # 付费墙优先级配置
```

---

## License & Credits

- **License**: MIT
- **上游**: [joeseesun/qiaomu-anything-to-notebooklm](https://github.com/joeseesun/qiaomu-anything-to-notebooklm)
- **本适配**: [SirKayZh/anything-to-notebooklm-cn](https://github.com/SirKayZh/anything-to-notebooklm-cn)
- **致谢**: 上游作者 joeseesun 提供了核心抓取与 NotebookLM 上传能力

> 本 Skill 仅限个人学习研究使用，请尊重原作者版权，并支持优质媒体订阅。
