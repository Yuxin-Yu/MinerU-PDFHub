##[
  Comprehensive tests for Config Manager - 100% coverage
]##

import unittest, os, strutils
import ../src/config_manager

suite "Config Manager Comprehensive Tests":
  let testConfigDir = "/tmp/opencontext7_config_test"
  let testConfigPath = testConfigDir / "test_config.yaml"
  
  setup:
    removeDir(testConfigDir)
    createDir(testConfigDir)
    putEnv("OPENCONTEXT7_CONFIG", testConfigPath)
  
  teardown:
    removeDir(testConfigDir)
    delEnv("OPENCONTEXT7_CONFIG")

  test "Get default config":
    let config = getDefaultConfig()
    
    check config.server.host == "localhost"
    check config.server.port == 8080
    check config.server.transport == "stdio"
    check config.storage.dataDir == getHomeDir() / ".opencontext7" / "data"
    check config.storage.maxLibraries == 1000
    check config.storage.maxDocSize == 10 * 1024 * 1024
    check config.security.enableAuth == false
    check config.security.apiKeys.len == 0
    check config.security.allowedIps == @["127.0.0.1"]

  test "Get config path":
    let path = getConfigPath()
    check path == testConfigPath
    check dirExists(path.parentDir())

  test "Save and load config":
    let config = Config(
      server: ServerConfig(
        host: "0.0.0.0",
        port: 9090,
        transport: "http"
      ),
      storage: StorageConfig(
        dataDir: "/custom/data/dir",
        maxLibraries: 500,
        maxDocSize: 5 * 1024 * 1024
      ),
      security: SecurityConfig(
        enableAuth: true,
        apiKeys: @["key1", "key2"],
        allowedIps: @["192.168.1.1", "10.0.0.1"]
      )
    )
    
    saveConfig(config, testConfigPath)
    check fileExists(testConfigPath)
    
    let loadedConfig = loadConfig(testConfigPath)
    check loadedConfig.server.host == "0.0.0.0"
    check loadedConfig.server.port == 9090
    check loadedConfig.server.transport == "http"
    check loadedConfig.storage.dataDir == "/custom/data/dir"
    check loadedConfig.storage.maxLibraries == 500
    check loadedConfig.storage.maxDocSize == 5 * 1024 * 1024
    check loadedConfig.security.enableAuth == true
    check loadedConfig.security.apiKeys == @["key1", "key2"]
    check loadedConfig.security.allowedIps == @["192.168.1.1", "10.0.0.1"]

  test "Save config with default path":
    let config = getDefaultConfig()
    saveConfig(config)  # Should use default path
    
    let defaultPath = getConfigPath()
    check defaultPath == testConfigPath
    check fileExists(defaultPath)

  test "Load config from non-existent file":
    let config = loadConfig(testConfigPath)
    
    # Should create default config and save it
    check fileExists(testConfigPath)
    check config.server.host == "localhost"
    check config.server.port == 8080

  test "Load config with default path":
    let config = loadConfig()  # Should use default path
    
    let defaultPath = getConfigPath()
    check defaultPath == testConfigPath
    check fileExists(defaultPath)
    check config.server.host == "localhost"

  test "Load config with partial content":
    let partialYaml = """
server:
  host: custom-host
  port: 3000

storage:
  dataDir: /tmp/custom
"""
    writeFile(testConfigPath, partialYaml)
    
    let config = loadConfig(testConfigPath)
    
    # Should load specified values
    check config.server.host == "custom-host"
    check config.server.port == 3000
    check config.storage.dataDir == "/tmp/custom"
    
    # Should use defaults for unspecified values
    check config.server.transport == "stdio"  # default
    check config.storage.maxLibraries == 1000  # default

  test "Load config with invalid YAML":
    let invalidYaml = """
invalid yaml content
  this is not: valid: yaml:
    - malformed
"""
    writeFile(testConfigPath, invalidYaml)
    
    let config = loadConfig(testConfigPath)
    
    # Should return default config on parsing error
    check config.server.host == "localhost"
    check config.server.port == 8080

  test "Load config with mixed valid/invalid entries":
    let mixedYaml = """
server:
  host: valid-host
  port: invalid-port-string
  transport: http

storage:
  dataDir: /valid/path
  maxLibraries: invalid-number
  maxDocSize: 2048

security:
  enableAuth: invalid-boolean
"""
    writeFile(testConfigPath, mixedYaml)
    
    let config = loadConfig(testConfigPath)
    
    # Should use valid values where possible
    check config.server.host == "valid-host"
    check config.server.transport == "http"
    check config.storage.dataDir == "/valid/path"
    check config.storage.maxDocSize == 2048
    
    # Should use defaults for invalid values
    check config.server.port == 8080  # default due to parsing error
    check config.storage.maxLibraries == 1000  # default due to parsing error
    check config.security.enableAuth == false  # default due to parsing error

  test "Save config with empty arrays":
    let config = Config(
      server: ServerConfig(
        host: "test",
        port: 8080,
        transport: "stdio"
      ),
      storage: StorageConfig(
        dataDir: "/test",
        maxLibraries: 100,
        maxDocSize: 1024
      ),
      security: SecurityConfig(
        enableAuth: false,
        apiKeys: @[],  # empty array
        allowedIps: @[]  # empty array
      )
    )
    
    saveConfig(config, testConfigPath)
    
    let content = readFile(testConfigPath)
    check "apiKeys: []" in content or "apiKeys: [" in content
    check "allowedIps: []" in content or "allowedIps: [" in content

  test "Save config with special characters":
    let config = Config(
      server: ServerConfig(
        host: "host-with-dashes",
        port: 8080,
        transport: "stdio"
      ),
      storage: StorageConfig(
        dataDir: "/path/with spaces/and-dashes",
        maxLibraries: 100,
        maxDocSize: 1024
      ),
      security: SecurityConfig(
        enableAuth: true,
        apiKeys: @["key-with-dashes", "key with spaces"],
        allowedIps: @["192.168.1.0/24"]
      )
    )
    
    saveConfig(config, testConfigPath)
    check fileExists(testConfigPath)
    
    let loadedConfig = loadConfig(testConfigPath)
    check loadedConfig.server.host == "host-with-dashes"
    check loadedConfig.storage.dataDir == "/path/with spaces/and-dashes"

  test "Config validation - boolean parsing":
    let boolTestCases = [
      ("true", true),
      ("True", true), 
      ("TRUE", true),
      ("false", false),
      ("False", false),
      ("FALSE", false),
      ("yes", false),  # Should default to false for invalid
      ("no", false),   # Should default to false for invalid
      ("1", false),    # Should default to false for invalid
      ("0", false)     # Should default to false for invalid
    ]
    
    for (boolStr, expected) in boolTestCases:
      let yaml = "security:\n  enableAuth: " & boolStr
      writeFile(testConfigPath, yaml)
      
      let config = loadConfig(testConfigPath)
      if expected:
        check config.security.enableAuth == true
      else:
        check config.security.enableAuth == false

  test "Config validation - integer parsing":
    let intTestCases = [
      ("8080", 8080),
      ("0", 0),
      ("65535", 65535),
      ("-1", 8080),      # Should default to 8080 for invalid
      ("abc", 8080),     # Should default to 8080 for invalid
      ("8080.5", 8080),  # Should default to 8080 for invalid
      ("", 8080)         # Should default to 8080 for invalid
    ]
    
    for (intStr, expected) in intTestCases:
      let yaml = "server:\n  port: " & intStr
      writeFile(testConfigPath, yaml)
      
      let config = loadConfig(testConfigPath)
      check config.server.port == expected

  test "Config with very long values":
    let longString = "x".repeat(1000)
    let yaml = "server:\n  host: " & longString
    writeFile(testConfigPath, yaml)
    
    let config = loadConfig(testConfigPath)
    check config.server.host == longString

  test "Config with unicode characters":
    let yaml = """
server:
  host: ホスト名
  port: 8080

storage:
  dataDir: /パス/日本語
"""
    writeFile(testConfigPath, yaml)
    
    let config = loadConfig(testConfigPath)
    check config.server.host == "ホスト名"
    check config.storage.dataDir == "/パス/日本語"

  test "Config directory creation":
    let deepPath = testConfigDir / "deep" / "nested" / "path" / "config.yaml"
    let config = getDefaultConfig()
    
    saveConfig(config, deepPath)
    check fileExists(deepPath)
    check dirExists(deepPath.parentDir())

  test "Config overwrite existing file":
    let config1 = getDefaultConfig()
    let config2 = Config(
      server: ServerConfig(host: "changed", port: 9999, transport: "http"),
      storage: config1.storage,
      security: config1.security
    )
    
    saveConfig(config1, testConfigPath)
    let content1 = readFile(testConfigPath)
    
    saveConfig(config2, testConfigPath)
    let content2 = readFile(testConfigPath)
    
    check content1 != content2
    check "changed" in content2
    check "9999" in content2
