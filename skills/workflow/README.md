# Project Workflow - 使用示例

这是 `project-workflow` skill 的使用示例和最佳实践。

## 何时使用

✅ **应该使用的场景：**
- 多文件修改、重构、架构调整
- 修复 bug 需要理解现有实现
- 添加新功能需要遵循现有模式
- 项目初始化、依赖升级、配置变更
- 团队协作项目，需要统一工作流

❌ **可以不用的场景：**
- 纯问答、概念解释
- 一次性脚本，无需理解项目上下文
- 单文件的简单修改

## 典型工作流

### 场景 1：修复 Bug

```
用户: "修复登录失败的问题"

AI 执行流程:
1. 读取 .ai/memory.md（如果存在）
2. 找到登录相关的代码文件
3. 理解现有实现和错误处理模式
4. 定位问题并修复
5. 运行相关测试验证
6. 更新 memory（如果发现了重要模式）
```

### 场景 2：添加新功能

```
用户: "添加用户注册功能"

AI 执行流程:
1. 读取项目记忆和 AGENTS.md
2. 查看现有的用户管理代码
3. 理解项目的：
   - 目录结构（controllers/services/models）
   - 命名规范（camelCase vs snake_case）
   - 验证方式（class validator vs joi）
   - 错误处理模式
4. 按照现有模式实现注册功能
5. 编写测试（如果项目有测试）
6. 运行测试验证
7. 更新 memory（如果定义了新模式）
```

### 场景 3：重构代码

```
用户: "重构 UserService，提取公共逻辑"

AI 执行流程:
1. 读取项目上下文
2. 理解现有的 UserService 实现
3. 识别可复用的模式
4. 制定轻量重构计划（避免过度设计）
5. 执行精确修改
6. 运行完整测试套件
7. 更新 memory（记录重构后的模式）
```

## 项目记忆 (.ai/memory.md) 示例

### 好的记忆

```markdown
## 技术栈
- 后端：Django 5.0 + Django Ninja
- 数据库：PostgreSQL 15
- 缓存：Redis 7

## 目录结构
- `apps/*/services.py` - 业务逻辑
- `apps/*/repositories.py` - 数据访问
- `apps/*/schemas.py` - Pydantic 模型

## 编码约定
- 所有 API 返回统一格式：`{"success": bool, "data": any, "error": str}`
- 使用 Repository 模式封装数据库操作
- 服务层使用依赖注入，通过 `get_service()` 获取实例

## 测试策略
- 单元测试覆盖 services 和 repositories
- 集成测试使用 pytest fixtures
- 运行测试：`pytest -v`
```

### 不好的记忆（过于琐碎）

```markdown
## 最近改动
- 2026-06-20: 修复了登录 bug
- 2026-06-19: 添加了用户注册
- 2026-06-18: 更新了依赖

## TODO
- [ ] 优化性能
- [ ] 添加更多测试
```

## 验证策略

### 前端项目

```bash
# 类型检查
npm run type-check

# 测试
npm test

# 构建验证
npm run build
```

### 后端项目

```bash
# Python
pytest -v
mypy .

# Node.js
npm test
npm run lint
```

### 全栈项目

```bash
# 运行开发服务器
docker-compose up -d

# 运行测试
docker-compose exec backend pytest
docker-compose exec frontend npm test
```

## 与其他 Skills 的组合

### + Django Ninja Standard

```
Django 项目开发流程:
1. project-workflow 读取项目上下文
2. django-ninja-project-standard 确定目录结构
3. python-oop-standards 编写业务逻辑
4. project-workflow 验证和更新记忆
```

### + Python OOP Standards

```
Python 项目开发流程:
1. project-workflow 理解现有代码
2. python-oop-standards 按 OOP 规范编写
3. project-workflow 运行测试验证
```

## 常见问题

### Q: 每次都要手动指定这个 skill 吗？

A: 不需要。如果在项目根目录的 `.claude/` 配置中设置，Claude Code 会自动应用。

### Q: 项目记忆应该记录什么？

A: 记录**长期有价值**的信息：
- ✅ 技术栈、目录结构、编码约定
- ✅ 重要的设计决策和原因
- ✅ 测试策略、部署流程
- ❌ 临时 TODO、最近改动日志
- ❌ 具体代码实现（应该在代码中体现）

### Q: 如何避免过度设计？

A: 
- 只解决当前问题，不预设未来需求
- 保持与现有代码风格一致
- 三个相似场景出现前不提前抽象
- 优先简单直接的实现

---

更多信息见 `SKILL.md`
