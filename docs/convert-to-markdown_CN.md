# 将现有文档转换为 Markdown 的方法

## 1. 从 JSDoc 转换为 Markdown

### convert-jsdoc.js
```javascript
const jsdoc2md = require('jsdoc-to-markdown');
const fs = require('fs');

// 从 JSDoc 注释生成 Markdown
const markdown = jsdoc2md.renderSync({
  files: 'src/**/*.js',
  template: `# {{name}} v{{version}}

## 概述
{{description}}

## API 参考
{{#functions}}
### {{name}}
{{description}}

**参数:**
{{#params}}
- \`{{name}}\` ({{type.names}}){{#if optional}} - 可选{{/if}}: {{description}}
{{/params}}

**返回值:** {{#returns}}{{type.names}} - {{description}}{{/returns}}

**示例:**
\`\`\`javascript
{{#examples}}
{{{this}}}
{{/examples}}
\`\`\`
{{/functions}}`
});

fs.writeFileSync('api-docs.md', markdown);
```

## 2. 从 TypeDoc 转换为 Markdown

### typedoc.json
```json
{
  "entryPoints": ["src/index.ts"],
  "out": "docs",
  "plugin": ["typedoc-plugin-markdown"],
  "theme": "markdown",
  "readme": "none",
  "hideBreadcrumbs": true,
  "hideInPageTOC": true
}
```

### 执行
```bash
npx typedoc
```

## 3. 从 Python docstring 转换为 Markdown

### convert_docstring.py
```python
import inspect
import importlib

def generate_markdown(module_name):
    module = importlib.import_module(module_name)
    
    md_content = f"# {module_name} API 文档\n\n"
    
    for name, obj in inspect.getmembers(module):
        if inspect.isclass(obj):
            md_content += f"## 类: {name}\n"
            md_content += f"{inspect.getdoc(obj)}\n\n"
            
            # 方法列表
            for method_name, method in inspect.getmembers(obj):
                if inspect.ismethod(method) or inspect.isfunction(method):
                    if not method_name.startswith('_'):
                        md_content += f"### {method_name}\n"
                        md_content += f"{inspect.getdoc(method)}\n\n"
                        
                        # 签名
                        sig = inspect.signature(method)
                        md_content += f"```python\n{method_name}{sig}\n```\n\n"
        
        elif inspect.isfunction(obj):
            md_content += f"## 函数: {name}\n"
            md_content += f"{inspect.getdoc(obj)}\n\n"
            sig = inspect.signature(obj)
            md_content += f"```python\n{name}{sig}\n```\n\n"
    
    return md_content

# 使用示例
markdown = generate_markdown('my_library')
with open('my_library_docs.md', 'w') as f:
    f.write(markdown)
```

## 4. 从 Swagger 转换为 Markdown

### convert-swagger.js
```javascript
const SwaggerParser = require('swagger-parser');
const fs = require('fs');

async function convertSwaggerToMarkdown(swaggerFile) {
  const api = await SwaggerParser.parse(swaggerFile);
  
  let markdown = `# ${api.info.title} v${api.info.version}\n\n`;
  markdown += `## 概述\n${api.info.description}\n\n`;
  
  // 基础 URL
  markdown += `## 基础 URL\n\`\`\`\n${api.servers[0].url}\n\`\`\`\n\n`;
  
  // 认证
  if (api.components && api.components.securitySchemes) {
    markdown += `## 认证\n`;
    for (const [name, scheme] of Object.entries(api.components.securitySchemes)) {
      markdown += `### ${name}\n`;
      markdown += `- 类型: ${scheme.type}\n`;
      if (scheme.scheme) markdown += `- 方案: ${scheme.scheme}\n`;
      markdown += '\n';
    }
  }
  
  // 端点
  markdown += `## 端点\n\n`;
  
  for (const [path, methods] of Object.entries(api.paths)) {
    for (const [method, operation] of Object.entries(methods)) {
      if (method === 'parameters') continue;
      
      markdown += `### ${method.toUpperCase()} ${path}\n`;
      markdown += `${operation.summary || ''}\n\n`;
      
      if (operation.description) {
        markdown += `${operation.description}\n\n`;
      }
      
      // 参数
      if (operation.parameters) {
        markdown += `**参数:**\n`;
        for (const param of operation.parameters) {
          markdown += `- \`${param.name}\` (${param.in}, ${param.schema.type}`;
          if (param.required) markdown += ', 必需';
          markdown += `): ${param.description || ''}\n`;
        }
        markdown += '\n';
      }
      
      // 请求体
      if (operation.requestBody) {
        markdown += `**请求体:**\n`;
        const content = operation.requestBody.content['application/json'];
        if (content && content.example) {
          markdown += `\`\`\`json\n${JSON.stringify(content.example, null, 2)}\n\`\`\`\n\n`;
        }
      }
      
      // 响应
      markdown += `**响应:**\n`;
      for (const [status, response] of Object.entries(operation.responses)) {
        markdown += `- ${status}: ${response.description}\n`;
        if (response.content && response.content['application/json']) {
          const example = response.content['application/json'].example;
          if (example) {
            markdown += `\`\`\`json\n${JSON.stringify(example, null, 2)}\n\`\`\`\n`;
          }
        }
      }
      markdown += '\n';
    }
  }
  
  return markdown;
}

// 使用示例
convertSwaggerToMarkdown('openapi.yaml').then(markdown => {
  fs.writeFileSync('api-docs.md', markdown);
});
```

## 5. 从公司 Wiki 转换（Confluence 示例）

### convert-confluence.py
```python
import requests
from bs4 import BeautifulSoup
import html2text

def convert_confluence_to_markdown(page_id, base_url, auth):
    # 从 Confluence API 获取页面内容
    url = f"{base_url}/rest/api/content/{page_id}?expand=body.storage"
    response = requests.get(url, auth=auth)
    data = response.json()
    
    # 获取 HTML 内容
    html_content = data['body']['storage']['value']
    
    # HTML 转 Markdown
    h = html2text.HTML2Text()
    h.ignore_links = False
    h.ignore_images = False
    markdown = h.handle(html_content)
    
    # 添加标题
    title = data['title']
    version = data['version']['number']
    markdown = f"# {title} v{version}\n\n{markdown}"
    
    # 修复内部链接
    markdown = markdown.replace(f"{base_url}/display/", "")
    
    return markdown

# 使用示例
auth = ('username', 'password')
markdown = convert_confluence_to_markdown(
    '12345678',
    'https://confluence.company.local',
    auth
)

with open('wiki-page.md', 'w') as f:
    f.write(markdown)
```

## 6. 从可执行命令自动生成

### generate-cli-docs.sh
```bash
#!/bin/bash

COMMAND=$1
OUTPUT_FILE="${COMMAND}-docs.md"

cat > "$OUTPUT_FILE" << EOF
# ${COMMAND} 命令参考

## 概述
$($COMMAND --version 2>&1 | head -1)

## 使用方法
\`\`\`
$($COMMAND --help 2>&1)
\`\`\`

## 选项详情
EOF

# 提取每个选项的详细信息
$COMMAND --help 2>&1 | grep -E '^\s+-' | while read -r line; do
    echo "### $line" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "已生成: $OUTPUT_FILE"
```

## 7. 简易转换脚本（通用）

### quick-convert.py
```python
#!/usr/bin/env python3
import sys
import re

def convert_to_markdown(input_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 基本转换规则
    # 去除 HTML 标签
    content = re.sub(r'<[^>]+>', '', content)
    
    # 转换类似标题的行
    content = re.sub(r'^([A-Z][A-Za-z\s]+):$', r'## \1', content, flags=re.MULTILINE)
    
    # 检测代码块
    content = re.sub(r'```(\w+)?\n(.*?)\n```', r'```\1\n\2\n```', content, flags=re.DOTALL)
    
    # 列表项
    content = re.sub(r'^[-*]\s+', '- ', content, flags=re.MULTILINE)
    content = re.sub(r'^\d+\.\s+', '1. ', content, flags=re.MULTILINE)
    
    # 强调
    content = re.sub(r'\*\*(.*?)\*\*', r'**\1**', content)
    content = re.sub(r'__(.*?)__', r'**\1**', content)
    
    return content

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("用法: quick-convert.py <输入文件>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = input_file.rsplit('.', 1)[0] + '.md'
    
    markdown = convert_to_markdown(input_file)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(markdown)
    
    print(f"已转换: {output_file}")
```

## 总结

1. **手动创建最可靠**：以 LLM 易于理解的格式编写
2. **自动转换是起点**：生成后需要手动调整
3. **优先重要信息**：使用示例、错误处理、公司特定信息
4. **定期更新**：版本升级时不要忘记更新

请结合这些工具和方法，创建有效的文档。