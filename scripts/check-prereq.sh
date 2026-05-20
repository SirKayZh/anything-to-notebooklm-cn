#!/usr/bin/env bash
#
# anything-to-notebooklm-cn 前置依赖检查
# 用法: bash check-prereq.sh
#
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

ok()   { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
fail() { echo -e "${RED}❌ $1${NC}"; }

echo "anything-to-notebooklm-cn 环境检查"
echo "===================================="

# 1. Python
if command -v python3 >/dev/null 2>&1; then
  PYV=$(python3 --version | awk '{print $2}')
  ok "Python $PYV"
else
  fail "未找到 python3"; exit 1
fi

# 2. Node
if command -v node >/dev/null 2>&1; then
  NODEV=$(node --version)
  ok "Node $NODEV"
else
  warn "未找到 node（部分场景可能依赖）"
fi

# 3. 上游 Skill
UPSTREAM="$HOME/.workbuddy/skills/qiaomu-anything-to-notebooklm"
if [[ -d "$UPSTREAM" ]]; then
  ok "上游 Skill 已 clone: $UPSTREAM"
else
  fail "上游未安装。请执行："
  echo "    cd ~/.workbuddy/skills/ && git clone https://github.com/joeseesun/qiaomu-anything-to-notebooklm"
fi

# 4. 上游 install.sh 是否跑过（看 venv / requirements 标志）
if [[ -f "$UPSTREAM/check_env.py" ]]; then
  ok "上游 check_env.py 存在，可手动跑：python3 $UPSTREAM/check_env.py"
fi

# 5. mcp.json 注册
MCP_JSON="$HOME/.workbuddy/mcp.json"
if [[ -f "$MCP_JSON" ]]; then
  if grep -q "wexin-read" "$MCP_JSON"; then
    ok "wexin-read MCP 已注册"
  else
    warn "wexin-read MCP 未注册到 ~/.workbuddy/mcp.json"
  fi
  if grep -q "feishu-read" "$MCP_JSON"; then
    ok "feishu-read MCP 已注册"
  else
    warn "feishu-read MCP 未注册"
  fi
else
  warn "$MCP_JSON 不存在"
fi

# 6. 网络
echo ""
echo "网络检查（按 Ctrl+C 跳过）"
echo "------------------------------"
if curl -s -m 5 -o /dev/null -w "%{http_code}" https://www.google.com | grep -q "200\|301\|302"; then
  ok "Google 可达"
else
  warn "Google 不可达 → 需配代理，见 china-network.md"
fi

if curl -s -m 5 -o /dev/null -w "%{http_code}" https://notebooklm.google.com | grep -q "200\|301\|302"; then
  ok "NotebookLM 可达"
else
  warn "NotebookLM 不可达"
fi

if curl -s -m 5 -o /dev/null -w "%{http_code}" https://mp.weixin.qq.com | grep -q "200\|301\|302"; then
  ok "微信公众号可达"
else
  warn "微信公众号不可达（可能代理把国内流量也劫持了）"
fi

# 7. 可选：Get笔记 API
if [[ -n "$GETNOTE_API_KEY" ]]; then
  ok "GETNOTE_API_KEY 已配置（播客转写场景可用）"
else
  warn "GETNOTE_API_KEY 未设置（仅播客/视频转写需要）"
fi

echo ""
echo "===================================="
echo "检查完成。⚠️ 提醒不影响使用，❌ 必须修复。"
