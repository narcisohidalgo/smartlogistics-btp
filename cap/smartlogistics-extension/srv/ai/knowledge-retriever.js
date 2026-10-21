import {
  readFileSync,
  readdirSync
} from 'node:fs'

import {
  dirname,
  join
} from 'node:path'

import {
  fileURLToPath
} from 'node:url'

const __dirname =
  dirname(fileURLToPath(import.meta.url))

const KNOWLEDGE_DIR =
  join(__dirname, '../../ai/knowledge')

const STOP_WORDS = new Set([
  'a',
  'an',
  'and',
  'are',
  'as',
  'at',
  'be',
  'by',
  'for',
  'from',
  'how',
  'i',
  'if',
  'in',
  'is',
  'it',
  'of',
  'on',
  'or',
  'should',
  'the',
  'this',
  'to',
  'what',
  'when',
  'with',
  'do',
  'does',
  'my',
  'we',
  'me'
])

const SYNONYMS = {
  delayed: 'delay',
  delays: 'delay',
  late: 'delay',
  lateness: 'delay',

  temperature: 'temperature',
  thermal: 'temperature',
  cold: 'temperature',
  heat: 'temperature',

  weather: 'weather',
  rain: 'weather',
  storm: 'weather',
  wind: 'weather',

  reroute: 'route',
  rerouting: 'route',
  routing: 'route',

  escalate: 'escalation',
  escalated: 'escalation',
  escalating: 'escalation',

  incidents: 'incident',
  alerts: 'alert'
}

function normalizeToken(token) {

  const clean =
    token
      .toLowerCase()
      .replace(/[^a-z0-9_-]/g, '')

  if (!clean) return ''

  return SYNONYMS[clean] ?? clean
}

function tokenize(text) {

  return String(text ?? '')
    .split(/\s+/)
    .map(normalizeToken)
    .filter(
      token =>
        token &&
        token.length > 1 &&
        !STOP_WORDS.has(token)
    )
}

function splitDocument(
  fileName,
  content
) {

  const lines =
    content.split(/\r?\n/)

  const sections = []

  let documentTitle =
    fileName.replace(/\.md$/i, '')

  let currentHeading =
    documentTitle

  let currentLines = []

  function flushSection() {

    const body =
      currentLines
        .join('\n')
        .trim()

    if (!body) {
      currentLines = []
      return
    }

    sections.push({
      source: fileName,
      documentTitle,
      heading: currentHeading,
      content:
        `${currentHeading}\n\n${body}`
    })

    currentLines = []
  }

  for (const line of lines) {

    const heading =
      line.match(
        /^\s*\**(#{1,6})\s+(.+?)\**\s*$/
      )

    if (heading) {

      flushSection()

      const level =
        heading[1].length

      const title =
        heading[2]
          .replace(/\*\*/g, '')
          .trim()

      if (level === 1) {
        documentTitle = title
      }

      currentHeading = title
      continue
    }

    currentLines.push(line)
  }

  flushSection()

  return sections
}

function loadKnowledgeBase() {

  return readdirSync(KNOWLEDGE_DIR)
    .filter(
      fileName =>
        fileName.endsWith('.md')
    )
    .sort()
    .flatMap(fileName => {

      const content =
        readFileSync(
          join(KNOWLEDGE_DIR, fileName),
          'utf8'
        )

      return splitDocument(
        fileName,
        content
      )
    })
}

const KNOWLEDGE_SECTIONS =
  loadKnowledgeBase()

function scoreSection(
  section,
  queryTokens
) {

  const documentTitleTokens =
    tokenize(section.documentTitle)

  const headingTokens =
    tokenize(section.heading)

  const contentTokens =
    tokenize(section.content)

  let score = 0

  for (const queryToken of queryTokens) {

    const documentTitleMatches =
      documentTitleTokens.filter(
        token => token === queryToken
      ).length

    const headingMatches =
      headingTokens.filter(
        token => token === queryToken
      ).length

    const contentMatches =
      contentTokens.filter(
        token => token === queryToken
      ).length

    score +=
      documentTitleMatches * 8 +
      headingMatches * 5 +
      Math.min(contentMatches, 5)
  }

  const queryTokenSet =
    new Set(queryTokens)

  const normalizedHeading =
    section.heading.toLowerCase()

  if (
    queryTokenSet.has('route') &&
    normalizedHeading.includes(
      'route decision'
    )
  ) {
    score += 20
  }

  return score
}

export function retrieveRelevantKnowledge(
  query,
  {
    limit = 3
  } = {}
) {

  const queryTokens =
    tokenize(query)

  if (queryTokens.length === 0) {
    return []
  }

  return KNOWLEDGE_SECTIONS
    .map(section => ({
      ...section,
      score:
        scoreSection(
          section,
          queryTokens
        )
    }))
    .filter(
      section =>
        section.score > 0
    )
    .sort(
      (a, b) =>
        b.score - a.score
    )
    .slice(0, limit)
}

export function formatKnowledgeContext(
  matches
) {

  if (
    !Array.isArray(matches) ||
    matches.length === 0
  ) {
    return ''
  }

  return matches
    .map(
      (match, index) =>
        [
          `[Source ${index + 1}]`,
          `Document: ${match.documentTitle}`,
          `Section: ${match.heading}`,
          '',
          match.content
        ].join('\n')
    )
    .join('\n\n---\n\n')
}
