# Skills 快速参考

## 目录结构

```
skills/
├── install.sh                          # 🔧 一键安装
├── uninstall.sh                        # 🗑️  卸载
├── validate.sh                         # ✅ 验证
├── package.json                        # 📦 元数据
├── README.md                           # 📖 完整文档
│
├── project-workflow/                   # 💼 仓库工作流
│   ├── SKILL.md
│   └── agents/openai.yaml
│
├── django-ninja-project-standard/      # 🐍 Django Ninja 标准
│   ├── SKILL.md
│   └── agents/openai.yaml
│
└── python-oop-standards/               # 🏗️  Python OOP 规范
    ├── SKILL.md
    ├── agents/openai.yaml
    └── examples/README.md              # 用户管理参考实现
```

## 快速命令

```bash
# 安装（自动检测平台）
bash install.sh

# 验证格式
bash validate.sh

# 卸载
bash uninstall.sh
```

## 支持的平台

| 平台 | 路径 | 格式 |
|------|------|------|
| Claude Code | `~/.claude/skills/` | 符号链接 |
| Cursor | `~/.cursor/rules/` | `.cursorrules` |
| Codex | `~/.openai/prompts/` | `.md` |

## Skills 使用

### Claude Code

```bash
/project-workflow
/django-ninja-project-standard
/python-oop-standards
```

### Cursor

在项目中自动生效，或在提示词中提及：
```
按照 project-workflow 标准完成任务
```

### Codex

在对话中引用：
```
请参考 ~/.openai/prompts/python-oop-standards.md 编写代码
```

## Skills 组合

- **通用项目**: `project-workflow`
- **Django 项目**: `project-workflow` + `django-ninja-project-standard`  
- **Python 项目**: `project-workflow` + `python-oop-standards`

## 添加新 Skill

1. 创建目录：`mkdir -p my-skill/{agents,examples}`
2. 编写 `SKILL.md`
3. 编写 `agents/openai.yaml`
4. 更新 `package.json`
5. 运行 `bash validate.sh`
6. 运行 `bash install.sh`

---

完整文档见 `README.md`
