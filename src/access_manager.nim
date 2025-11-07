##[
  Access Control Manager - handles multi-user roles and permissions
  访问控制管理器：负责多用户场景下的角色与令牌管理
]##

import std/[json, os, strutils, tables, options, random, sequtils]
import config_manager

const
  TokenAlphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  TokenLength = 56

randomize()

type
  RoleDefinition* = object
    name*: string
    permissions*: seq[string]

  UserAccount* = object
    username*: string
    token*: string
    password*: string
    role*: string
    libraries*: seq[string]
    active*: bool

  AccessManager* = ref object
    config*: AccessControlConfig
    roles*: Table[string, RoleDefinition]
    users*: Table[string, UserAccount]           ## keyed by username
    tokenIndex*: Table[string, string]            ## token -> username

proc refresh*(manager: AccessManager) {.gcsafe.}
proc saveUsers*(manager: AccessManager) {.gcsafe.}

proc randomString(length: int): string =
  if length <= 0:
    return ""
  result = newString(length)
  for i in 0 ..< length:
    result[i] = TokenAlphabet[rand(TokenAlphabet.len - 1)]

# 密码哈希函数已不再需要，因为现在使用明文密码存储

proc sanitizeLibraries(libs: seq[string]): seq[string] =
  var cleaned: seq[string] = @[]
  for entry in libs:
    let trimmed = entry.strip()
    if trimmed.len == 0:
      continue
    var duplicate = false
    for existing in cleaned:
      if existing == trimmed:
        duplicate = true
        break
    if not duplicate:
      cleaned.add(trimmed)
  cleaned

proc ensureDir(path: string) =
  let dir = path.parentDir()
  if dir.len > 0:
    createDir(dir)

proc ensureRoles(manager: AccessManager) =
  ensureDir(manager.config.rolesFile)
  if fileExists(manager.config.rolesFile):
    return
  let defaultRoles = %*{
    "roles": [
      {"name": "admin", "permissions": ["*"]},
      {"name": "editor", "permissions": ["read", "write", "git.sync", "import", "export", "backup"]},
      {"name": "viewer", "permissions": ["read"]}
    ]
  }
  writeFile(manager.config.rolesFile, defaultRoles.pretty())

proc ensureUsers(manager: AccessManager) =
  ensureDir(manager.config.usersFile)
  if fileExists(manager.config.usersFile):
    return
  var root = newJObject()
  root["users"] = newJArray()
  writeFile(manager.config.usersFile, root.pretty())

proc roleFromJson(node: JsonNode): RoleDefinition =
  result.name = if node.hasKey("name"): node["name"].getStr() else: ""
  if node.hasKey("permissions") and node["permissions"].kind == JArray:
    for item in node["permissions"]:
      if item.kind == JString:
        result.permissions.add(item.getStr())

proc roleToJson(role: RoleDefinition): JsonNode =
  %*{
    "name": role.name,
    "permissions": role.permissions
  }

proc userFromJson(node: JsonNode): UserAccount =
  result.username = if node.hasKey("username"): node["username"].getStr() else: ""
  result.token = if node.hasKey("token"): node["token"].getStr() else: ""
  result.password = if node.hasKey("password"): node["password"].getStr() else: ""
  # 向后兼容：如果旧文件中有 passwordHash，尝试使用它（虽然不推荐）
  if node.hasKey("passwordHash"):
    result.password = node["passwordHash"].getStr()
    # echo "DEBUG: Migrated old password hash for user: ", result.username
  result.role = if node.hasKey("role"): node["role"].getStr() else: ""
  if node.hasKey("libraries") and node["libraries"].kind == JArray:
    for item in node["libraries"]:
      if item.kind == JString:
        result.libraries.add(item.getStr())
  result.libraries = sanitizeLibraries(result.libraries)
  result.active = if node.hasKey("active"): node["active"].getBool() else: true

proc userToJson(user: UserAccount): JsonNode =
  %*{
    "username": user.username,
    "token": user.token,
    "password": user.password,
    "role": user.role,
    "libraries": user.libraries,
    "active": user.active
  }

proc generateToken(manager: AccessManager, length: int = TokenLength): string =
  var attempt = 0
  while true:
    inc attempt
    var candidate = randomString(length + (if attempt > 10: attempt div 4 else: 0))
    if candidate.len == 0:
      continue
    if candidate notin manager.tokenIndex:
      return candidate

proc setPassword(user: var UserAccount, password: string) =
  if password.len == 0:
    raise newException(ValueError, "Password cannot be empty")
  user.password = password

proc resolveRole(manager: AccessManager, desired, fallback: string): string =
  let trimmedDesired = desired.strip()
  if trimmedDesired.len > 0 and trimmedDesired in manager.roles:
    return trimmedDesired
  let trimmedFallback = fallback.strip()
  if trimmedFallback.len > 0 and trimmedFallback in manager.roles:
    return trimmedFallback
  if "viewer" in manager.roles:
    return "viewer"
  if "admin" in manager.roles:
    return "admin"
  for name in manager.roles.keys:
    return name
  trimmedDesired

proc storeUser(manager: AccessManager, user: UserAccount) =
  if user.username.len == 0:
    raise newException(ValueError, "Username cannot be empty")
  var entry = user
  entry.libraries = sanitizeLibraries(entry.libraries)
  if entry.token.len == 0 or
     (entry.token in manager.tokenIndex and manager.tokenIndex[entry.token] != entry.username):
    entry.token = manager.generateToken()
  if entry.username in manager.users:
    let previous = manager.users[entry.username]
    if previous.token.len > 0 and previous.token != entry.token and previous.token in manager.tokenIndex:
      manager.tokenIndex.del(previous.token)
  manager.users[entry.username] = entry
  manager.tokenIndex[entry.token] = entry.username

## 根据配置初始化访问控制管理器并加载数据
proc newAccessManager*(config: AccessControlConfig): AccessManager =
  result = AccessManager(
    config: config,
    roles: initTable[string, RoleDefinition](),
    users: initTable[string, UserAccount](),
    tokenIndex: initTable[string, string]()
  )
  result.refresh()

## 从磁盘重新加载角色与用户信息
proc refresh*(manager: AccessManager) {.gcsafe.} =
  manager.roles.clear()
  manager.users.clear()
  manager.tokenIndex.clear()
  ensureRoles(manager)
  ensureUsers(manager)

  try:
    let rolesContent = readFile(manager.config.rolesFile)
    if rolesContent.len > 0:
      let root = parseJson(rolesContent)
      if root.kind == JObject and root.hasKey("roles"):
        for roleNode in root["roles"]:
          let role = roleFromJson(roleNode)
          if role.name.len > 0:
            manager.roles[role.name] = role
  except JsonParsingError:
    discard

  var mutated = false
  try:
    let usersContent = readFile(manager.config.usersFile)
    # echo "DEBUG: Loading users from file: ", usersContent
    if usersContent.len > 0:
      let root = parseJson(usersContent)
      if root.kind == JObject and root.hasKey("users"):
        for userNode in root["users"]:
          var user = userFromJson(userNode)
          # echo "DEBUG: Loaded user: ", user.username, " with password: ", user.password
          if user.username.len == 0:
            continue
          if user.token.len == 0 or (user.token in manager.tokenIndex):
            user.token = manager.generateToken()
            mutated = true
          manager.storeUser(user)
  except JsonParsingError:
    discard

  if mutated:
    manager.saveUsers()

## 将当前角色配置写回文件
proc saveRoles*(manager: AccessManager) =
  ensureDir(manager.config.rolesFile)
  var arr = newJArray()
  for _, role in manager.roles:
    arr.add(roleToJson(role))
  var root = newJObject()
  root["roles"] = arr
  writeFile(manager.config.rolesFile, root.pretty())

## 将当前用户配置写回文件
proc saveUsers*(manager: AccessManager) {.gcsafe.} =
  ensureDir(manager.config.usersFile)
  var arr = newJArray()
  for _, user in manager.users:
    # echo "DEBUG: Saving user: ", user.username, " with password: ", user.password
    arr.add(userToJson(user))
  var root = newJObject()
  root["users"] = arr
  let jsonOutput = root.pretty()
  # echo "DEBUG: Writing users file: ", jsonOutput
  writeFile(manager.config.usersFile, jsonOutput)

## 新增或更新角色定义
proc addOrUpdateRole*(manager: AccessManager, role: RoleDefinition) =
  if role.name.len == 0:
    raise newException(ValueError, "Role name cannot be empty")
  manager.roles[role.name] = RoleDefinition(
    name: role.name,
    permissions: role.permissions
  )
  manager.saveRoles()

## 删除指定名称的角色
proc removeRole*(manager: AccessManager, name: string): bool =
  if name in manager.roles:
    manager.roles.del(name)
    manager.saveRoles()
    return true
  false

## 新增或更新用户信息
proc addOrUpdateUser*(manager: AccessManager, user: UserAccount) =
  manager.storeUser(user)
  manager.saveUsers()

## 停用用户令牌
proc deactivateUser*(manager: AccessManager, token: string): bool =
  if token in manager.tokenIndex:
    let username = manager.tokenIndex[token]
    if username in manager.users:
      var entry = manager.users[username]
      if entry.active:
        entry.active = false
        manager.users[username] = entry
        manager.saveUsers()
      return true
  false

## 重新激活用户令牌
proc activateUser*(manager: AccessManager, token: string): bool =
  if token in manager.tokenIndex:
    let username = manager.tokenIndex[token]
    if username in manager.users:
      var entry = manager.users[username]
      if not entry.active:
        entry.active = true
        manager.users[username] = entry
        manager.saveUsers()
      return true
  false

## 永久删除用户记录
proc removeUser*(manager: AccessManager, token: string): bool =
  if token in manager.tokenIndex:
    let username = manager.tokenIndex[token]
    manager.tokenIndex.del(token)
    if username in manager.users:
      manager.users.del(username)
      manager.saveUsers()
      return true
  false

## 根据令牌检索用户信息
proc getUserByToken*(manager: AccessManager, token: string): Option[UserAccount] =
  if token in manager.tokenIndex:
    let username = manager.tokenIndex[token]
    if username in manager.users:
      return some(manager.users[username])
  none(UserAccount)

## 根据用户名检索用户
proc getUserByName*(manager: AccessManager, username: string): Option[UserAccount] =
  let key = username.strip()
  if key.len == 0:
    return none(UserAccount)
  if key in manager.users:
    return some(manager.users[key])
  none(UserAccount)

## 注册新账号。首个账号自动授予管理员角色。
proc registerUser*(manager: AccessManager, username, password: string, role: string = "",
                   libraries: seq[string] = @[]): UserAccount =
  let key = username.strip()
  if key.len == 0:
    raise newException(ValueError, "Username cannot be empty")
  if password.len == 0:
    raise newException(ValueError, "Password cannot be empty")
  if key in manager.users:
    raise newException(ValueError, "Username already exists")

  let isFirstUser = manager.users.len == 0
  let desiredRole = if isFirstUser: "admin" else: role
  let finalRole = manager.resolveRole(desiredRole, manager.config.defaultRole)

  var user = UserAccount(
    username: key,
    role: finalRole,
    libraries: sanitizeLibraries(libraries),
    active: true
  )
  user.setPassword(password)
  # echo "DEBUG: In registerUser, after setPassword: ", user.password
  user.token = manager.generateToken()
  manager.users[user.username] = user
  manager.tokenIndex[user.token] = user.username
  manager.saveUsers()
  # echo "DEBUG: In registerUser, after saveUsers: ", manager.users[user.username].password
  user

## 更新已有账号的角色、库范围或密码
proc updateUser*(manager: AccessManager, username: string, role: string,
                 libraries: seq[string], active: bool, password: Option[string] = none(string),
                 rotateToken = false): UserAccount =
  let key = username.strip()
  if key.len == 0 or key notin manager.users:
    raise newException(ValueError, "User not found")

  var user = manager.users[key]
  if role.len > 0:
    user.role = manager.resolveRole(role, user.role)
  user.libraries = sanitizeLibraries(libraries)
  user.active = active

  var shouldRotate = rotateToken
  if password.isSome():
    let newPassword = password.get()
    user.setPassword(newPassword)
    shouldRotate = true

  if shouldRotate:
    let previousToken = user.token
    user.token = manager.generateToken()
    if previousToken.len > 0 and previousToken in manager.tokenIndex:
      manager.tokenIndex.del(previousToken)
  manager.users[key] = user
  manager.tokenIndex[user.token] = key
  manager.saveUsers()
  user

## 刷新指定用户的访问令牌
proc rotateToken*(manager: AccessManager, username: string): string =
  let key = username.strip()
  if key.len == 0 or key notin manager.users:
    raise newException(ValueError, "User not found")
  var user = manager.users[key]
  let previousToken = user.token
  user.token = manager.generateToken()
  manager.users[key] = user
  if previousToken.len > 0 and previousToken in manager.tokenIndex:
    manager.tokenIndex.del(previousToken)
  manager.tokenIndex[user.token] = key
  manager.saveUsers()
  user.token

## 认证用户名与密码，成功后刷新访问令牌
proc authenticate*(manager: AccessManager, username, password: string): Option[UserAccount] =
  let key = username.strip()
  # echo "DEBUG: Trying to authenticate user: '", key, "'"
  # echo "DEBUG: Available users: ", toSeq(manager.users.keys())
  if key.len == 0 or key notin manager.users:
    # echo "DEBUG: User not found or empty username"
    return none(UserAccount)
  var user = manager.users[key]
  # echo "DEBUG: User found, active: ", user.active, ", password len: ", user.password.len
  if not user.active:
    # echo "DEBUG: User is inactive"
    return none(UserAccount)
  if user.password.len == 0:
    # echo "DEBUG: User password is empty"
    return none(UserAccount)
  # echo "DEBUG: Input password: '", password, "', stored password: '", user.password, "'"
  if password != user.password:
    # echo "DEBUG: Passwords do not match"
    return none(UserAccount)
  let previousToken = user.token
  user.token = manager.generateToken()
  manager.users[key] = user
  if previousToken.len > 0 and previousToken in manager.tokenIndex:
    manager.tokenIndex.del(previousToken)
  manager.tokenIndex[user.token] = key
  manager.saveUsers()
  some(user)

## 检查角色是否具备目标权限（支持通配符）
proc roleHasPermission*(manager: AccessManager, roleName: string, permission: string): bool =
  if roleName notin manager.roles:
    return false
  let role = manager.roles[roleName]
  for allowed in role.permissions:
    if allowed == "*" or allowed == permission:
      return true
    if allowed.len > 2 and allowed.endsWith(".*"):
      let prefix = allowed[0 ..< allowed.len - 2]
      if prefix.len == 0:
        return true
      if permission == prefix or permission.startsWith(prefix & "."):
        return true
  false

## 判断用户是否拥有指定权限
proc userHasPermission*(manager: AccessManager, token: string, permission: string): bool =
  let userOpt = manager.getUserByToken(token)
  if userOpt.isNone():
    return false
  let user = userOpt.get()
  if not user.active:
    return false
  manager.roleHasPermission(user.role, permission)

## 若启用库范围限制，校验用户是否可访问指定库
proc userAllowedForLibrary*(manager: AccessManager, token, libraryName: string): bool =
  if not manager.config.enforceLibraryScope:
    return true
  let userOpt = manager.getUserByToken(token)
  if userOpt.isNone():
    return false
  let user = userOpt.get()
  if user.libraries.len == 0:
    return true
  libraryName in user.libraries
