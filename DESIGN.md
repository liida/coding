# Skills 组合设计方案

## 问题分析

当前三个 skills 存在职责重叠：
- `project-workflow` 定义工作流 + 提到"理解现有实现"
- `python-oop-standards` 定义编码规范
- `django-ninja-project-standard` 定义框架规范 + 重复了工作流要求

## 优化方案：清晰分层

### 架构设计

```
                   ┌─────────────────┐
                   │  用户请求任务     │
                   └────────┬────────┘
                            ↓
           ┌────────────────────────────────┐
           │   project-workflow (编排层)     │
           │   - 读取上下文、制定计划          │
           │   - 自动检测项目类型              │
           │   - 委托给编码规范 + 框架规范      │
           │   - 验证、更新记忆                │
           └────────┬───────────────┬────────┘
                    ↓               ↓
         ┌──────────────────┐   ┌──────────────────┐
         │  语言规范层       │   │  框架规范层       │
         │  (自动加载)       │   │  (条件加载)       │
         ├──────────────────┤   ├──────────────────┤
         │ python-oop-      │   │ django-ninja-    │
         │ standards        │   │ project-standard │
         │                  │   │                  │
         │ - 类优先架构      │   │ - 目录结构        │
         │ - Repository     │   │ - API 规范        │
         │ - Service 模式    │   │ - Docker 配置     │
         └──────────────────┘   └──────────────────┘
```

### 职责划分

#### 1. project-workflow (唯一入口)

**职责：**
- 工作流编排
- 自动检测项目类型
- 委托给对应的规范 skills
- 不直接定义编码规范

**改动：**
```markdown
## 自动委托规则

检测到项目类型后，自动加载对应的编码规范：

1. **检测语言**
   - 发现 `.py` 文件 → 加载 `python-oop-standards`
   - 发现 `.ts` 文件 → 加载 `typescript-standards` (待实现)

2. **检测框架** (可选叠加)
   - 发现 `django` + `ninja` → 加载 `django-ninja-project-standard`
   - 发现 `fastapi` → 加载 `fastapi-standards` (待实现)

用户也可以手动指定：
- `/project-workflow python` → 只用 Python 规范
- `/project-workflow django` → Python + Django Ninja 规范
```

#### 2. python-oop-standards (纯编码规范)

**职责：**
- **仅**定义如何写 Python 代码
- 不涉及项目结构、工作流

**改动：**
```markdown
---
name: python-oop-standards
description: Python 编码规范。定义类优先架构、Repository/Service 模式、依赖注入等规则。由 project-workflow 自动调用或手动触发。
metadata:
  layer: coding-standards
  language: python
  dependencies: []
---

## 触发方式

1. **自动触发**：`project-workflow` 检测到 Python 项目时自动加载
2. **手动触发**：`/python-oop-standards` 或在提示词中提及

## 适用范围

所有 Python 代码，包括：
- Web 框架（Django、FastAPI、Flask）
- CLI 工具
- 数据处理脚本

## 本 skill 不涉及

❌ 项目目录结构（由框架 skill 定义）
❌ 工作流程（由 project-workflow 定义）
❌ 框架特定规范（由框架 skill 定义）
```

#### 3. django-ninja-project-standard (框架增强)

**职责：**
- **仅**定义 Django Ninja 特定内容
- 明确依赖 `python-oop-standards`

**改动：**
```markdown
---
name: django-ninja-project-standard
description: Django Ninja 框架规范。定义目录结构、API 规范、Docker 配置。依赖 python-oop-standards 提供编码规范。
metadata:
  layer: framework-standards
  framework: django-ninja
  dependencies: 
    - python-oop-standards
---

## 依赖关系

本 skill **依赖** 以下 skills：
- ✅ `python-oop-standards` — 编码规范
- ✅ `project-workflow` — 工作流（可选）

## 本 skill 专注于

✅ Django Ninja 目录结构（`apps/`、`config/`）
✅ API 响应格式、路由规范
✅ Docker Compose 服务配置
✅ 环境变量、数据库配置

## 本 skill 不重复定义

❌ Python 编码规范 → 委托给 `python-oop-standards`
❌ 工作流程 → 委托给 `project-workflow`

## 使用示例

```python
# ✅ 编码规范（来自 python-oop-standards）
class UserRepository:  # 类优先架构
    def __init__(self, db: Database):  # 依赖注入
        self._db = db

# ✅ Django Ninja 规范（来自本 skill）
# 文件位置：apps/users/repositories.py  ← 目录结构
# API 路由：/api/users/                  ← 路由规范
```
```

### 实现：package.json 声明依赖

```json
{
  "skills": {
    "project-workflow": {
      "layer": "orchestration",
      "dependencies": [],
      "auto_load": ["python-oop-standards", "django-ninja-project-standard"]
    },
    "python-oop-standards": {
      "layer": "coding-standards",
      "language": "python",
      "dependencies": []
    },
    "django-ninja-project-standard": {
      "layer": "framework-standards",
      "framework": "django-ninja",
      "dependencies": ["python-oop-standards"]
    }
  }
}
```

## 用户体验

### 场景 1：纯 Python 项目

```bash
用户: "写一个用户管理模块"

自动加载:
1. project-workflow (检测到 Python)
2. → python-oop-standards (编码规范)

结果: 用 OOP 方式组织代码
```

### 场景 2：Django 项目

```bash
用户: "创建 Django Ninja 项目"

自动加载:
1. project-workflow (检测到 Django)
2. → python-oop-standards (编码规范)
3. → django-ninja-project-standard (目录结构)

结果: Django 标准结构 + OOP 编码
```

### 场景 3：明确指定

```bash
用户: "/project-workflow django"

手动加载:
1. project-workflow
2. → python-oop-standards
3. → django-ninja-project-standard
```

## 优势

✅ **职责清晰** — 每个 skill 只做一件事
✅ **无重复** — 编码规范只在 python-oop-standards 定义
✅ **自动组合** — project-workflow 智能委托
✅ **可扩展** — 容易添加新语言/框架
✅ **用户友好** — 只需调用 project-workflow

## 建议的改造步骤

1. **修改 project-workflow/SKILL.md**
   - 添加"自动委托规则"章节
   - 移除编码规范相关内容
   - 专注于工作流编排

2. **修改 python-oop-standards/SKILL.md**
   - 添加 frontmatter metadata: `layer: coding-standards`
   - 明确"本 skill 不涉及"部分
   - 移除工作流相关内容

3. **修改 django-ninja-project-standard/SKILL.md**
   - 添加 frontmatter metadata: `dependencies: [python-oop-standards]`
   - 明确"编码规范委托给 python-oop-standards"
   - 只保留 Django 特定内容

4. **更新 package.json**
   - 添加 dependencies 字段
   - 添加 layer 字段

5. **更新安装脚本**
   - 检查依赖关系
   - 自动安装依赖的 skills

---

你觉得这个设计怎么样？需要我开始改造吗？
