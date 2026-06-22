#!/usr/bin/env bash
# Skills 验证脚本 - 检查 skills 格式和完整性

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
warnings=0

log_pass() { echo -e "${GREEN}✓${NC} $1"; }
log_fail() { echo -e "${RED}✗${NC} $1"; ((errors++)); }
log_warn() { echo -e "${YELLOW}!${NC} $1"; ((warnings++)); }

validate_skill_structure() {
    local skill_dir=$1
    local skill_name=$(basename "$skill_dir")

    echo ""
    echo "验证 skill: $skill_name"
    echo "----------------------------------------"

    # 检查 SKILL.md 文件
    if [ -f "$skill_dir/SKILL.md" ]; then
        log_pass "SKILL.md 存在"

        # 检查必要的章节
        if grep -q "^# " "$skill_dir/SKILL.md"; then
            log_pass "包含标题"
        else
            log_fail "缺少标题（# 开头的行）"
        fi

        # 检查文件不为空
        if [ -s "$skill_dir/SKILL.md" ]; then
            log_pass "文件内容非空"
        else
            log_fail "SKILL.md 文件为空"
        fi
    else
        log_fail "SKILL.md 不存在"
        return
    fi

    # 检查 agents/openai.yaml (可选)
    if [ -f "$skill_dir/agents/openai.yaml" ]; then
        log_pass "agents/openai.yaml 存在"

        # 验证 YAML 格式
        if command -v yq &> /dev/null; then
            if yq eval '.' "$skill_dir/agents/openai.yaml" &> /dev/null; then
                log_pass "YAML 格式有效"
            else
                log_fail "YAML 格式无效"
            fi

            # 检查必要字段
            if yq eval '.interface.display_name' "$skill_dir/agents/openai.yaml" &> /dev/null; then
                log_pass "包含 display_name"
            else
                log_warn "缺少 display_name"
            fi
        else
            log_warn "未安装 yq，跳过 YAML 验证"
        fi
    else
        log_warn "agents/openai.yaml 不存在（可选）"
    fi

    # 检查其他推荐文件
    [ -f "$skill_dir/README.md" ] && log_pass "包含 README.md" || log_warn "建议添加 README.md"
    [ -d "$skill_dir/examples" ] && log_pass "包含示例目录" || log_warn "建议添加 examples 目录"
}

validate_package_json() {
    echo ""
    echo "验证 package.json"
    echo "----------------------------------------"

    if [ ! -f "$SCRIPT_DIR/package.json" ]; then
        log_fail "package.json 不存在"
        return
    fi

    log_pass "package.json 存在"

    # 验证 JSON 格式
    if command -v jq &> /dev/null; then
        if jq empty "$SCRIPT_DIR/package.json" 2>/dev/null; then
            log_pass "JSON 格式有效"
        else
            log_fail "JSON 格式无效"
            return
        fi

        # 检查必要字段
        [ "$(jq -r '.name' package.json)" != "null" ] && log_pass "包含 name" || log_fail "缺少 name"
        [ "$(jq -r '.version' package.json)" != "null" ] && log_pass "包含 version" || log_fail "缺少 version"
        [ "$(jq -r '.skills' package.json)" != "null" ] && log_pass "包含 skills" || log_fail "缺少 skills"
    else
        log_warn "未安装 jq，跳过 JSON 验证"
    fi
}

main() {
    echo "================================"
    echo "  Skills 验证工具"
    echo "================================"

    # 验证 package.json
    validate_package_json

    # 验证每个 skill
    if [ -d "$SCRIPT_DIR/skills" ]; then
        for skill_dir in "$SCRIPT_DIR/skills"/*/; do
            if [ -f "$skill_dir/SKILL.md" ]; then
                validate_skill_structure "$skill_dir"
            fi
        done
    else
        log_warn "skills/ 目录不存在"
    fi

    # 总结
    echo ""
    echo "================================"
    echo "  验证结果"
    echo "================================"

    if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
        echo -e "${GREEN}✓ 所有检查通过！${NC}"
        exit 0
    elif [ $errors -eq 0 ]; then
        echo -e "${YELLOW}! 有 $warnings 个警告${NC}"
        exit 0
    else
        echo -e "${RED}✗ 发现 $errors 个错误，$warnings 个警告${NC}"
        exit 1
    fi
}

main "$@"
