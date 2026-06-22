# Skills 快速参考

## 目录结构

```
skills/
├── bootstrap.sh                 # 🔧 在线一键安装
├── install.sh                   # 🔧 本地安装
├── uninstall.sh                 # 🗑️  卸载
├── validate.sh                  # ✅ 验证
├── package.json                 # 📦 元数据
├── README.md                    # 📖 完整文档
│
└── skills/                      # Skills 统一目录
    ├── workflow/                # 💼 工作流编排器
    │   ├── SKILL.md
    │   ├── README.md
    │   ├── agents/openai.yaml
    │   └── examples/
    │
    ├── python-oop/              # 🏗️  Python OOP 规范
    │   ├── SKILL.md
    │   ├── agents/openai.yaml
    │   └── examples/README.md
    │
    └── django-ninja/            # 🐍 Django Ninja 规范
        ├── SKILL.md
        ├── README.md
        ├── agents/openai.yaml
        └── examples/
```

## 快速命令

```bash
# 在线一键安装（推荐）
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash

# 本地安装（自动检测平台）
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
/workflow
/python-oop
/django-ninja
```

### Cursor

在项目中自动生效，或在提示词中提及：
```
按照 workflow 标准完成任务
```

### Codex

在对话中引用：
```
请参考 ~/.openai/prompts/python-oop.md 编写代码
```

## Skills 组合

- **通用项目**: `workflow`
- **Python 项目**: `workflow`（自动加载 `python-oop`）
- **Django 项目**: `workflow`（自动加载 `python-oop` + `django-ninja`）

## 添加新 Skill

1. 创建目录：`mkdir -p skills/my-skill/{agents,examples}`
2. 编写 `SKILL.md`
3. 编写 `agents/openai.yaml`
4. 更新 `package.json`
5. 运行 `bash validate.sh`
6. 运行 `bash install.sh`

---

完整文档见 `README.md`
