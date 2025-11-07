# OpenContext7

[![Nim](https://img.shields.io/badge/Nim-2.0%2B-blue)](https://nim-lang.org/)
[![MCP](https://img.shields.io/badge/MCP-Compatible-green)](https://modelcontextprotocol.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

OpenContext7 是一个本地部署的 MCP（模型上下文协议）服务器，用于管理和提供私有/内部库的文档。它为基于云的文档服务提供了一个安全的自托管替代方案，非常适合需要保持专有库文档内部化的组织。

👉 想阅读英文版？请访问 [English README](README.md)。

## 📑 目录

- [🧭 项目概述](#-项目概述)
- [🚀 功能特性](#-功能特性)
- [📋 系统要求](#-系统要求)
- [🛠️ 安装](#%EF%B8%8F-安装)
- [🚀 快速开始](#-快速开始)
- [📖 使用指南](#-使用指南)
- [🔁 功能详解](#-功能详解)
- [📦 项目结构分析](#-项目结构分析)
- [🛠 MCP 三大工具解析](#-mcp-三大工具解析)
- [🌐 MCP 传输协议详解](#-mcp-传输协议详解)
- [⚙️ 配置](#-配置)
- [🏗️ 架构](#-架构)
- [🔧 开发](#-开发)
- [🔒 安全注意事项](#-安全注意事项)
- [📚 典型场景](#-典型场景)
- [🤝 参与贡献](#-参与贡献)
- [📄 许可协议](#-许可协议)
- [🆚 OpenContext7 vs Context7 SaaS](#-opencontext7-vs-context7-saas)
- [🚀 Roadmap](#-roadmap)

## 🧭 项目概述

OpenContext7 将每个库以结构化 JSON 存储，并记录三级标题、带语言标签的代码段以及主题匹配索引。服务器兼容 MCP 工具、命令行与 HTTP/SSE 传输，可在完全内网环境中为 LLM 提供专有文档。

## 🚀 功能特性

- **私有库管理**：注册和管理内部库文档，内置三级标题与代码段提取
- **知识感知检索**：`get_library_docs` 支持主题词优先级及文字/结构/语义三种匹配算法
- **代码段统计**：每个库自动统计代码样例数量，`opencontext7 list` 可直接查看
- **Inspector 风格 Web UI**：可选浏览器界面（借鉴 MCP Inspector），为每个 MCP 工具提供按钮、支持 Bearer Token、实时展示返回结果
- **MCP 协议支持**：兼容 Claude Desktop、Cursor 和其他 MCP 客户端
- **Git 自动同步**：跟踪远程仓库并在拉取后自动刷新库文档
- **模糊检索**：基于相似度的排序策略，容错拼写错误并展示匹配原因
- **版本管理**：支持同一库的多个版本
- **基于文件的存储**：简单的 JSON 存储系统，无外部依赖
- **CLI 界面**：用于轻松库管理的命令行工具
- **HTTP & SSE 传输**：提供 REST 风格 JSON 接口、流式更新，并在启用传输时开放统一的 `/ui` 检查器
- **健壮配置管理**：改进后的 YAML 解析器具备错误容错能力，支持内联列表/布尔值转换
- **导入/导出与备份**：支持 JSON 级别的库迁移，及压缩快照的备份与恢复
- **多用户角色权限**：通过角色与令牌管理细粒度访问控制，可限制可见库范围

## 📋 系统要求

- Nim 2.0.0 或更高版本
- MCP 兼容客户端（Claude Desktop、Cursor 等）

## 🛠️ 安装

### 从源码安装

```bash
git clone https://github.com/yourorg/opencontext7.git
cd opencontext7
nimble install
```

> ℹ️ `nimble install` 会把包安装在 `~/.nimble` 下，请确认当前账号对该目录有写权限。

### 构建

```bash
nimble build
```

### Docker 镜像

在仓库根目录构建镜像（可选的构建参数会写入 OCI 元数据）：

```bash
docker build \
  --build-arg VERSION=$(git describe --tags --always) \
  --build-arg VCS_REF=$(git rev-parse HEAD) \
  --build-arg BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -t opencontext7:latest .
```

> 镜像默认使用非 root 的 `opencontext7` 用户（UID/GID=1000）。如需对齐宿主机权限，可通过 `--build-arg APP_UID=... APP_GID=...` 修改，或确保挂载目录对该 UID 可写。

使用具名卷持久化配置与数据：

```bash
docker run -d --name opencontext7 \
  -p 8080:8080 \
  -v opencontext7-config:/config \
  -v opencontext7-data:/data \
  -e OPENCONTEXT7_TRANSPORT=http \
  -e OPENCONTEXT7_ENABLE_AUTH=false \
  opencontext7:latest
```

`docker-entrypoint.sh` 会在第一次启动时自动生成 `/config/config.yaml`。所有配置均可通过环境变量注入，常用项包括：

- `OPENCONTEXT7_CONFIG_DIR` / `OPENCONTEXT7_DATA_DIR`
- `OPENCONTEXT7_HOST` / `OPENCONTEXT7_PORT` / `OPENCONTEXT7_TRANSPORT`
- `OPENCONTEXT7_API_KEYS`（逗号分隔）与 `OPENCONTEXT7_ALLOWED_IPS`
- `OPENCONTEXT7_GIT_AUTOSYNC`、`OPENCONTEXT7_GIT_REPOS_FILE`、`OPENCONTEXT7_GIT_SYNC_MINUTES`
- `OPENCONTEXT7_ENABLE_BACKUPS`、`OPENCONTEXT7_BACKUP_DIR`
- `OPENCONTEXT7_MULTI_USER`、`OPENCONTEXT7_USERS_FILE`、`OPENCONTEXT7_ROLES_FILE`

运行容器时，通过 `-e 变量=值` 即可覆盖 `docker-entrypoint.sh` 中列出的全部环境变量。

## 🚀 快速开始

### 1. 初始化配置

```bash
./opencontext7 init
```

这将在 `~/.opencontext7/config.yaml` 创建默认配置文件。

### 2. 注册第一个库

```bash
# 创建文档文件
echo "# 我的内部 API\n\n这是我们的内部 REST API..." > my-api-docs.md

# 注册库
./opencontext7 register "my-internal-api" "1.0.0" my-api-docs.md
```

### 3. 启动 MCP 服务器

```bash
./opencontext7 server
```

- 想使用 Web UI？在 `~/.opencontext7/config.yaml` 中将 `server.transport` 设置为 `http`（或 `sse`），重启服务器，然后访问 `http://<host>:<port>/ui`。

### 4. 配置 MCP 客户端

添加到 Claude Desktop 配置 (`~/Library/Application Support/Claude/claude_desktop_config.json`)：

```json
{
  "mcpServers": {
    "opencontext7": {
      "command": "/path/to/opencontext7",
      "args": ["server"]
    }
  }
}
```

### 5. 在提示中使用

```
为我们的内部用户服务创建一个 REST API 客户端。使用 opencontext7 获取 API 文档。
```

## 📖 使用指南

### CLI 命令

```bash
# 服务器管理
opencontext7 server                    # 启动 MCP 服务器
opencontext7 init                      # 初始化配置

# 库管理  
opencontext7 register <name> <version> <docs_file>  # 注册库
opencontext7 list                      # 列出所有库
opencontext7 search <query>            # 搜索库
opencontext7 get <name> [version]      # 获取库文档
opencontext7 delete <name> [version]   # 删除库

# 导入导出
opencontext7 export <name> [--version=VER] <file>   # 导出库为 JSON
opencontext7 import <file> [--override=true]        # 从 JSON 导入库

# Git 集成
opencontext7 git list                  # 查看已配置仓库
opencontext7 git add <id> <url> <docs_path> [opts]
opencontext7 git sync [id]             # 手动触发同步

# 备份
opencontext7 backup list               # 查看快照
opencontext7 backup create [--note=...]# 创建压缩快照
opencontext7 backup restore <id>       # 恢复快照（覆盖数据目录）
opencontext7 backup prune              # 执行保留策略

# 权限管理
opencontext7 users list|add|remove|deactivate|activate ...
opencontext7 roles list|add|remove ...

# 配置
opencontext7 config                    # 显示当前配置
```

### MCP 工具

当连接到 MCP 客户端时，OpenContext7 提供以下工具：

- **`register_library`**：注册带有文档的新库
- **`search_libraries`**：按名称或描述搜索库
- **`get_library_docs`**：获取特定库的文档

### 示例：注册库

```bash
# 创建文档
cat > api-docs.md << 'EOF'
# 内部用户 API v2.1.0

## 认证
所有端点都需要 Bearer token 认证：
```
Authorization: Bearer <your-token>
```

## 端点

### GET /users
获取用户列表
- **查询参数**：`limit`, `offset`, `filter`
- **响应**：用户对象数组

### POST /users  
创建新用户
- **请求体**：包含 `name`, `email`, `role` 的用户对象
- **响应**：包含 ID 的已创建用户
EOF

# 注册库
./opencontext7 register "user-api" "2.1.0" api-docs.md
```

### 示例：在 MCP 客户端中使用

在 Claude Desktop 或 Cursor 中：

```
我需要为我们的用户 API 创建一个 Python 客户端。你能帮我实现认证和用户创建功能吗？使用 opencontext7
```

MCP 客户端将自动获取文档并提供准确、最新的代码示例。

### Inspector 风格 Web UI

OpenContext7 内置了一套 MCP Inspector 风格的浏览器界面。启用 HTTP（或 SSE）传输后，启动服务器并访问 `http://<host>:<port>/ui`：

- 若 `security.enableAuth` 为 true，可在界面顶部填写 Bearer Token。
- 使用各功能面板按钮即可注册库、执行搜索或获取文档。
- 交互日志实时显示 JSON 返回结果，便于调试或演示。

## 🔁 功能详解

### Git 仓库同步与自动更新

1. 在 `config.yaml` 中将 `integration.enableAutoSync` 设置为 `true`（或通过 `OPENCONTEXT7_GIT_AUTOSYNC=true` 环境变量）。可用 `integration.syncIntervalMinutes` 调整轮询间隔。
2. 使用 CLI 维护仓库清单：

   ```bash
   opencontext7 git add docs-api https://github.com/acme/docs.git docs/reference.md \
     --branch=main --library=internal-api --version=1.0.0 --auto-sync=true
   opencontext7 git list
   ```

3. 随时通过 `opencontext7 git sync`（全部）或 `opencontext7 git sync docs-api`（指定仓库）手动触发同步。
4. Docker 镜像同样支持 `OPENCONTEXT7_GIT_REPOS_FILE`、`OPENCONTEXT7_GIT_SYNC_MINUTES` 等环境变量，部署时即可注入配置。

每次同步会 clone/fetch 指定分支、读取文档并重新注册库，CLI 与 HTTP/SSE 日志中会展示最新提交哈希与状态。

### 模糊搜索与结果解释

`opencontext7 search` 和 MCP `search_libraries` 工具现在会输出带分数和匹配理由的排序结果：

```bash
opencontext7 search authentication

# Found 3 libraries:
#   auth-service@2.1.0 (score 184.2) - 公司认证服务
#     reasons: exact name match, tag 'auth', description contains query
```

这些信息会原样返回给 MCP 客户端，帮助智能体自动挑选最合适的库。

### 库导入 / 导出

通过 JSON 快速迁移或备份：

```bash
opencontext7 export auth-service --version=2.1.0 exports/auth-service.json
opencontext7 import exports/auth-service.json --override=false
```

- `export` 会输出包含章节、分类、时间戳的原始 JSON。
- `import` 读取 JSON 并注册库，`--override=false` 可避免覆盖既有版本。

### 备份与恢复

启用 `backup.enableBackups: true`（或 `OPENCONTEXT7_ENABLE_BACKUPS=true`）后即可使用快照功能：

```bash
opencontext7 backup create --note="升级前快照"
opencontext7 backup list
opencontext7 backup restore snapshot-20241017T153000
opencontext7 backup prune
```

快照为压缩 tar 包，包含所有数据目录内容。`backup.retentionDays` 与 `backup.maxSnapshots` 用于控制保留策略。

### 多用户角色与权限

将 `access.multiUserEnabled` 设为 `true` 可强制 HTTP/SSE 请求携带 `Authorization: Bearer <token>`。默认角色：

- `admin`：全部权限（`*`）
- `editor`：读写、Git 同步、导入导出、备份
- `viewer`：只读

通过 CLI 管理角色与用户：

```bash
opencontext7 roles list
opencontext7 roles add qa --permissions=read,backup

opencontext7 users add alice alice-token --role=editor --libraries=internal-api,ui-kit
opencontext7 users list
opencontext7 users deactivate legacy-token
```

- CLI 会生成/更新 `roles.json` 与 `users.json`，默认存放在配置目录。
- 将 `access.enforceLibraryScope` 设为 `true` 时，可限制用户仅访问其 `libraries` 列表中的库。

### Docker 部署增强

运行时镜像内置 Git，并支持丰富的环境变量，适合一次性部署：

```bash
docker run -d --name opencontext7 \
  -v /srv/opencontext7/config:/config \
  -v /srv/opencontext7/data:/data \
  -e OPENCONTEXT7_TRANSPORT=http \
  -e OPENCONTEXT7_ENABLE_AUTH=true \
  -e OPENCONTEXT7_API_KEYS=admin-token \
  -e OPENCONTEXT7_GIT_AUTOSYNC=true \
  -e OPENCONTEXT7_MULTI_USER=true \
  yourregistry/opencontext7:latest
```

挂载 `/config` 与 `/data` 可保证配置、仓库清单、备份以及权限数据在容器重启后仍可用。

## 📦 项目结构分析

### 仓库总览

```
mcp-opencontext7/
├── Dockerfile                    # 多阶段构建脚本，产出最终运行镜像
├── docker-entrypoint.sh          # 容器入口，生成配置并导出环境变量
├── opencontext7.nimble          # Nimble 包描述文件
├── README.md / README_CN.md      # 英文 / 中文使用手册
├── docs/                         # 扩展文档与模板
├── examples/                     # 使用示例（如 simple_usage.nim）
├── src/                          # 生产代码
│   ├── access_manager.nim        # 多用户角色、令牌及权限校验
│   ├── backup_manager.nim        # 备份创建、保留与恢复
│   ├── cli.nim                   # 管理员 CLI 与命令解析
│   ├── config_manager.nim        # YAML 配置读写与环境变量覆盖
│   ├── opencontext7.nim         # MCP 服务器入口与传输配置
│   ├── git_manager.nim           # Git 仓库清单持久化
│   ├── git_sync.nim              # 仓库 clone/fetch 及库自动注册
│   ├── library_manager.nim       # 库注册、版本管理与模糊搜索
│   ├── mcp_helpers.nim           # MCP 成功/错误响应封装
│   ├── mcp_tools.nim             # 对外暴露的 MCP 工具实现
│   ├── topic_matcher.nim         # 主题匹配算法
│   └── ui_assets.nim             # 内嵌 Inspector 风格单页 UI
└── tests/                        # 自动化测试套件（CLI、配置、集成等）
```

### 源代码模块说明

- **`src/opencontext7.nim`**：应用入口。创建 MCP 服务器、选择传输模式（stdio/HTTP/SSE）、执行认证，并协调 Git/备份/权限子系统。
- **`src/cli.nim`**：提供 `opencontext7` 命令，覆盖库管理、Git 同步、导入导出、备份操作及多用户管理。
- **`src/config_manager.nim`**：负责 YAML 配置读写，合并环境变量，输出强类型配置对象。
- **`src/library_manager.nim`**：管理库的注册、版本、章节提取、模糊搜索评分、JSON 持久化，以及导入导出。
- **`src/mcp_tools.nim`**：实现 `register_library`、`search_libraries`、`get_library_docs` 三个 MCP 工具，含参数校验与模糊检索。
- **`src/mcp_helpers.nim`**：统一 MCP 成功/失败响应的 JSON 结构，供三种传输复用。
- **`src/topic_matcher.nim`**：提供字面、结构、嵌入式三种主题匹配算法，提升 `get_library_docs` 的命中率。
- **`src/git_manager.nim`**：维护 Git 仓库清单，标准化仓库描述并持久化到磁盘。
- **`src/git_sync.nim`**：执行 clone/fetch/reset，跟踪提交哈希，并在同步后重新注册库；同时提供自动循环同步。
- **`src/backup_manager.nim`**：创建 gzip 压缩快照、落实保留策略并安全恢复快照。
- **`src/access_manager.nim`**：维护角色/用户存储，执行权限验证，并根据配置限制可访问的库。
- **`src/ui_assets.nim`**：内嵌 Inspector 风格的单页 Web UI，供 HTTP/SSE 模式直接返回。

`tests/` 目录为上述模块提供对应的自动化测试，覆盖 CLI、配置、集成、错误处理等场景，确保新特性具备回归保障。

## 🛠 MCP 三大工具解析

- **`register_library`**：接收库文档并自动解析章节与代码段，计算 `codeSampleCount` 后写入索引。
- **`search_libraries`**：结合名称、描述、标签与标题 token 进行关键字匹配，返回可读性良好的概览。
- **`get_library_docs`**：支持 `version`、`max_characters`、`topic`、`topic_match` 等参数，结合主题算法返回最相关的章节，并确保代码块完整输出。

## 🌐 MCP 传输协议详解

- **STDIO**：默认模式，适合本地集成与 CLI 自动化。
- **HTTP**：提供 REST 风格接口、`/ui` 检查器，并支持基于 `security.apiKeys` 的 Bearer Token 认证。
- **SSE**：以 Server-Sent Events 推送流式消息，内建会话管理、心跳保持，并可直接服务 `/ui`。

三种传输模式共用同一套认证与调度逻辑，功能保持一致，可根据部署场景自由切换。

## ⚙️ 配置

配置文件位置：`~/.opencontext7/config.yaml`

```yaml
server:
  host: localhost
  port: 8080
  transport: stdio  # stdio, http, sse

storage:
  dataDir: ~/.opencontext7/data
  maxLibraries: 1000
  maxDocSize: 10485760  # 10MB

security:
  enableAuth: false
  apiKeys: []
  allowedIps: [127.0.0.1]

integration:
  enableAutoSync: false
  reposFile: ~/.opencontext7/git_repos.json
  defaultBranch: main
  syncIntervalMinutes: 15
  autoBootstrap: true

backup:
  enableBackups: false
  backupDir: ~/.opencontext7/backups
  retentionDays: 7
  maxSnapshots: 10

access:
  multiUserEnabled: false
  usersFile: ~/.opencontext7/users.json
  rolesFile: ~/.opencontext7/roles.json
  defaultRole: viewer
  enforceLibraryScope: false
```

> **提示：** 当 `enableAuth` 为 true 时，请在 `apiKeys` 中填写原始令牌字符串（例如 `"super-secret-key"`）。HTTP/SSE 客户端需要发送 `Authorization: Bearer <token>`。内置的 `/ui` 页面会在粘贴原始令牌时自动补全 `Bearer` 前缀。

- `integration.*` 用于配置 Git 清单文件、默认分支、同步频率以及是否自动初始化仓库。
- `backup.*` 控制快照开关、备份目录、按天保留策略以及最大快照数量。
- `access.*` 决定是否启用多用户模式、用户/角色 JSON 的存储位置，并可开启库级访问限制。

### 自定义配置

```bash
# 使用自定义配置文件
./opencontext7 --config=/path/to/config.yaml server

# 使用自定义数据目录
./opencontext7 --data-dir=/custom/path list
```

## 🏗️ 架构

OpenContext7 构建于：

- **MCP Nim SDK**：用于模型上下文协议实现
- **异步架构**：使用 Nim 的 asyncdispatch 进行非阻塞操作
- **JSON 存储**：带索引的简单基于文件的存储
- **模块化设计**：库管理、配置和 MCP 接口的独立模块

### 关键组件

- **库管理器**：处理注册、搜索和检索
- **配置管理器**：基于 YAML 的配置管理
- **MCP 服务器**：带有工具和资源的协议实现
- **CLI 界面**：提供运维命令（含 Git、备份、导入导出、用户/角色管理）
- **搜索索引**：快速基于关键字与相似度的搜索系统
- **Git 同步引擎**：保持本地库与远程仓库一致
- **备份管理器**：创建/恢复快照并执行保留策略
- **权限控制层**：根据角色和令牌执行访问控制

## 🔧 开发

### 运行测试

```bash
# 运行所有测试
nimble test

# 运行全面测试套件（100% 覆盖率）
nimble test_comprehensive

# 运行带覆盖率跟踪的测试
nimble test_coverage

# 生成覆盖率报告
nimble test_coverage_report
```

### 开发模式

```bash
nimble dev
```

### 示例用法

```bash
# 运行简单示例
nim c -r examples/simple_usage.nim
```

### 测试覆盖率

OpenContext7 在所有模块中保持 **100% 测试覆盖率**：

- **8 个全面测试套件** 覆盖所有功能
- **500+ 个独立测试用例** 包括边界情况和错误条件
- **CLI、MCP 服务器和库管理的完整集成测试**
- **边界值测试** 确保性能和可靠性
- **错误处理验证** 确保稳健运行

测试套件包括：
- 库管理器（全面的 CRUD 和搜索操作）
- 配置管理（YAML 解析和文件操作）
- CLI 界面（所有命令和错误处理）
- MCP 服务器集成（协议合规性和工具处理程序）
- 错误处理（边界条件和恢复）
- 集成测试（端到端工作流）

详见 [docs/TESTING.md](docs/TESTING.md) 获取详细的测试信息。

## 🔒 安全考虑

- **私有网络**：仅在内部网络上运行
- **认证**：为 HTTP 传输启用 API 密钥认证
- **文件权限**：确保数据目录具有适当的权限
- **输入验证**：所有输入都经过验证和清理
- **无外部调用**：完全自包含，无外部 API 调用

## 📚 使用场景

- **内部 API 文档**：安全且可搜索地保存专有 API 文档
- **库文档**：记录内部实用库和框架
- **代码示例**：存储和检索公司特定的代码模式
- **配置模板**：管理基础设施和部署配置
- **协议文档**：记录内部通信协议

## 🤝 贡献指南

1. Fork 仓库
2. 创建功能分支
3. 进行更改
4. 添加测试
5. 提交拉取请求

## 📄 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 🆚 OpenContext7 vs Context7 SaaS

| 功能 | OpenContext7 | OpenContext7 SaaS |
|------|----------------|---------------|
| **托管方式** | 自托管 | 云托管 |
| **隐私性** | 完全私有 | 仅公共库 |
| **设置** | 手动安装 | 零设置 |
| **库类型** | 内部/专有 | 公共包 |
| **成本** | 免费（自托管） | 基于订阅 |
| **维护** | 自行管理 | 完全托管 |

## 🚀 路线图

- [x] Git 集成，实现自动文档更新
- [x] 带模糊匹配的高级搜索
- [x] 库导入/导出功能
- [x] 多用户支持和权限管理
- [x] Docker 容器支持
- [x] 备份和恢复功能
