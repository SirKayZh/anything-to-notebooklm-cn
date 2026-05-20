# 国内化安装指引

> 把上游 [qiaomu-anything-to-notebooklm](https://github.com/joeseesun/qiaomu-anything-to-notebooklm) 装到 WorkBuddy 体系下，并完成 NotebookLM 登录。

## 0. 环境检查

```bash
python3 --version   # 需要 3.9+
node --version      # 需要 18+
git --version       # 任意
```

## 1. clone 上游 Skill 到 WorkBuddy

⚠️ **不要装到 `~/.claude/skills/`**，要装到 WorkBuddy 的 skills 目录：

```bash
mkdir -p ~/.workbuddy/skills/
cd ~/.workbuddy/skills/
git clone https://github.com/joeseesun/qiaomu-anything-to-notebooklm
cd qiaomu-anything-to-notebooklm
```

## 2. 安装依赖

```bash
# 自动安装
./install.sh

# 或手动
pip3 install -r requirements.txt
playwright install chromium
```

## 3. 注册 MCP 到 WorkBuddy

编辑 `~/.workbuddy/mcp.json`，把上游的两个 MCP 注册进去：

```json
{
  "mcpServers": {
    "wexin-read": {
      "command": "python3",
      "args": [
        "/Users/<你的用户名>/.workbuddy/skills/qiaomu-anything-to-notebooklm/wexin-read-mcp/src/server.py"
      ]
    },
    "feishu-read": {
      "command": "python3",
      "args": [
        "/Users/<你的用户名>/.workbuddy/skills/qiaomu-anything-to-notebooklm/feishu-read-mcp/src/server.py"
      ]
    }
  }
}
```

> 如果已经有其他 MCP 配置，**合并** mcpServers 字段，不要覆盖。

注册完后：**重启 WorkBuddy**，到「连接器管理 → 自定义连接器」页面，对新出现的两个 MCP 点「Trust」启用。

## 4. NotebookLM 登录（一次性）

```bash
cd ~/.workbuddy/skills/qiaomu-anything-to-notebooklm

# 触发 Playwright 打开浏览器，手动登录 Google
python3 -m notebooklm login

# 验证登录成功
python3 -m notebooklm list
```

国内用户登录时常见问题：

| 现象 | 原因 | 解决 |
|---|---|---|
| 浏览器打不开 google.com | 网络不通 | 见 `china-network.md` 配代理 |
| Google 登录验证识别为可疑 | 出口 IP 异常 | 用稳定海外节点重试 |
| 登录后 NotebookLM 报错 | 账号未开通 | 个人 Gmail 即可，企业邮箱可能限制 |

## 5.（可选）配置播客转写 API

仅"小宇宙播客"「视频号」场景需要。注册 Get笔记（getnote.ai）拿 API Key：

```bash
# 加到 ~/.zshrc 或 ~/.bash_profile
export GETNOTE_API_KEY="your_api_key"
export GETNOTE_CLIENT_ID="your_client_id"
```

```bash
source ~/.zshrc
```

## 6.（可选）输出到飞书 / IMA

如果想用场景 1/2 的"输出到飞书文档"或"写入 IMA 笔记"功能：

- **飞书** —— 安装 `lark-master` Skill 并完成飞书 App 授权
- **IMA** —— 安装 `ima-skill` Skill 并配置访问凭证

## 7. 验证

```bash
cd ~/.workbuddy/skills/qiaomu-anything-to-notebooklm
./check_env.py
```

13 项环境检查全绿即代表上游就绪。然后回到 WorkBuddy 对话窗口，输入：

```
把这篇公众号文章生成播客 https://mp.weixin.qq.com/s/<任意>
```

如果 AI 进入流水线、开始抓取，就说明本 Skill 生效。

---

## 卸载

```bash
rm -rf ~/.workbuddy/skills/qiaomu-anything-to-notebooklm
rm -rf ~/.workbuddy/skills/anything-to-notebooklm-cn
# 编辑 ~/.workbuddy/mcp.json 删掉 wexin-read / feishu-read 两条
```
