# 发布到 ClawHub Skill Hub

## 发布前自检清单

```
✅ SKILL.md frontmatter 完整（name / description / agent_created / license）
✅ README.md 含上游 credit 和安装步骤
✅ LICENSE 文件存在（MIT）
✅ 没有打包任何凭证（cookie / API key / cookie 文件）
✅ scripts/ 没有内嵌账号配置示例
✅ 5 个场景 SOP 完整
✅ 引用上游仓库时使用绝对 URL，不假设上游已 clone
✅ check-prereq.sh 可执行（chmod +x）
```

## 打包

ClawHub 接受 zip 包或 git 仓库链接。

```bash
cd ~/.workbuddy/skills/
zip -r anything-to-notebooklm-cn-v0.1.0.zip anything-to-notebooklm-cn \
  -x "anything-to-notebooklm-cn/.git/*" \
  -x "anything-to-notebooklm-cn/__pycache__/*" \
  -x "anything-to-notebooklm-cn/.DS_Store"
```

## 推送到 GitHub（推荐）

```bash
cd ~/.workbuddy/skills/anything-to-notebooklm-cn
git init
git add .
git commit -m "init: anything-to-notebooklm-cn v0.1.0"
git remote add origin https://github.com/<你>/anything-to-notebooklm-cn
git push -u origin main
```

## 提交到 ClawHub

1. 打开 ClawHub Skill 提交页
2. 选择「上传 zip」或「GitHub URL」
3. 填写元信息：

| 字段 | 内容 |
|---|---|
| 名称 | anything-to-notebooklm-cn |
| 一句话描述 | 把公众号/小宇宙/星球/财新/视频号一键丢进 NotebookLM 生成播客/PPT/思维导图 |
| 分类 | 内容生产 / 知识管理 / AI 自动化 |
| Tags | NotebookLM, 公众号, 播客, IMA, 飞书, 国内化 |
| 截图 | 见 assets/screenshots/（先准备 3-5 张）|
| 上游归属 | 必须勾选「基于上游开源项目改编」 |
| 上游链接 | https://github.com/joeseesun/qiaomu-anything-to-notebooklm |
| License | MIT |

## 描述文案模板（可直接用）

```
原版「anything-to-notebooklm」（4.1k stars）的 WorkBuddy 国内化适配版。

🎯 解决三大痛点：
1. WorkBuddy 路径/MCP 注册全适配，开箱即用
2. 付费墙策略国内重排，补 7+ 国内站点支持
3. 预置 5 大杀手场景模板：
   • 公众号深度分析 → IMA / 飞书
   • 小宇宙播客 → 飞书摘要
   • 知识星球 → 思维导图
   • 财新文章 → 通勤播客
   • 视频号 → 团队 PPT

🤝 与现有 Skill 联动：lark-master / ima-skill / feishu-md-cleaner

🙏 致谢上游 @joeseesun，本 Skill 仅做适配层和场景模板，核心抓取/上传逻辑保留在上游。
```

## 后续维护

- 上游有新版本：更新 README.md 的"上游版本"字段
- 用户反馈失败场景：补充到 troubleshooting.md
- 站点反爬升级导致策略失效：更新 paywall-priority.json

## 推广建议（可选）

- 在公众号 / 即刻 / X 发布"WorkBuddy 上跑通 NotebookLM 中文场景"案例
- 录一个 1 分钟 demo（公众号 → 播客一键转换）
- 加入 WorkBuddy / Skill 社区群，征集场景反馈
