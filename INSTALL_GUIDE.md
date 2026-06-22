# 一键安装指南

## 🚀 快速安装

### 方式 1：在线一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

**说明：**
- 自动检测 AI 助手类型（Claude Code / Cursor / Codex）
- 自动克隆仓库到 `~/.local/share/skills`
- 自动运行安装脚本
- 支持更新已安装的 skills

### 方式 2：手动克隆后安装

```bash
# 克隆仓库
git clone https://github.com/liida/coding.git
cd skills

# 安装
bash install.sh
```

### 方式 3：下载压缩包安装

```bash
# 下载最新版本
wget https://github.com/liida/coding/archive/refs/heads/main.zip
unzip main.zip
cd coding-main

# 安装
bash install.sh
```

## 🔧 自定义安装

### 指定安装位置

```bash
export SKILLS_INSTALL_DIR="$HOME/my-skills"
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

### 指定分支/版本

```bash
export SKILLS_BRANCH="dev"
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

### 指定仓库地址

```bash
export SKILLS_REPO_URL="https://github.com/OTHER_USER/skills.git"
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

## 📝 安装后配置

### Claude Code

Skills 已安装到 `~/.claude/skills/`，直接使用：

```bash
/workflow
/python-oop
/django-ninja
```

### Cursor

Rules 已安装到 `~/.cursor/rules/`，在项目中自动生效。

### Codex/OpenAI

Prompts 已安装到 `~/.openai/prompts/`，在对话中引用：

```
请按照 ~/.openai/prompts/python-oop.md 编写代码
```

## 🔄 更新 Skills

### 在线安装的更新

```bash
cd ~/.local/share/skills
git pull
bash install.sh
```

或者重新运行 bootstrap：

```bash
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

### 手动安装的更新

```bash
cd /path/to/skills
git pull
bash install.sh
```

## 🗑️ 卸载

```bash
# 卸载 skills（保留源码）
cd /path/to/skills
bash uninstall.sh

# 完全删除（包括源码）
rm -rf ~/.local/share/skills
bash uninstall.sh
```

## ⚙️ 高级用法

### 静默安装（CI/CD）

```bash
export DEBIAN_FRONTEND=noninteractive
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash -s -- --silent
```

### 只安装特定 skills

编辑 `package.json`，只保留需要的 skills，然后：

```bash
bash install.sh
```

### 创建自己的 skills fork

```bash
# 1. Fork 仓库到你的 GitHub
# 2. 克隆你的 fork
git clone https://github.com/liida/coding.git

# 3. 添加你自己的 skills
mkdir -p skills/my-custom-skill
# ... 编辑 SKILL.md

# 4. 更新 package.json
# 添加新 skill 配置

# 5. 安装
bash install.sh
```

## 🌐 设置短链接（可选）

如果你有自己的域名，可以设置短链接：

### 使用 GitHub Pages

1. 在仓库设置中启用 GitHub Pages
2. 创建 `docs/install` 文件：
   ```bash
   #!/bin/bash
   curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
   ```
3. 使用：
   ```bash
   curl -fsSL https://liida.github.io/coding/install | bash
   ```

### 使用自定义域名

1. 配置 CNAME 指向 GitHub Pages
2. 使用：
   ```bash
   curl -fsSL https://skills.yourdomain.com/install | bash
   ```

## 🔒 安全注意事项

**审查脚本内容**

在运行任何 `curl | bash` 命令前，建议先查看脚本内容：

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/skills/main/bootstrap.sh
```

**使用特定版本**

```bash
# 使用 tag
export SKILLS_BRANCH="v1.0.0"
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash

# 使用 commit hash
export SKILLS_BRANCH="abc123def456"
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

**验证脚本签名（高级）**

```bash
# 下载脚本和签名
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/skills/main/bootstrap.sh -o bootstrap.sh
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/skills/main/bootstrap.sh.sig -o bootstrap.sh.sig

# 验证签名
gpg --verify bootstrap.sh.sig bootstrap.sh

# 运行
bash bootstrap.sh
```

## 🐛 故障排查

### 问题：未检测到 AI 助手

**解决：** 手动选择或设置环境变量

```bash
export SKILLS_TARGET="claude"
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

### 问题：权限错误

**解决：** 不要使用 sudo，确保有写入权限

```bash
# 检查权限
ls -la ~/.claude/skills/
ls -la ~/.cursor/rules/
```

### 问题：网络连接失败

**解决：** 使用镜像或手动下载

```bash
# 使用 Gitee 镜像
export SKILLS_REPO_URL="https://gitee.com/liida/coding.git"
curl -fsSL https://raw.githubusercontent.com/liida/coding/main/bootstrap.sh | bash
```

### 问题：Git 未安装

**解决：** 安装 git

```bash
# Ubuntu/Debian
sudo apt install git

# macOS
brew install git

# Windows (WSL)
sudo apt install git
```

## 📞 获取帮助

- 文档：[README.md](README.md)
- 问题反馈：[GitHub Issues](https://github.com/liida/coding/issues)
- 快速参考：[QUICKSTART.md](QUICKSTART.md)

---

