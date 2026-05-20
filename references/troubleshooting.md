# 排错与常见问题

## 安装阶段

### 上游 install.sh 失败

```bash
# 1. 单独装 Python 依赖
pip3 install -r requirements.txt --user

# 2. 单独装 Playwright
playwright install chromium

# 3. 检查
./check_env.py
```

### MCP 注册后 WorkBuddy 不识别

| 现象 | 排查 |
|---|---|
| 重启后没看见新 MCP | 检查 `~/.workbuddy/mcp.json` 语法（缺逗号、引号） |
| 看见了但点 Trust 报错 | 检查 server.py 路径是绝对路径 |
| Trust 后调用报错 | 跑 `python3 <server.py>` 看是否能独立启动 |

## 抓取阶段

### 微信公众号 403

```
[Step 1] 抓取失败
  原因：cookie 失效 / 反爬识别
  解决：
    a) 从微信电脑版扫码登录后导出 cookie
    b) 多账号轮转（上游支持 cookie 池）
    c) 最后兜底：让用户复制粘贴
```

### NotebookLM 上传失败

| 错误 | 解决 |
|---|---|
| `not signed in` | 重跑 `notebooklm login` |
| `quota exceeded` | NotebookLM 免费版每天 source 数有限，等待重置 |
| `source too long` | 拆分文档（按章节切片） |
| 一直转圈 | 网络问题，见 china-network.md |

### Get笔记 转写卡住

```
> 等待回调超过 10 分钟
解决：
  1. 确认 GETNOTE_API_KEY 有效（curl 测试）
  2. 检查音频 URL 是否对 Get笔记可达（防盗链）
  3. fallback：本地 Whisper.cpp
```

## 生成阶段

### NotebookLM Audio Overview 报错

| 现象 | 解决 |
|---|---|
| 生成中文播客但出现英文 | source 中混入英文，纯化 source |
| 时长不可控 | 在自定义 prompt 中明确要求"~15 分钟" |
| 音色固定 | NotebookLM 暂不支持自定义音色，需 fallback 到 ChatTTS |

### Mind Map JSON 太深

NotebookLM 的 Mind Map 偶尔会生成 6-7 层深的树。本 Skill 默认裁剪到 4 层：

```python
# scripts/trim_mindmap.py
def trim(node, max_depth=4, current=0):
    if current >= max_depth:
        node["children"] = []
        return
    for child in node.get("children", []):
        trim(child, max_depth, current + 1)
```

## 落地阶段

### 写入 IMA 失败

| 错误 | 解决 |
|---|---|
| `unauthorized` | 重新跑 IMA OAuth 授权 |
| 内容截断 | IMA Notes 单笔记上限 ~50KB，长文要分段 |
| 图片不显示 | IMA 仅支持 https 网络图片，本地图片需先上传图床 |

### 写入飞书失败

参考 `lark-master` 的排错文档。常见：

- App 权限不足 → 飞书后台勾选 docs / drive 权限
- 路径不存在 → 先创建目标文件夹

## 网络问题

完整指引见 `china-network.md`。快速诊断：

```bash
# 1. 能否访问 Google
curl -I https://www.google.com

# 2. 能否访问 NotebookLM
curl -I https://notebooklm.google.com

# 3. 能否访问微信公众号
curl -I https://mp.weixin.qq.com

# 4. 能否访问财新
curl -I https://www.caixin.com
```

按场景启停代理。

## 反馈

遇到本文档没覆盖的问题：
- 在 Skill Hub 评论区反馈
- 或开 GitHub Issue（仓库地址在 SKILL.md）
