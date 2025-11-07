# 文档创建实例

## 示例 1：简单的工具库

```markdown
# 公司通用工具 v1.2.0

## 概述
公司系统中常用的工具函数集合。
提供日期处理、字符串转换、验证功能。

## 安装
```bash
npm install @company/common-utils
```

## 使用方法

### 日期处理
```javascript
const { dateUtils } = require('@company/common-utils');

// 工作日计算
const nextBusinessDay = dateUtils.addBusinessDays(new Date(), 3);

// 公司日历支持
const isHoliday = dateUtils.isCompanyHoliday('2024-05-01');
```

### 字符串处理
```javascript
const { stringUtils } = require('@company/common-utils');

// 员工编号格式化
const formatted = stringUtils.formatEmployeeId('12345'); // => 'EMP-012345'

// 部门代码转换
const deptName = stringUtils.getDepartmentName('DEV'); // => '开发部'
```

## API 列表
- `dateUtils.addBusinessDays(date, days)` - 工作日加法
- `dateUtils.isCompanyHoliday(date)` - 公司假日判断
- `stringUtils.formatEmployeeId(id)` - 员工编号格式化
- `stringUtils.getDepartmentName(code)` - 部门名称获取
```

## 示例 2：从现有的 Swagger/OpenAPI 转换

```markdown
# 库存管理 API v2.0.0

## 概述
公司库存管理系统的 REST API。提供商品库存查询、更新、移动处理。

## 基础 URL
```
https://inventory.company.local/api/v2
```

## 认证
所有端点需要公司 SSO 令牌：
```
Authorization: Bearer <sso_token>
X-Department-Code: <部门代码>
```

## 端点

### 库存查询

#### GET /inventory/{product_code}
获取指定商品的库存信息

**参数:**
- `product_code` (path, string, required): 商品代码
- `warehouse` (query, string, optional): 仓库代码（省略时为所有仓库）

**响应示例:**
```json
{
  "product_code": "PRD-12345",
  "product_name": "示例商品",
  "total_quantity": 150,
  "warehouses": [
    {
      "warehouse_code": "WH-01",
      "warehouse_name": "东京仓库",
      "quantity": 100,
      "location": "A-1-1"
    },
    {
      "warehouse_code": "WH-02", 
      "warehouse_name": "大阪仓库",
      "quantity": 50,
      "location": "B-2-3"
    }
  ],
  "last_updated": "2024-05-30T10:30:00+09:00"
}
```

### 库存更新

#### PUT /inventory/{product_code}
更新库存数量（盘点时等）

**请求体:**
```json
{
  "warehouse_code": "WH-01",
  "quantity": 95,
  "reason": "盘点调整",
  "adjusted_by": "EMP-12345"
}
```

**响应示例:**
```json
{
  "success": true,
  "transaction_id": "TRX-20240530-001",
  "previous_quantity": 100,
  "new_quantity": 95,
  "difference": -5
}
```

## 错误代码
| 代码 | 说明 | 处理方法 |
|--------|------|--------|
| INV-001 | 商品代码不存在 | 确认商品主数据 |
| INV-002 | 库存数量不足 | 确认库存数量后重新执行 |
| INV-003 | 仓库代码无效 | 指定有效的仓库代码 |
| INV-004 | 权限不足 | 确认部门权限 |

## 使用示例

### Python
```python
import requests
from company_auth import get_sso_token

# 获取认证令牌
token = get_sso_token()
headers = {
    'Authorization': f'Bearer {token}',
    'X-Department-Code': 'LOG'  # 物流部
}

# 库存查询
response = requests.get(
    'https://inventory.company.local/api/v2/inventory/PRD-12345',
    headers=headers
)
inventory = response.json()
print(f"总库存数: {inventory['total_quantity']}")
```

## 负责人
- 系统: 物流系统部
- 联系方式: logistics-system@company.local
- 内线: 1234
```

## 示例 3：公司框架文档

```markdown
# 公司 Web 框架 v3.5.0

## 概述
公司 Web 应用程序开发用框架。
标准配备公司认证、日志记录、错误处理。

## 设置

### 项目创建
```bash
npx @company/create-app my-app
cd my-app
npm install
npm run dev
```

## 项目结构
```
my-app/
├── src/
│   ├── controllers/    # 控制器
│   ├── models/        # 数据模型
│   ├── views/         # 视图模板
│   └── middleware/    # 中间件
├── config/            # 配置文件
├── tests/            # 测试
└── package.json
```

## 基本用法

### 控制器创建
```javascript
// src/controllers/UserController.js
const { Controller, requireAuth } = require('@company/web-framework');

class UserController extends Controller {
  @requireAuth(['admin', 'manager'])
  async index(req, res) {
    const users = await this.model('User').findAll({
      department: req.user.department
    });
    
    return this.render('users/index', { users });
  }
  
  async create(req, res) {
    try {
      const user = await this.model('User').create(req.body);
      return this.success('用户创建成功', { user });
    } catch (error) {
      return this.error('创建失败', error);
    }
  }
}

module.exports = UserController;
```

### 模型定义
```javascript
// src/models/User.js
const { Model, validators } = require('@company/web-framework');

class User extends Model {
  static tableName = 'users';
  
  static schema = {
    employee_id: {
      type: 'string',
      required: true,
      validate: validators.employeeId()
    },
    email: {
      type: 'string',
      required: true,
      validate: validators.companyEmail()
    },
    department: {
      type: 'string',
      required: true,
      validate: validators.departmentCode()
    }
  };
  
  static relations = {
    department: {
      type: 'belongsTo',
      model: 'Department',
      foreignKey: 'department_code'
    }
  };
}

module.exports = User;
```

## 内置功能

### 公司认证
自动与公司 SSO 集成：
```javascript
// config/auth.js
module.exports = {
  sso: {
    url: 'https://sso.company.local',
    clientId: process.env.SSO_CLIENT_ID,
    clientSecret: process.env.SSO_CLIENT_SECRET
  },
  session: {
    secret: process.env.SESSION_SECRET,
    timeout: 3600
  }
};
```

### 日志记录
自动记录所有请求：
```javascript
// 日志自动以下列格式记录
{
  "timestamp": "2024-05-30T10:30:00Z",
  "level": "INFO",
  "message": "用户登录成功",
  "userId": "EMP-12345",
  "department": "DEV",
  "ip": "192.168.1.100",
  "userAgent": "Mozilla/5.0..."
}
```

## 示例 4：内部 CLI 工具

```markdown
# 公司部署工具 v2.1.0

## 概述
公司内部应用程序部署用 CLI 工具。
支持开发、测试、生产环境的部署。

## 安装
```bash
npm install -g @company/deploy-tool
```

## 使用方法

### 环境设置
```bash
# 开发环境
deploy-tool setup --env=dev

# 生产环境
deploy-tool setup --env=prod --region=tokyo
```

### 应用程序部署
```bash
# 简单部署
deploy-tool deploy my-app

# 带配置的部署
deploy-tool deploy my-app \
  --version=1.2.3 \
  --config=prod-config.json \
  --rollback-on-failure
```

### 状态检查
```bash
# 检查部署状态
deploy-tool status my-app

# 详细状态
deploy-tool status my-app --verbose

# 历史记录
deploy-tool history my-app --limit=10
```

## 配置示例

### deploy-config.json
```json
{
  "appName": "my-app",
  "version": "1.2.3",
  "environment": "production",
  "region": "tokyo",
  "instances": 3,
  "resources": {
    "cpu": "1",
    "memory": "2GB",
    "storage": "10GB"
  },
  "healthCheck": {
    "path": "/health",
    "timeout": 30,
    "interval": 10
  },
  "secrets": {
    "databaseUrl": "env:DATABASE_URL",
    "apiKey": "vault:api-keys/my-app"
  }
}
```

## 错误处理

### 常见错误
```bash
# 权限不足
ERROR: 部署权限不足。请联系系统管理员。

# 配置错误  
ERROR: 配置文件格式错误。请检查 deploy-config.json。

# 网络问题
ERROR: 无法连接到部署服务器。请检查网络连接。
```

### 故障排除
1. 检查网络连接
2. 验证配置文件格式
3. 确认部署权限
4. 查看详细日志：`deploy-tool logs my-app --tail=100`