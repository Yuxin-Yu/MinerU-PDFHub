# 既存ドキュメントをMarkdownに変換する方法

## 1. JSDocからMarkdownへの変換

### convert-jsdoc.js
```javascript
const jsdoc2md = require('jsdoc-to-markdown');
const fs = require('fs');

// JSDocコメントからMarkdown生成
const markdown = jsdoc2md.renderSync({
  files: 'src/**/*.js',
  template: `# {{name}} v{{version}}

## 概要
{{description}}

## API リファレンス
{{#functions}}
### {{name}}
{{description}}

**パラメータ:**
{{#params}}
- \`{{name}}\` ({{type.names}}){{#if optional}} - optional{{/if}}: {{description}}
{{/params}}

**戻り値:** {{#returns}}{{type.names}} - {{description}}{{/returns}}

**例:**
\`\`\`javascript
{{#examples}}
{{{this}}}
{{/examples}}
\`\`\`
{{/functions}}`
});

fs.writeFileSync('api-docs.md', markdown);
```

## 2. TypeDocからMarkdownへの変換

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

### 実行
```bash
npx typedoc
```

## 3. Python docstringからMarkdownへの変換

### convert_docstring.py
```python
import inspect
import importlib

def generate_markdown(module_name):
    module = importlib.import_module(module_name)
    
    md_content = f"# {module_name} API Documentation\n\n"
    
    for name, obj in inspect.getmembers(module):
        if inspect.isclass(obj):
            md_content += f"## Class: {name}\n"
            md_content += f"{inspect.getdoc(obj)}\n\n"
            
            # メソッド一覧
            for method_name, method in inspect.getmembers(obj):
                if inspect.ismethod(method) or inspect.isfunction(method):
                    if not method_name.startswith('_'):
                        md_content += f"### {method_name}\n"
                        md_content += f"{inspect.getdoc(method)}\n\n"
                        
                        # シグネチャ
                        sig = inspect.signature(method)
                        md_content += f"```python\n{method_name}{sig}\n```\n\n"
        
        elif inspect.isfunction(obj):
            md_content += f"## Function: {name}\n"
            md_content += f"{inspect.getdoc(obj)}\n\n"
            sig = inspect.signature(obj)
            md_content += f"```python\n{name}{sig}\n```\n\n"
    
    return md_content

# 使用例
markdown = generate_markdown('my_library')
with open('my_library_docs.md', 'w') as f:
    f.write(markdown)
```

## 4. SwaggerからMarkdownへの変換

### convert-swagger.js
```javascript
const SwaggerParser = require('swagger-parser');
const fs = require('fs');

async function convertSwaggerToMarkdown(swaggerFile) {
  const api = await SwaggerParser.parse(swaggerFile);
  
  let markdown = `# ${api.info.title} v${api.info.version}\n\n`;
  markdown += `## 概要\n${api.info.description}\n\n`;
  
  // ベースURL
  markdown += `## ベースURL\n\`\`\`\n${api.servers[0].url}\n\`\`\`\n\n`;
  
  // 認証
  if (api.components && api.components.securitySchemes) {
    markdown += `## 認証\n`;
    for (const [name, scheme] of Object.entries(api.components.securitySchemes)) {
      markdown += `### ${name}\n`;
      markdown += `- Type: ${scheme.type}\n`;
      if (scheme.scheme) markdown += `- Scheme: ${scheme.scheme}\n`;
      markdown += '\n';
    }
  }
  
  // エンドポイント
  markdown += `## エンドポイント\n\n`;
  
  for (const [path, methods] of Object.entries(api.paths)) {
    for (const [method, operation] of Object.entries(methods)) {
      if (method === 'parameters') continue;
      
      markdown += `### ${method.toUpperCase()} ${path}\n`;
      markdown += `${operation.summary || ''}\n\n`;
      
      if (operation.description) {
        markdown += `${operation.description}\n\n`;
      }
      
      // パラメータ
      if (operation.parameters) {
        markdown += `**パラメータ:**\n`;
        for (const param of operation.parameters) {
          markdown += `- \`${param.name}\` (${param.in}, ${param.schema.type}`;
          if (param.required) markdown += ', required';
          markdown += `): ${param.description || ''}\n`;
        }
        markdown += '\n';
      }
      
      // リクエストボディ
      if (operation.requestBody) {
        markdown += `**リクエストボディ:**\n`;
        const content = operation.requestBody.content['application/json'];
        if (content && content.example) {
          markdown += `\`\`\`json\n${JSON.stringify(content.example, null, 2)}\n\`\`\`\n\n`;
        }
      }
      
      // レスポンス
      markdown += `**レスポンス:**\n`;
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

// 使用例
convertSwaggerToMarkdown('openapi.yaml').then(markdown => {
  fs.writeFileSync('api-docs.md', markdown);
});
```

## 5. 社内Wikiから変換（Confluence例）

### convert-confluence.py
```python
import requests
from bs4 import BeautifulSoup
import html2text

def convert_confluence_to_markdown(page_id, base_url, auth):
    # Confluence APIからページ内容を取得
    url = f"{base_url}/rest/api/content/{page_id}?expand=body.storage"
    response = requests.get(url, auth=auth)
    data = response.json()
    
    # HTMLコンテンツを取得
    html_content = data['body']['storage']['value']
    
    # HTML to Markdown変換
    h = html2text.HTML2Text()
    h.ignore_links = False
    h.ignore_images = False
    markdown = h.handle(html_content)
    
    # タイトルを追加
    title = data['title']
    version = data['version']['number']
    markdown = f"# {title} v{version}\n\n{markdown}"
    
    # 内部リンクを修正
    markdown = markdown.replace(f"{base_url}/display/", "")
    
    return markdown

# 使用例
auth = ('username', 'password')
markdown = convert_confluence_to_markdown(
    '12345678',
    'https://confluence.company.local',
    auth
)

with open('wiki-page.md', 'w') as f:
    f.write(markdown)
```

## 6. 実行可能なコマンドから自動生成

### generate-cli-docs.sh
```bash
#!/bin/bash

COMMAND=$1
OUTPUT_FILE="${COMMAND}-docs.md"

cat > "$OUTPUT_FILE" << EOF
# ${COMMAND} コマンドリファレンス

## 概要
$($COMMAND --version 2>&1 | head -1)

## 使用方法
\`\`\`
$($COMMAND --help 2>&1)
\`\`\`

## オプション詳細
EOF

# 各オプションの詳細を抽出
$COMMAND --help 2>&1 | grep -E '^\s+-' | while read -r line; do
    echo "### $line" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "Generated: $OUTPUT_FILE"
```

## 7. 簡易変換スクリプト（汎用）

### quick-convert.py
```python
#!/usr/bin/env python3
import sys
import re

def convert_to_markdown(input_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 基本的な変換ルール
    # HTMLタグを除去
    content = re.sub(r'<[^>]+>', '', content)
    
    # 見出しっぽい行を変換
    content = re.sub(r'^([A-Z][A-Za-z\s]+):$', r'## \1', content, flags=re.MULTILINE)
    
    # コードブロックを検出
    content = re.sub(r'```(\w+)?\n(.*?)\n```', r'```\1\n\2\n```', content, flags=re.DOTALL)
    
    # リスト項目
    content = re.sub(r'^[-*]\s+', '- ', content, flags=re.MULTILINE)
    content = re.sub(r'^\d+\.\s+', '1. ', content, flags=re.MULTILINE)
    
    # 強調
    content = re.sub(r'\*\*(.*?)\*\*', r'**\1**', content)
    content = re.sub(r'__(.*?)__', r'**\1**', content)
    
    return content

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: quick-convert.py <input_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = input_file.rsplit('.', 1)[0] + '.md'
    
    markdown = convert_to_markdown(input_file)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(markdown)
    
    print(f"Converted: {output_file}")
```

## まとめ

1. **手動作成が最も確実**: LLMが理解しやすい形式で書く
2. **自動変換は出発点**: 生成後に手動で調整が必要
3. **重要な情報を優先**: 使用例、エラー処理、社内固有情報
4. **定期的な更新**: バージョンアップ時に忘れずに更新

これらのツールと手法を組み合わせて、効果的なドキュメントを作成してください。