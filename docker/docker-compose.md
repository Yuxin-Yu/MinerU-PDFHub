# Docker Compose 部署指南

本文档介绍如何使用Docker Compose部署MinerU-PDFHub。

## 快速开始

### 1. 构建镜像

```bash
docker build \
  --build-arg VERSION=$(git describe --tags --always) \
  --build-arg VCS_REF=$(git rev-parse HEAD) \
  --build-arg BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -t mineru-pdfhub:latest .
```

### 2. 启动服务（开发环境）

```bash
# 使用基础配置启动
docker-compose up -d

# 查看日志
docker-compose logs -f mineru-pdfhub

# 停止服务
docker-compose down
```

访问 http://localhost:8080/ui 即可使用Web界面。

### 3. 生产环境部署

```bash
# 复制环境变量模板并配置
cp .env.example .env
# 编辑 .env 文件，填入实际配置值

# 使用生产配置启动
docker-compose -f docker-compose.prod.yml up -d

# 查看日志
docker-compose -f docker-compose.prod.yml logs -f mineru-pdfhub

# 停止服务
docker-compose -f docker-compose.prod.yml down
```

## 高级配置

### 持久化数据

数据通过Docker卷进行持久化：
- `mineru-pdfhub-config`: 存储配置文件
- `mineru-pdfhub-data`: 存储库文档和其他数据

如需备份，可以导出卷：
```bash
# 备份配置
docker run --rm -v mineru-pdfhub-config:/data -v $(pwd):/backup alpine tar czf /backup/config-backup.tar.gz -C /data .

# 备份数据
docker run --rm -v mineru-pdfhub-data:/data -v $(pwd):/backup alpine tar czf /backup/data-backup.tar.gz -C /data .
```

### 环境变量配置

以下是常用环境变量：

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| MINERU_PDFHUB_CONFIG_DIR | /config | 配置目录 |
| MINERU_PDFHUB_DATA_DIR | /data | 数据目录 |
| MINERU_PDFHUB_HOST | 0.0.0.0 | 服务器监听地址 |
| MINERU_PDFHUB_PORT | 8080 | 服务器端口 |
| MINERU_PDFHUB_TRANSPORT | http | 传输协议 |
| MINERU_PDFHUB_ENABLE_AUTH | false | 是否启用认证 |
| MINERU_PDFHUB_API_KEYS | - | API密钥列表（逗号分隔） |
| MINERU_PDFHUB_ALLOWED_IPS | - | 允许的IP范围（逗号分隔） |
| MINERU_PDFHUB_GIT_AUTOSYNC | false | 是否启用Git自动同步 |
| MINERU_PDFHUB_GIT_SYNC_MINUTES | 60 | Git同步间隔（分钟） |
| MINERU_PDFHUB_ENABLE_BACKUPS | false | 是否启用备份 |
| MINERU_PDFHUB_BACKUP_DIR | /data/backups | 备份目录 |
| MINERU_PDFHUB_MULTI_USER | false | 是否启用多用户 |

### 反向代理配置

如果需要使用反向代理（如Nginx），可以参考以下配置：

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 升级服务

```bash
# 1. 备份数据
./backup-data.sh  # 使用上面的备份命令

# 2. 停止服务
docker-compose -f docker-compose.prod.yml down

# 3. 构建新镜像
docker build \
  --build-arg VERSION=$(git describe --tags --always) \
  --build-arg VCS_REF=$(git rev-parse HEAD) \
  --build-arg BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -t mineru-pdfhub:latest .

# 4. 启动服务
docker-compose -f docker-compose.prod.yml up -d
```

## 故障排除

### 查看日志

```bash
# 开发环境
docker-compose logs -f mineru-pdfhub

# 生产环境
docker-compose -f docker-compose.prod.yml logs -f mineru-pdfhub
```

### 进入容器调试

```bash
# 开发环境
docker-compose exec mineru-pdfhub /bin/bash

# 生产环境
docker-compose -f docker-compose.prod.yml exec mineru-pdfhub /bin/bash
```

### 端口冲突

如果8080端口已被占用，可以修改docker-compose.yml文件中的端口映射：

```yaml
ports:
  - "8081:8080"  # 将主机的8081端口映射到容器的8080端口
```

### 权限问题

如果遇到权限问题，可以确保卷目录对所有用户可写：

```bash
# 创建并设置权限
mkdir -p ./data ./config
chmod 777 ./data ./config
```