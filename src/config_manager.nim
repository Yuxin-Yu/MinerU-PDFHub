##[
  Configuration Manager - Handles server configuration
]##

import std/[os, strutils, tables]
import yaml

type
  ServerConfig* = object
    host*: string
    port*: int
    transport*: string  # "stdio", "http", "sse"
    
  StorageConfig* = object
    dataDir*: string
    maxLibraries*: int
    maxDocSize*: int  # in bytes
    
  SecurityConfig* = object
    enableAuth*: bool
    apiKeys*: seq[string]
    allowedIps*: seq[string]
    
  Config* = object
    server*: ServerConfig
    storage*: StorageConfig
    security*: SecurityConfig

proc getDefaultConfig*(): Config =
  Config(
    server: ServerConfig(
      host: "localhost",
      port: 8080,
      transport: "stdio"
    ),
    storage: StorageConfig(
      dataDir: getHomeDir() / ".context7local" / "data",
      maxLibraries: 1000,
      maxDocSize: 10 * 1024 * 1024  # 10MB
    ),
    security: SecurityConfig(
      enableAuth: false,
      apiKeys: @[],
      allowedIps: @["127.0.0.1"]
    )
  )

proc getConfigPath*(): string =
  let configDir = getHomeDir() / ".context7local"
  createDir(configDir)
  return configDir / "config.yaml"

proc saveConfig*(config: Config, path: string = "") =
  let configPath = if path == "": getConfigPath() else: path
  
  # Simple YAML writing since nim yaml is complex
  var content = """
server:
  host: """ & config.server.host & """
  port: """ & $config.server.port & """
  transport: """ & config.server.transport & """

storage:
  dataDir: """ & config.storage.dataDir & """
  maxLibraries: """ & $config.storage.maxLibraries & """
  maxDocSize: """ & $config.storage.maxDocSize & """

security:
  enableAuth: """ & $config.security.enableAuth & """
  apiKeys: [""" & config.security.apiKeys.join(", ") & """]
  allowedIps: [""" & config.security.allowedIps.join(", ") & """]
"""
  
  writeFile(configPath, content)

proc loadConfig*(path: string = ""): Config =
  let configPath = if path == "": getConfigPath() else: path
  
  if not fileExists(configPath):
    let defaultConfig = getDefaultConfig()
    saveConfig(defaultConfig, configPath)
    return defaultConfig
  
  try:
    # Simple YAML parsing for basic config
    let content = readFile(configPath)
    var config = getDefaultConfig()
    
    for line in content.splitLines():
      let trimmed = line.strip()
      if trimmed.startsWith("host:"):
        config.server.host = trimmed.split(": ")[1].strip()
      elif trimmed.startsWith("port:"):
        config.server.port = parseInt(trimmed.split(": ")[1].strip())
      elif trimmed.startsWith("transport:"):
        config.server.transport = trimmed.split(": ")[1].strip()
      elif trimmed.startsWith("dataDir:"):
        config.storage.dataDir = trimmed.split(": ")[1].strip()
      elif trimmed.startsWith("maxLibraries:"):
        config.storage.maxLibraries = parseInt(trimmed.split(": ")[1].strip())
      elif trimmed.startsWith("maxDocSize:"):
        config.storage.maxDocSize = parseInt(trimmed.split(": ")[1].strip())
      elif trimmed.startsWith("enableAuth:"):
        config.security.enableAuth = parseBool(trimmed.split(": ")[1].strip())
    
    return config
  except:
    # Return default config if parsing fails
    return getDefaultConfig()