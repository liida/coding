# AI 编程助手 Skills 集合

跨平台通用的 AI 编程助手技能集合，支持一键安装到 Claude Code、Cursor、OpenAI Codex 等工具。

## 🚀 快速开始

### 在线一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```
**自动完成：**
- ✅ 检测 AI 助手类型
- ✅ 克隆仓库
- ✅ 安装 skills
- ✅ 配置到对应工具

> 💡 **提示：** 将 `YOUR_USERNAME` 替换为你的 GitHub 用户名

### 手动安装

```bash
# 克隆仓库
git clone https://github.com/liida/coding.git
cd skills

# 自动检测并安装
bash install.sh

# 或手动选择平台
bash install.sh
# 1) Claude Code
# 2) Cursor  
# 3) Codex/OpenAI
```

### 验证安装

```bash
bash validate.sh
```

### 卸载

```bash
bash uninstall.sh
```

> 📖 **详细安装文档：** [INSTALL_GUIDE.md](INSTALL_GUIDE.md)

## 项目结构

```
skills/
├── install.sh                          # 一键安装脚本
├── uninstall.sh                        # 卸载脚本
├── validate.sh                         # 格式验证脚本
├── package.json                        # Skills 元数据配置
├── README.md                           # 本文档
│
├── project-workflow/                   # 仓库开发工作流
│   ├── SKILL.md                        # Skill 定义
│   └── agents/
│       └── openai.yaml                 # UI 元数据
│
├── django-ninja-project-standard/      # Django Ninja 项目标准
│   ├── SKILL.md
│   └── agents/
│       └── openai.yaml
│
└── python-oop-standards/               # Python OOP 编码规范
    ├── SKILL.md
    ├── agents/
    │   └── openai.yaml
    └── examples/                       # 参考实现
        └── README.md                   # 用户管理模块示例
```

## 可用 Skills

### 1. `project-workflow`

**仓库级开发任务工作流**

适用于任何项目的开发任务：
- 任务开始前读取项目上下文和记忆
- 理解现有实现、复用模式和命名风格
- 保持简单优先、精确修改、风险可控
- 完成后执行验证并更新项目记忆

**使用方式：**
- **Claude Code**: `/project-workflow` 或在项目根目录自动生效
- **Cursor**: 在 `.cursorrules` 中自动生效
- **Codex**: 引用 `~/.openai/prompts/project-workflow.md`

---

### 2. `django-ninja-project-standard`

**Django Ninja 后端项目标准**

专门针对 Django Ninja API 项目：
- 默认技术栈：Django + Django Ninja + Celery + Redis + PostgreSQL + Docker
- 规范目录结构：`backend/`、`config/`、`apps/`
- 固化 API 入口、健康检查、文档地址
- 适用于新建、改造或评审 Django 后端

**使用关系：**
- Django Ninja 项目同时使用 `project-workflow` 和此 skill
- 非 Django 项目不套用此标准

**使用方式：**
- **Claude Code**: `/django-ninja-project-standard`
- **Cursor**: 在项目根目录放置 `.cursorrules` 引用
- **Codex**: 引用 `~/.openai/prompts/django-ninja-project-standard.md`

---

### 3. `python-oop-standards`

**Python 面向对象编码规范**

强制类优先架构的 Python 编码规范：

**核心规则：**
- ✅ **禁止模块级 def 函数** — 除 `main()` 和 5 行内私有辅助函数
- ✅ **强制 dataclass/Pydantic** — 禁止用 dict 传递结构化数据
- ✅ **Repository 模式** — 数据访问必须封装
- ✅ **Service 模式** — 业务逻辑组织成服务类
- ✅ **依赖注入** — 通过 `__init__` 传递，禁止全局变量
- ✅ **ABC 接口** — 用抽象基类定义契约
- ✅ **完整类型注解** — Python 3.10+ 语法（`list[str]`, `int | None`）
- ✅ **组合优于继承** — 最多 2 层继承

**效果：**
- 自动将功能组织成职责清晰的类
- 生成企业级、可测试、可维护的代码
- 强制类型安全

**参考实现：**  
`python-oop-standards/examples/README.md` — 用户管理模块完整示例

**使用方式：**
- **Claude Code**: `/python-oop-standards` 或 "按照 Python OOP 标准编写"
- **Cursor**: 在 Python 项目根目录引用
- **Codex**: 引用 `~/.openai/prompts/python-oop-standards.md`

---

## 安装目标路径

不同平台的安装位置：

| 平台 | 安装路径 | 方式 | 格式 |
|------|---------|------|------|
| **Claude Code** | `~/.claude/skills/` | 符号链接 | 目录 |
| **Cursor** | `~/.cursor/rules/` | 复制 | `.cursorrules` |
| **Codex/OpenAI** | `~/.openai/prompts/` | 复制 | `.md` |

## Skill 开发规范

### 标准目录结构

```
your-skill-name/
├── SKILL.md              # 必需：Skill 核心定义
├── README.md             # 推荐：详细说明文档
├── agents/
│   └── openai.yaml       # 推荐：UI 元数据（显示名称、描述）
├── examples/             # 推荐：使用示例
│   └── ...
├── assets/               # 可选：模板文件
│   └── ...
├── scripts/              # 可选：辅助脚本
│   └── ...
└── references/           # 可选：参考资料
    └── ...
```

### SKILL.md 格式

```markdown
# Skill 名称

简短描述这个 skill 的作用。

## 触发条件

何时使用这个 skill。

## 核心规则

关键约束、流程、模式。

## 示例

实际使用示例。
```

### agents/openai.yaml 格式

```yaml
interface:
  display_name: "Skill 显示名称"
  short_description: "一句话描述"
  default_prompt: "默认提示词"
```

## 维护原则

- `SKILL.md` 保持简洁可执行，只放核心规则和流程
- 详细说明、示例、模板放在对应子目录
- 不保存密钥、令牌、密码等敏感信息
- 保持跨平台兼容性（纯文本格式）
- 使用清晰的触发条件，避免技能冲突

## 贡献新 Skill

1. 按照标准结构创建目录
2. 编写 `SKILL.md` 核心定义
3. 创建 `agents/openai.yaml` UI 元数据
4. 添加示例到 `examples/` 目录
5. 运行 `bash validate.sh` 验证格式
6. 更新 `package.json` 添加新 skill
7. 测试安装到各平台

## 常见问题

### 如何更新已安装的 skills？

重新运行 `bash install.sh`，对于 Claude Code 会提示是否覆盖符号链接。

### 支持哪些 AI 助手？

- **完全支持：** Claude Code、Cursor、OpenAI Codex
- **理论兼容：** 任何支持自定义 prompt/rules 的 AI 编程助手

### 如何在项目中使用？

**Claude Code:**  
```bash
# 在项目根目录
claude code
# 然后输入 skill 名称，如 /project-workflow
```

**Cursor:**  
Rules 文件自动加载，直接在对话中提及即可。

**Codex:**  
在对话中引用：
```
请按照 ~/.openai/prompts/python-oop-standards.md 的规范编写代码
```

### 可以混合使用多个 skills 吗？

可以。`project-workflow` 是通用基础工作流，可以和专项 skills 组合：
- Django 项目：`project-workflow` + `django-ninja-project-standard`
- Python 项目：`project-workflow` + `python-oop-standards`

### 安装脚本做了什么？

1. 检测当前 AI 助手类型
2. 读取 `package.json` 中的 skills 列表
3. 根据平台：
   - **Claude Code**: 在 `~/.claude/skills/` 创建符号链接
   - **Cursor**: 复制 `SKILL.md` 到 `~/.cursor/rules/*.cursorrules`
   - **Codex**: 复制 `SKILL.md` 到 `~/.openai/prompts/*.md`

### 如何验证 skills 是否正确安装？

```bash
# 验证格式
bash validate.sh

# 检查安装路径
# Claude Code
ls -la ~/.claude/skills/

# Cursor
ls -la ~/.cursor/rules/

# Codex
ls -la ~/.openai/prompts/
```

## License

MIT

---

**维护者**: jiangang  
**最后更新**: 2026-06-22
