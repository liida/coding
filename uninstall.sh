#!/usr/bin/env bash
# Skills 卸载脚本

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 卸载 Claude Code skills
uninstall_from_claude() {
    log_info "从 Claude Code 卸载 skills..."

    local claude_skills_dir="$HOME/.claude/skills"

    if [ ! -d "$claude_skills_dir" ]; then
        log_warn "Claude skills 目录不存在"
        return
    fi

    # 读取 package.json 中的 skills
    if [ -f "package.json" ]; then
        for skill_name in $(jq -r '.skills | keys[]' package.json 2>/dev/null); do
            local skill_path="$claude_skills_dir/$skill_name"
            if [ -L "$skill_path" ] || [ -d "$skill_path" ]; then
                rm -rf "$skill_path"
                log_info "  ✓ 已移除: $skill_name"
            fi
        done
    fi

    log_info "Claude Code 卸载完成"
}

# 卸载 Cursor rules
uninstall_from_cursor() {
    log_info "从 Cursor 卸载 rules..."

    local cursor_rules_dir="$HOME/.cursor/rules"

    if [ ! -d "$cursor_rules_dir" ]; then
        log_warn "Cursor rules 目录不存在"
        return
    fi

    if [ -f "package.json" ]; then
        for skill_name in $(jq -r '.skills | keys[]' package.json 2>/dev/null); do
            local rule_file="$cursor_rules_dir/${skill_name}.cursorrules"
            if [ -f "$rule_file" ]; then
                rm -f "$rule_file"
                log_info "  ✓ 已移除: $skill_name"
            fi
        done
    fi

    log_info "Cursor 卸载完成"
}

# 卸载 Codex prompts
uninstall_from_codex() {
    log_info "从 Codex/OpenAI 卸载 prompts..."

    local openai_prompts_dir="$HOME/.openai/prompts"

    if [ ! -d "$openai_prompts_dir" ]; then
        log_warn "OpenAI prompts 目录不存在"
        return
    fi

    if [ -f "package.json" ]; then
        for skill_name in $(jq -r '.skills | keys[]' package.json 2>/dev/null); do
            local prompt_file="$openai_prompts_dir/${skill_name}.md"
            if [ -f "$prompt_file" ]; then
                rm -f "$prompt_file"
                log_info "  ✓ 已移除: $skill_name"
            fi
        done
    fi

    log_info "Codex/OpenAI 卸载完成"
}

main() {
    echo "================================"
    echo "  Skills 卸载工具"
    echo "================================"
    echo ""

    echo "请选择要卸载的平台："
    echo "1) Claude Code"
    echo "2) Cursor"
    echo "3) Codex/OpenAI"
    echo "4) 全部"
    read -p "请选择 (1-4): " choice

    case $choice in
        1) uninstall_from_claude ;;
        2) uninstall_from_cursor ;;
        3) uninstall_from_codex ;;
        4)
            uninstall_from_claude
            uninstall_from_cursor
            uninstall_from_codex
            ;;
        *) log_error "无效选择"; exit 1 ;;
    esac

    echo ""
    log_info "卸载完成！"
}

main "$@"
