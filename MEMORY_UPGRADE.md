# Workflow 记忆机制升级说明

## 🎉 升级完成

`workflow` skill 的项目记忆机制已从**单一固定路径**升级为**多源动态检测**。

## 📊 改进对比

### Before（旧版本）

```markdown
- 优先读取 .ai/memory.md
- 不存在则跳过
```

**问题：**
- ❌ 只支持 `.ai/memory.md` 一种方式
- ❌ 不兼容 Claude Code 官方的 `CLAUDE.md`
- ❌ 不支持 Cursor 的 `.cursorrules`
- ❌ 无法适应不同工具和团队习惯

### After（新版本）

```markdown
按优先级检测并读取（找到第一个就停止）：
1. CLAUDE.md           # Claude Code 官方
2. .cursorrules        # Cursor 规则
3. .ai/memory.md       # 传统记忆
4. AGENTS.md           # 多 Agent 协作
5. .github/CLAUDE.md   # 团队共享规范
```

**优势：**
- ✅ 支持多种主流工具的配置格式
- ✅ 自动检测，无需手动配置
- ✅ 有优先级，避免冲突
- ✅ 兼容旧项目（仍支持 `.ai/memory.md`）

## 🎯 新增特性

### 1. 渐进式加载

根据任务复杂度，智能决定读取范围：

| 任务类型 | 读取内容 |
|---------|---------|
| **小任务** | 只读核心配置 |
| **中等任务** | 核心配置 + 编码约定 |
| **大型任务** | 核心配置 + 约定 + 架构文档 |

### 2. 结构化记忆支持

推荐使用分类目录组织大型项目记忆：

```
.ai/
├── memory.md          # 总览索引
├── architecture/      # 架构决策
├── conventions/       # 编码约定
├── deployment/        # 部署流程
└── troubleshooting/   # 故障排查
```

### 3. 智能更新目标

更新记忆时，自动选择合适的文件：
- 有 `CLAUDE.md` → 更新 `CLAUDE.md`
- 有 `.cursorrules` → 更新 `.cursorrules`
- 否则 → 更新 `.ai/memory.md`

## 📚 推荐配置

### 小项目（推荐）

```
项目根目录/
├── CLAUDE.md          # 全部配置在一个文件
└── README.md
```

### 中大型项目

```
项目根目录/
├── CLAUDE.md          # 核心索引
├── .ai/
│   ├── architecture/
│   ├── conventions/
│   ├── deployment/
│   └── troubleshooting/
└── README.md
```

### 多工具团队

```
项目根目录/
├── CLAUDE.md          # Claude Code
├── .cursorrules       # Cursor
├── .ai/memory.md      # 共享备用
└── README.md
```

## 🔄 迁移指南

### 旧项目如何升级？

**选项 1：保持现状（推荐）**
- 不需要任何改动
- workflow 会自动检测 `.ai/memory.md`
- 继续正常工作

**选项 2：升级到 CLAUDE.md**
```bash
# 1. 将内容迁移到 CLAUDE.md
cp .ai/memory.md CLAUDE.md

# 2. 保留旧文件作为备用（可选）
# .ai/memory.md 仍然会被识别
```

**选项 3：结构化记忆**
```bash
# 适合大项目
mkdir -p .ai/{architecture,conventions,deployment,troubleshooting}

# 将 memory.md 拆分到对应目录
# 创建 CLAUDE.md 作为总览索引
```

## ⚙️ 配置文件优先级说明

**为什么 CLAUDE.md 优先级最高？**
- Claude Code 官方支持
- 语义明确（专门给 Claude 的指令）
- 团队协作友好（一看就知道用途）

**为什么支持 .cursorrules？**
- 兼容 Cursor 用户
- 团队可能同时使用多种工具
- 自动检测，无需手动配置

**为什么保留 .ai/memory.md？**
- 向后兼容
- 很多项目已经在使用
- 作为通用备选方案

## 📝 最佳实践

### 1. 新项目建议

```markdown
# CLAUDE.md

## 技术栈
- Python 3.11 + Django 5.0 + Django Ninja
- PostgreSQL 15 + Redis 7

## 目录结构
- apps/ - 业务应用
- config/ - 配置

## 编码规范
- 遵循 python-oop skill
- Repository + Service 模式

## 启动命令
docker-compose up
```

### 2. 大项目建议

在 `CLAUDE.md` 中创建索引：

```markdown
# CLAUDE.md

详细文档见：
- [架构决策](.ai/architecture/)
- [编码约定](.ai/conventions/)
- [部署流程](.ai/deployment/)
```

### 3. 团队协作建议

```markdown
# CLAUDE.md (团队共享)
基础规范和索引

# .cursorrules (可选)
Cursor 特定配置

# .ai/memory.md (备用)
工具无关的通用记忆
```

## 🎯 下一步

1. **无需任何操作** - 旧项目继续正常工作
2. **新项目** - 创建 `CLAUDE.md` 而不是 `.ai/memory.md`
3. **大项目** - 考虑使用结构化目录
4. **多工具团队** - 可以同时维护多个配置文件

---

更新时间: 2026-06-22
影响范围: workflow skill
向后兼容: ✅ 是
