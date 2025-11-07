# Docker Compose 部署指南

本文档介绍如何使用Docker Compose部署OpenContext7。

## 快速开始

### 1. 构建镜像

```bash
docker build \
  --build-arg VERSION=$(git describe --tags --always) \
  --build-arg VCS_REF=$(git rev-parse HEAD) \
  --build-arg BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -t opencontext7:latest .
```

### 2. 启动服务（开发环境）

```bash
# 使用基础配置启动
docker-compose up -d

# 查看日志
docker-compose logs -f opencontext7

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
docker-compose -f docker-compose.prod.yml logs -f opencontext7

# 停止服务
docker-compose -f docker-compose.prod.yml down
```

## 高级配置

### 持久化数据

数据通过Docker卷进行持久化：
- `opencontext7-config`: 存储配置文件
- `opencontext7-data`: 存储库文档和其他数据

如需备份，可以导出卷：
```bash
# 备份配置
docker run --rm -v opencontext7-config:/data -v $(pwd):/backup alpine tar czf /backup/config-backup.tar.gz -C /data .

# 备份数据
docker run --rm -v opencontext7-data:/data -v $(pwd):/backup alpine tar czf /backup/data-backup.tar.gz -C /data .
```

### 环境变量配置

以下是常用环境变量：

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| OPENCONTEXT7_CONFIG_DIR | /config | 配置目录 |
| OPENCONTEXT7_DATA_DIR | /data | 数据目录 |
| OPENCONTEXT7_HOST | 0.0.0.0 | 服务器监听地址 |
| OPENCONTEXT7_PORT | 8080 | 服务器端口 |
| OPENCONTEXT7_TRANSPORT | http | 传输协议 |
| OPENCONTEXT7_ENABLE_AUTH | false | 是否启用认证 |
| OPENCONTEXT7_API_KEYS | - | API密钥列表（逗号分隔） |
| OPENCONTEXT7_ALLOWED_IPS | - | 允许的IP范围（逗号分隔） |
| OPENCONTEXT7_GIT_AUTOSYNC | false | 是否启用Git自动同步 |
| OPENCONTEXT7_GIT_SYNC_MINUTES | 60 | Git同步间隔（分钟） |
| OPENCONTEXT7_ENABLE_BACKUPS | false | 是否启用备份 |
| OPENCONTEXT7_BACKUP_DIR | /data/backups | 备份目录 |
| OPENCONTEXT7_MULTI_USER | false | 是否启用多用户 |

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
  -t opencontext7:latest .

# 4. 启动服务
docker-compose -f docker-compose.prod.yml up -d
```

## 故障排除

### 查看日志

```bash
# 开发环境
docker-compose logs -f opencontext7

# 生产环境
docker-compose -f docker-compose.prod.yml logs -f opencontext7
```

### 进入容器调试

```bash
# 开发环境
docker-compose exec opencontext7 /bin/bash

# 生产环境
docker-compose -f docker-compose.prod.yml exec opencontext7 /bin/bash
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