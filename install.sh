#!/usr/bin/env bash
# Skills 一键安装脚本
# 支持 Claude Code, OpenAI Codex, Cursor 等主流 AI 编程助手

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检测 AI 助手类型
detect_ai_assistant() {
    local assistant=""

    # 检测 Claude Code
    if command -v claude &> /dev/null || [ -d "$HOME/.claude" ]; then
        assistant="claude"
    # 检测 Cursor
    elif [ -d "$HOME/.cursor" ]; then
        assistant="cursor"
    # 检测 Codex (通过 OpenAI CLI)
    elif command -v openai &> /dev/null || [ -d "$HOME/.openai" ]; then
        assistant="codex"
    fi

    echo "$assistant"
}

# 安装到 Claude Code
install_to_claude() {
    log_info "检测到 Claude Code，开始安装..."

    local claude_skills_dir="$HOME/.claude/skills"
    mkdir -p "$claude_skills_dir"

    # 复制每个 skill
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [ -f "$skill_dir/SKILL.md" ]; then
            local skill_name=$(basename "$skill_dir")
            log_info "安装 skill: $skill_name"

            # 创建符号链接或复制
            if [ -L "$claude_skills_dir/$skill_name" ]; then
                log_warn "  已存在符号链接，跳过"
            elif [ -d "$claude_skills_dir/$skill_name" ]; then
                log_warn "  目录已存在，是否覆盖？ (y/n)"
                read -r response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    rm -rf "$claude_skills_dir/$skill_name"
                    ln -s "$skill_dir" "$claude_skills_dir/$skill_name"
                    log_info "  ✓ 已更新"
                fi
            else
                ln -s "$skill_dir" "$claude_skills_dir/$skill_name"
                log_info "  ✓ 已安装"
            fi
        fi
    done

    log_info "Claude Code skills 安装完成！"
    log_info "使用方式: 在 Claude Code 中直接调用 skill 名称"
}

# 安装到 Cursor
install_to_cursor() {
    log_info "检测到 Cursor，开始安装..."

    local cursor_rules_dir="$HOME/.cursor/rules"
    mkdir -p "$cursor_rules_dir"

    # Cursor 使用 .cursorrules 文件
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [ -f "$skill_dir/SKILL.md" ]; then
            local skill_name=$(basename "$skill_dir")
            log_info "转换 skill: $skill_name"

            # 将 SKILL.md 转换为 .cursorrules 格式
            local rule_file="$cursor_rules_dir/${skill_name}.cursorrules"
            cp "$skill_dir/SKILL.md" "$rule_file"
            log_info "  ✓ 已安装到 $rule_file"
        fi
    done

    log_info "Cursor rules 安装完成！"
}

# 安装到 Codex/OpenAI
install_to_codex() {
    log_info "检测到 Codex/OpenAI，开始安装..."

    local openai_prompts_dir="$HOME/.openai/prompts"
    mkdir -p "$openai_prompts_dir"

    # 为每个 skill 创建 prompt 文件
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [ -f "$skill_dir/SKILL.md" ]; then
            local skill_name=$(basename "$skill_dir")
            log_info "导出 skill: $skill_name"

            local prompt_file="$openai_prompts_dir/${skill_name}.md"
            cp "$skill_dir/SKILL.md" "$prompt_file"
            log_info "  ✓ 已导出到 $prompt_file"
        fi
    done

    log_info "OpenAI prompts 安装完成！"
    log_info "使用方式: 在对话中引用对应的 prompt 文件"
}

# 通用安装（创建本地 skills 配置文件）
install_generic() {
    log_info "创建通用 skills 配置..."

    local config_file="$SKILLS_DIR/skills.json"

    cat > "$config_file" <<EOF
{
  "version": "1.0",
  "skills": [
EOF

    local first=true
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [ -f "$skill_dir/SKILL.md" ]; then
            local skill_name=$(basename "$skill_dir")
            local description=$(grep -m 1 "^# " "$skill_dir/SKILL.md" | sed 's/^# //')

            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$config_file"
            fi

            cat >> "$config_file" <<EOF
    {
      "name": "$skill_name",
      "description": "$description",
      "path": "$skill_dir",
      "file": "$skill_dir/SKILL.md"
    }
EOF
        fi
    done

    cat >> "$config_file" <<EOF

  ]
}
EOF

    log_info "已创建配置文件: $config_file"
}

# 主函数
main() {
    echo "================================"
    echo "  Skills 一键安装工具"
    echo "================================"
    echo ""

    local assistant=$(detect_ai_assistant)

    if [ -z "$assistant" ]; then
        log_warn "未自动检测到 AI 助手，请选择："
        echo "1) Claude Code"
        echo "2) Cursor"
        echo "3) Codex/OpenAI"
        echo "4) 通用安装（仅生成配置）"
        read -p "请选择 (1-4): " choice

        case $choice in
            1) assistant="claude" ;;
            2) assistant="cursor" ;;
            3) assistant="codex" ;;
            4) assistant="generic" ;;
            *) log_error "无效选择"; exit 1 ;;
        esac
    else
        log_info "自动检测到: $assistant"
    fi

    case $assistant in
        claude)
            install_to_claude
            ;;
        cursor)
            install_to_cursor
            ;;
        codex)
            install_to_codex
            ;;
        generic)
            install_generic
            ;;
        *)
            log_error "未知的 AI 助手类型"
            exit 1
            ;;
    esac

    echo ""
    log_info "安装完成！"
}

# 运行
main "$@"
