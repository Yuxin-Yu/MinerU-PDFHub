# OpenContext7 测试指南

本文档概述了 OpenContext7 的测试策略与执行方式，帮助你在本地或 CI 环境中验证功能完整性。

## 1. 测试分类

1. **库管理测试**：验证注册、查询、删除等核心操作。
2. **配置管理测试**：覆盖 YAML/环境变量解析与容错逻辑。
3. **CLI 测试**：确保命令行体验一致，包括帮助信息与参数校验。
4. **MCP 服务器测试**：整体验证 HTTP/SSE 接口、认证和工具路由。
5. **错误处理测试**：模拟异常输入与磁盘写入失败等边界情况。
6. **集成测试**：串联 CLI、存储层与 UI API，确保端到端路径可用。

## 2. 运行全部测试

```bash
nimble test
```

`nimble test` 会编译并运行 `tests/test_all.nim`，该入口会依次调用所有单测与集成测试文件。执行过程中会设置 `OPENCONTEXT7_SKIP_SERVER=1`，避免真实服务器阻塞控制台。

## 3. 常用测试任务

| 命令 | 说明 |
| --- | --- |
| `nimble test` | 运行全部测试套件（默认）。 |
| `nimble test_comprehensive` | 顺序执行所有模块化测试，输出更详细的日志。 |
| `nimble test_verbose` | 打印每个测试文件的执行记录。 |
| `nimble test_coverage` | 打开 `lineTrace`，生成覆盖率基础数据。 |

## 4. 单独运行示例

```bash
nim c -r tests/test_library_manager.nim
nim c -r tests/test_config_manager.nim
nim c -r tests/test_opencontext7_server.nim
```

如需对 HTTP/SSE 传输进行专项验证，可运行：

```bash
nim c -r tests/test_transport_modes.nim
```

测试会在 `/tmp/opencontext7_*_test` 下生成临时目录，执行结束后会自动清理。

## 5. CI 建议

- 在 CI 中先执行 `nimble build`，确保主程序能成功编译。
- 之后运行 `nimble test`。若需要覆盖率数据，可在 CI 中追加 `nimble test_coverage`。
- 推荐缓存 `nimcache/` 目录以加速后续构建。

## 6. 调试技巧

- 使用 `nim c --stackTrace:on --lineTrace:on` 可快速定位 panic 堆栈。
- 遇到端口占用时，将 `tests/config/test_config.yaml` 中的端口调整为未占用的值。
- 若 Git 同步测试过慢，可设置环境变量 `OPENCONTEXT7_GIT_BOOTSTRAP=false` 以跳过初始 clone。

## 7. 预期结果

通过上述步骤后，应看到测试套件输出 “All test suites completed!” 类似的成功信息。若任一测试失败，请根据堆栈排查具体模块并提交修复。
