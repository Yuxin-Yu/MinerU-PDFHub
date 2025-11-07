##[
  主题匹配工具集（借鉴 OpenEA 框架的知识图谱对齐思路）
  
  本模块将文档中的“三级标题 + 代码示例”视作知识图谱中的实体节点，提供三类经典匹配算法：
  1. **Literal Align（字面匹配）**：依靠标题、正文、语言标签、代码文本等显性信息进行词汇匹配；
  2. **Structure Aware（结构传播）**：在字面匹配分数的基础上，引入相邻章节的影响，模拟图结构传播；
  3. **Embedding Sim（语义嵌入）**：以词频向量近似章节语义，通过余弦相似度衡量语义相似度。
  
  通过组合这些算法，可以评估不同知识匹配策略对 get_library_docs 工具结果以及 LLM 上下文的影响。
]##

import std/[strutils, sequtils, tables, algorithm, math, sets]
import library_manager

# ------------------------------------------------------------------------------
# 类型定义
# ------------------------------------------------------------------------------

type
  ## 支持的主题匹配算法枚举
  TopicMatchAlgorithm* = enum
    tmaLiteralAlign,       ## 基于字面信息的对齐
    tmaStructureAware,     ## 基于邻域传播的结构对齐
    tmaEmbeddingSim        ## 基于语义向量的对齐
  
  ## 单个章节的匹配结果
  MatchedSection* = object
    idx*: int              ## 章节索引（对应 Library.sections 中的位置）
    score*: float          ## 综合得分
    matchedTopics*: seq[int] ## 命中的主题索引集合

# ------------------------------------------------------------------------------
# 算法选择辅助
# ------------------------------------------------------------------------------

proc availableTopicMatchAlgorithms*(): seq[string] =
  ## 返回当前可选的对齐算法名称（供外部展示或校验）
  @["literal", "structure", "embedding"]

proc parseTopicMatchAlgorithm*(name: string): TopicMatchAlgorithm =
  ## 将用户输入的算法名称解析为内部枚举
  let lowered = name.toLowerAscii()
  case lowered
  of "structure", "structural", "graph":
    tmaStructureAware
  of "embedding", "vector", "semantic":
    tmaEmbeddingSim
  of "", "literal", "label", "default":
    tmaLiteralAlign
  else:
    tmaLiteralAlign

proc algorithmToString*(algorithm: TopicMatchAlgorithm): string =
  ## 将枚举值转换为可读字符串
  case algorithm
  of tmaLiteralAlign: "literal"
  of tmaStructureAware: "structure"
  of tmaEmbeddingSim: "embedding"

# ------------------------------------------------------------------------------
# 章节特征描述与结构
# ------------------------------------------------------------------------------

type
  ## 章节分析后的特征集合
  SectionProfile = object
    titleLower: string               ## 标题（小写）
    contentLower: string             ## 正文内容（小写）
    codeLower: string                ## 汇总后的代码文本（小写）
    languages: seq[string]           ## 代码语言标签
    tokenSet: HashSet[string]        ## 所有 token（去重）
    tokenWeights: Table[string, float] ## token 频次
    vectorNorm: float                ## 频次向量的模长
  
  ## 匹配计算中的中间得分
  SectionScore = object
    score: float
    topicScores: seq[float]
    matchedTopics: seq[int]

# ------------------------------------------------------------------------------
# Token 化工具函数
# ------------------------------------------------------------------------------

proc extractTokens(text: string): seq[string] =
  ## 将字符串按字母/数字/下划线切分为 token，忽略其他符号
  var current = ""
  for ch in text:
    let lower = ch.toLowerAscii()
    if (lower >= 'a' and lower <= 'z') or (lower >= '0' and lower <= '9') or lower == '_':
      current.add(lower)
    else:
      if current.len > 0:
        result.add(current)
        current.setLen(0)
  if current.len > 0:
    result.add(current)

proc accumulateTokens(text: string, tokens: var HashSet[string], weights: var Table[string, float]) =
  ## 将文本 token 统计到集合与词频表中
  for tok in extractTokens(text):
    tokens.incl(tok)
    if tok in weights:
      weights[tok] += 1.0
    else:
      weights[tok] = 1.0

# ------------------------------------------------------------------------------
# 章节特征分析
# ------------------------------------------------------------------------------

proc analyseSection(section: LibrarySection): SectionProfile =
  ## 对章节进行全面分析，提取标题、正文、代码、语言等信息
  var profile: SectionProfile
  profile.titleLower = section.title.toLowerAscii()
  profile.contentLower = section.content.toLowerAscii()
  profile.languages = @[]
  profile.tokenSet = initHashSet[string]()
  profile.tokenWeights = initTable[string, float]()
  
  let combinedText = profile.titleLower & " " & profile.contentLower
  accumulateTokens(combinedText, profile.tokenSet, profile.tokenWeights)
  
  var codeCollector = newStringOfCap(128)
  for sample in section.codeSamples:
    let langLower = sample.language.toLowerAscii()
    if langLower.len > 0:
      profile.languages.add(langLower)
      profile.tokenSet.incl(langLower)
      if langLower in profile.tokenWeights:
        profile.tokenWeights[langLower] += 1.0
      else:
        profile.tokenWeights[langLower] = 1.0
    let codeLower = sample.code.toLowerAscii()
    if codeCollector.len > 0:
      codeCollector.add("\n")
    codeCollector.add(codeLower)
    accumulateTokens(codeLower, profile.tokenSet, profile.tokenWeights)
  profile.codeLower = codeCollector
  
  var norm = 0.0
  for val in profile.tokenWeights.values:
    norm += val * val
  profile.vectorNorm = sqrt(norm)
  return profile

# ------------------------------------------------------------------------------
# 主题特征构建（集合 / 向量）
# ------------------------------------------------------------------------------

proc computeTopicTokenSets(topicsLower: seq[string]): seq[HashSet[string]] =
  ## 为每个主题构建 token 集合，便于计算集合重合度
  result = newSeq[HashSet[string]](topicsLower.len)
  for idx, topic in topicsLower.pairs:
    result[idx] = initHashSet[string]()
    for tok in extractTokens(topic):
      result[idx].incl(tok)

proc computeTopicWeightVectors(topicsLower: seq[string]): tuple[weights: seq[Table[string, float]], norms: seq[float]] =
  ## 为每个主题构建词频向量及其模长，用于余弦相似度
  var w = newSeq[Table[string, float]](topicsLower.len)
  var n = newSeq[float](topicsLower.len)
  for idx, topic in topicsLower.pairs:
    w[idx] = initTable[string, float]()
    for tok in extractTokens(topic):
      if tok in w[idx]:
        w[idx][tok] += 1.0
      else:
        w[idx][tok] = 1.0
    var norm = 0.0
    for val in w[idx].values:
      norm += val * val
    n[idx] = if norm == 0.0: 0.0 else: sqrt(norm)
  (w, n)

# ------------------------------------------------------------------------------
# 匹配算法实现
# ------------------------------------------------------------------------------

proc computeLiteralScores(profiles: seq[SectionProfile], topicsLower: seq[string], topicTokens: seq[HashSet[string]]): seq[SectionScore] =
  ## 字面匹配：综合标题、正文、语言标签、代码文本的直接匹配情况
  result = newSeq[SectionScore](profiles.len)
  for idx, profile in profiles.pairs:
    var perTopic = newSeq[float](topicsLower.len)
    var matched: seq[int] = @[]
    var total = 0.0
    for topicIdx, term in topicsLower.pairs:
      if term.len == 0:
        continue
      var topicScore = 0.0
      if profile.titleLower.contains(term):
        topicScore += 3.0
      if profile.contentLower.contains(term):
        topicScore += 1.5
      for lang in profile.languages:
        if lang.contains(term):
          topicScore += 2.0
          break
      if profile.codeLower.contains(term):
        topicScore += 1.0
      if topicScore == 0.0 and topicTokens[topicIdx].len > 0:
        var overlap = 0
        for tok in topicTokens[topicIdx]:
          if tok in profile.tokenSet:
            inc overlap
        if overlap > 0:
          topicScore += 0.75 * (float(overlap) / float(topicTokens[topicIdx].len))
      perTopic[topicIdx] = topicScore
      if topicScore > 0.0:
        matched.add(topicIdx)
        total += topicScore
    result[idx] = SectionScore(score: total, topicScores: perTopic, matchedTopics: matched)

proc applyStructuralPropagation(literalScores: seq[SectionScore]): seq[SectionScore] =
  ## 结构传播：对相邻章节（视作图中的相邻节点）进行分数传播，模拟结构对齐
  result = newSeq[SectionScore](literalScores.len)
  for idx in 0 ..< literalScores.len:
    let base = literalScores[idx]
    var perTopic = newSeq[float](base.topicScores.len)
    for topicIdx in 0 ..< base.topicScores.len:
      var value = base.topicScores[topicIdx]
      if idx > 0:
        value += 0.5 * literalScores[idx - 1].topicScores[topicIdx]
      if idx + 1 < literalScores.len:
        value += 0.5 * literalScores[idx + 1].topicScores[topicIdx]
      perTopic[topicIdx] = value
    var total = 0.0
    var matched: seq[int] = @[]
    for topicIdx, val in perTopic.pairs:
      if val > 0.0:
        matched.add(topicIdx)
        total += val
    result[idx] = SectionScore(score: total, topicScores: perTopic, matchedTopics: matched)

proc computeEmbeddingScores(profiles: seq[SectionProfile], topicWeights: seq[Table[string, float]], topicNorms: seq[float]): seq[SectionScore] =
  ## 向量匹配：通过余弦相似度来衡量章节与主题的语义接近程度
  result = newSeq[SectionScore](profiles.len)
  for idx, profile in profiles.pairs:
    var perTopic = newSeq[float](topicWeights.len)
    var matched: seq[int] = @[]
    var total = 0.0
    for topicIdx in 0 ..< topicWeights.len:
      if topicWeights[topicIdx].len == 0 or profile.vectorNorm == 0.0 or topicNorms[topicIdx] == 0.0:
        perTopic[topicIdx] = 0.0
        continue
      var dot = 0.0
      for token, weight in topicWeights[topicIdx].pairs:
        if token in profile.tokenWeights:
          dot += profile.tokenWeights[token] * weight
      let denom = profile.vectorNorm * topicNorms[topicIdx]
      let similarity = if denom == 0.0: 0.0 else: dot / denom
      let scaled = similarity * 5.0
      perTopic[topicIdx] = scaled
      if scaled > 0.0:
        matched.add(topicIdx)
        total += scaled
    result[idx] = SectionScore(score: total, topicScores: perTopic, matchedTopics: matched)

# ------------------------------------------------------------------------------
# 结果输出
# ------------------------------------------------------------------------------

proc toMatchedSections(scores: seq[SectionScore]): seq[MatchedSection] =
  ## 将内部得分结构转换为对外可用的匹配结果，并按得分排序
  for idx, scoreData in scores.pairs:
    if scoreData.score > 0.0:
      result.add(MatchedSection(
        idx: idx,
        score: scoreData.score,
        matchedTopics: scoreData.matchedTopics
      ))
  result.sort(proc(a, b: MatchedSection): int =
    let cmpScore = cmp(b.score, a.score)
    if cmpScore != 0:
      return cmpScore
    return cmp(a.idx, b.idx)
  )

proc matchSections*(sections: seq[LibrarySection], topics: seq[string], algorithm: TopicMatchAlgorithm): seq[MatchedSection] =
  ## 对外主接口：根据指定算法返回章节与主题的匹配结果
  if sections.len == 0 or topics.len == 0:
    return @[]
  var profiles: seq[SectionProfile] = @[]
  profiles.setLen(sections.len)
  for idx, section in sections.pairs:
    profiles[idx] = analyseSection(section)
  
  let topicsLower = topics.mapIt(it.toLowerAscii())
  let topicTokens = computeTopicTokenSets(topicsLower)
  let literalScores = computeLiteralScores(profiles, topicsLower, topicTokens)
  
  case algorithm
  of tmaLiteralAlign:
    return toMatchedSections(literalScores)
  of tmaStructureAware:
    return toMatchedSections(applyStructuralPropagation(literalScores))
  of tmaEmbeddingSim:
    let (weights, norms) = computeTopicWeightVectors(topicsLower)
    return toMatchedSections(computeEmbeddingScores(profiles, weights, norms))
