#!/usr/bin/env bash
# Skills 在线一键安装脚本
# 使用方式: curl -fsSL https://raw.githubusercontent.com/USER/skills/main/bootstrap.sh | bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 配置
REPO_URL="${SKILLS_REPO_URL:-https://github.com/liida/coding.git}"
BRANCH="${SKILLS_BRANCH:-main}"
INSTALL_DIR="${SKILLS_INSTALL_DIR:-$HOME/.local/share/skills}"

echo "════════════════════════════════════════"
echo "  Skills 一键安装工具"
echo "════════════════════════════════════════"
echo ""

# 检查依赖
if ! command -v git &> /dev/null; then
    log_error "需要安装 git"
    exit 1
fi

# 检测 AI 助手
detect_ai_assistant() {
    if command -v claude &> /dev/null || [ -d "$HOME/.claude" ]; then
        echo "claude"
    elif [ -d "$HOME/.cursor" ]; then
        echo "cursor"
    elif command -v openai &> /dev/null || [ -d "$HOME/.openai" ]; then
        echo "codex"
    else
        echo "unknown"
    fi
}

ASSISTANT=$(detect_ai_assistant)

if [ "$ASSISTANT" = "unknown" ]; then
    log_warn "未检测到 AI 助手，请手动选择："
    echo "1) Claude Code"
    echo "2) Cursor"
    echo "3) Codex/OpenAI"
    read -p "请选择 (1-3): " choice
    case $choice in
        1) ASSISTANT="claude" ;;
        2) ASSISTANT="cursor" ;;
        3) ASSISTANT="codex" ;;
        *) log_error "无效选择"; exit 1 ;;
    esac
else
    log_info "自动检测到: $ASSISTANT"
fi

# 克隆或更新仓库
if [ -d "$INSTALL_DIR" ]; then
    log_info "更新现有 skills..."
    cd "$INSTALL_DIR"
    git pull origin "$BRANCH"
else
    log_info "克隆 skills 仓库到 $INSTALL_DIR"
    git clone --branch "$BRANCH" --depth 1 "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# 运行安装脚本
if [ -f "./install.sh" ]; then
    log_info "运行安装脚本..."
    bash ./install.sh
else
    log_error "找不到 install.sh"
    exit 1
fi

echo ""
log_info "安装完成！"
log_info ""
log_info "使用方式:"
case $ASSISTANT in
    claude)
        log_info "  /workflow"
        log_info "  /python-oop"
        log_info "  /django-ninja"
        ;;
    cursor)
        log_info "  在项目中自动生效"
        ;;
    codex)
        log_info "  引用 ~/.openai/prompts/*.md"
        ;;
esac

echo ""
log_info "仓库位置: $INSTALL_DIR"
log_info "更新命令: cd $INSTALL_DIR && git pull && bash install.sh"
