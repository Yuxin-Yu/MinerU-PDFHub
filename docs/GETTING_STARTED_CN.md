# MinerU-PDFHub 入门指南

本指南将帮助你快速搭建并使用 **MinerU-PDFHub** 管理私有文档库。它涵盖安装、初始化配置、常用 CLI 命令，以及如何启用 Web UI。

## 1. 克隆仓库

```bash
git clone https://github.com/yourorg/mineru-pdfhub.git
cd mineru-pdfhub
```

## 2. 初始化配置

首次运行前需要初始化配置文件：

```bash
./mineru-pdfhub init
```

命令会在 `~/.mineru-pdfhub/config.yaml` 下生成默认配置，并创建 `data`、`backups` 等目录。

## 3. 启动服务器

```bash
./mineru-pdfhub server
```

服务器默认使用 stdio 传输，若要启用 HTTP/SSE UI，可在配置中设置：

```yaml
server:
  host: 0.0.0.0
  port: 8080
  transport: http
```

随后访问 `http://<host>:<port>/ui/login` 登录 Web 控制台。

## 4. 常用 CLI 命令

```bash
./mineru-pdfhub register <name> <version> <docs_file>  # 注册文档库
./mineru-pdfhub list                                   # 查看全部库
./mineru-pdfhub search <query>                         # 搜索库
./mineru-pdfhub get <name> [version]                   # 获取文档
./mineru-pdfhub delete <name> [version]                # 删除版本
./mineru-pdfhub backup create --note "Before upgrade" # 生成快照
./mineru-pdfhub backup restore <snapshot-id>           # 恢复快照
./mineru-pdfhub users list                             # 管理用户
```

若需要批量同步 Git 文档，请使用以下命令：

```bash
./mineru-pdfhub git add docs-api https://github.com/acme/docs.git docs/reference.md --auto-sync=true
./mineru-pdfhub git sync                               # 全量同步
```

## 5. 注册与登录

- 打开浏览器访问 `/ui/login` 输入用户名与密码即可登录。
- 首次使用时，可在 `/ui/register` 创建管理员账户；创建成功后会自动登录并跳转到主控制台。
- 控制台侧边栏支持粘贴已有的 Bearer Token，并提供注销按钮。

## 6. 主题设置

登录后点击右上角设置按钮，可在“深色/浅色”主题之间切换，偏好会保存在浏览器 `localStorage` 中。

## 7. 数据目录结构

默认数据目录位于 `~/.mineru-pdfhub`：

- `config.yaml`：主配置文件
- `data/`：所有注册文档的 JSON 存档
- `git_repos.json`：Git 同步配置
- `backups/`：自动/手动创建的压缩快照
- `users.json`、`roles.json`：多用户与角色管理数据

## 8. 常见问题

- **如何重置管理员密码？**
  删除 `users.json` 后重新启动服务器并访问 `/ui/register`，创建新的首个账户。
- **如何禁用认证？**
  在配置中将 `access.multiUserEnabled` 设为 `false`，并删除 `users.json` 文件。
- **如何更换存储目录？**
  启动命令可通过 `--data-dir=/path/to/data` 参数覆盖默认位置。

祝使用顺利！更多细节请参考 `README_CN.md` 与 `docs/TESTING.md`。
