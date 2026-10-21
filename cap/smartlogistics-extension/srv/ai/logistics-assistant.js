import { readFileSync } from 'node:fs'
import { OrchestrationClient } from '@sap-ai-sdk/orchestration'
import {
  retrieveRelevantKnowledge,
  formatKnowledgeContext
} from './knowledge-retriever.js'

const CONFIG_FILE = new URL(
  '../../ai/smartlogistics-assistant-orchestration.json',
  import.meta.url
)

const orchestrationConfig = JSON.parse(
  readFileSync(CONFIG_FILE, 'utf8')
)

const orchestrationClient = new OrchestrationClient(
  orchestrationConfig,
  {
    resourceGroup:
      process.env.SAP_AI_RESOURCE_GROUP || 'default'
  }
)

function normalizeText(value) {
  return String(value ?? '').trim()
}

function parseHistory(history) {

  if (!history) {
    return []
  }

  try {
    const parsed =
      typeof history === 'string'
        ? JSON.parse(history)
        : history

    return Array.isArray(parsed)
      ? parsed
      : []
  }
  catch {
    return []
  }
}

function createMockResponse({
  message,
  history,
  shipment,
  incidents
}) {

  const conversationHistory =
    parseHistory(history)

  const question =
    normalizeText(message).toLowerCase()

  const knowledgeMatches =
    retrieveRelevantKnowledge(
      message,
      { limit: 3 }
    )

  const groundedContext =
    formatKnowledgeContext(
      knowledgeMatches
    )

  const lastAssistantMessage =
    [...conversationHistory]
      .reverse()
      .find(entry => entry.role === 'assistant')
      ?.content ?? ''

  const openIncidents =
    incidents.filter(
      incident =>
        !['RESOLVED', 'CLOSED'].includes(
          incident.status
        )
    )

  const severeIncidents =
    openIncidents.filter(
      incident =>
        ['HIGH', 'CRITICAL'].includes(
          incident.severity
        )
    )

  const contextSummary = [
    `Shipment ${shipment.shipmentNumber}`,
    `status ${shipment.status}`,
    `from ${shipment.originCity} to ${shipment.destinationCity}`,
    `weather risk ${shipment.weatherRisk ?? 'UNKNOWN'}`,
    `${openIncidents.length} open incident(s)`
  ].join(', ')

  let answer

  const isKnowledgeQuestion =
    knowledgeMatches.length > 0 &&
    (
      question.includes('procedure') ||
      question.includes('policy') ||
      question.includes('what should i do') ||
      question.includes('what do i do') ||
      question.includes('how should') ||
      question.includes('how do') ||
      question.includes('temperature') ||
      question.includes('delay') ||
      question.includes('weather') ||
      question.includes('route') ||
      question.includes('reroute') ||
      question.includes('escalat') ||
      question.includes('resolve')
    )

  if (isKnowledgeQuestion) {

    const primaryKnowledge =
      knowledgeMatches[0]

    answer =
      `According to the SmartLogistics knowledge base, ` +
      `the relevant procedure is "${primaryKnowledge.documentTitle}", ` +
      `section "${primaryKnowledge.heading}".\n\n` +
      primaryKnowledge.content
  }
  else if (
    question.includes('risk') ||
    question.includes('riesgo')
  ) {

    if (severeIncidents.length > 0) {
      answer =
        `${contextSummary}. The main operational risk is the presence of ` +
        `${severeIncidents.length} high-severity open incident(s).`
    }
    else if (
      ['HIGH', 'MEDIUM'].includes(
        shipment.weatherRisk
      )
    ) {
      answer =
        `${contextSummary}. The main identified risk is the ` +
        `${shipment.weatherRisk} weather risk at the destination.`
    }
    else {
      answer =
        `${contextSummary}. No high-priority operational risk is ` +
        `currently identified from the available shipment data.`
    }
  }
  else if (
    question.includes('incident') ||
    question.includes('incidente')
  ) {

    if (openIncidents.length === 0) {
      answer =
        `${contextSummary}. There are currently no open incidents.`
    }
    else {
      const descriptions =
        openIncidents.map(
          incident =>
            `${incident.incidentNumber}: ${incident.title} ` +
            `(${incident.severity}, ${incident.status})`
        )

      answer =
        `${contextSummary}. Current incidents: ` +
        descriptions.join('; ') + '.'
    }
  }
  else if (
    question.includes('weather') ||
    question.includes('tiempo') ||
    question.includes('clima')
  ) {

    answer =
      `${contextSummary}. Current destination weather condition is ` +
      `${shipment.weatherSummary ?? 'unknown'} with ` +
      `${shipment.weatherRisk ?? 'UNKNOWN'} logistics risk.`
  }
  else if (
    lastAssistantMessage &&
    (
      question.includes('what should i do') ||
      question.includes('what next') ||
      question.includes('and now') ||
      question.includes('qué hago') ||
      question.includes('que hago') ||
      question.includes('qué debo hacer') ||
      question.includes('que debo hacer')
    )
  ) {
    answer =
      `${contextSummary}. Based on our previous exchange, the next step ` +
      `is to review the current shipment status, active incidents and ` +
      `any operational risks before deciding whether intervention is required.`
  }
  else {
    answer =
      `${contextSummary}. Based on the available SmartLogistics data, ` +
      `the shipment should be monitored together with its incidents, ` +
      `delivery status and destination weather conditions.`
  }

  const suggestedActions = []

  if (isKnowledgeQuestion && knowledgeMatches.length > 0) {

    const primaryKnowledgeForActions =
      knowledgeMatches[0]

    const groundedBullets =
      primaryKnowledgeForActions.content
        .split('\n')
        .map(line => line.trim())
        .filter(
          line =>
            line.startsWith('- ')
        )
        .map(
          line =>
            line
              .slice(2)
              .trim()
              .replace(/[;.]$/, '')
        )

    let groundedActions

    if (
      primaryKnowledgeForActions.heading ===
      'Four-Hour Escalation Rule'
    ) {
      groundedActions = [
        'Escalate the shipment delay to HIGH when the estimated delay exceeds 4 hours.',
        ...groundedBullets
          .slice(0, 4)
          .map(
            condition =>
              `Check whether ${condition}`
          )
      ]
    } else if (
      primaryKnowledgeForActions.heading ===
      'Route Decision Guidance'
    ) {
      groundedActions = [
        'Confirm with the carrier whether the planned route is blocked or unsafe.',
        'Check whether severe weather is expected along the planned route.',
        'Evaluate whether the estimated delay on the current route is operationally acceptable.',
        'Compare alternative routes and choose a safer or more reliable option when appropriate.'
      ]
    } else {
      groundedActions =
        groundedBullets.slice(0, 5)
    }

    suggestedActions.push(
      ...groundedActions
    )
  }

  if (
    suggestedActions.length === 0 &&
    severeIncidents.length > 0
  ) {
    suggestedActions.push(
      'Review high-severity incidents with the logistics operator.'
    )
  }

  if (
    suggestedActions.length === 0 &&
    ['HIGH', 'MEDIUM'].includes(
      shipment.weatherRisk
    )
  ) {
    suggestedActions.push(
      'Monitor destination weather conditions and reassess the route if necessary.'
    )
  }

  if (
    suggestedActions.length === 0 &&
    shipment.status === 'DELAYED'
  ) {
    suggestedActions.push(
      'Confirm the updated estimated arrival time with the carrier.'
    )
  }

  if (suggestedActions.length === 0) {
    suggestedActions.push(
      'Continue monitoring the shipment status and active incidents.'
    )
  }

  const sources =
    isKnowledgeQuestion
      ? knowledgeMatches.map(
          match =>
            `${match.documentTitle} — ${match.heading}`
        )
      : []

  return {
    answer,
    suggestedActions,
    sources
  }
}

function formatIncidentsForPrompt(incidents) {

  if (!Array.isArray(incidents) || incidents.length === 0) {
    return 'No incidents are currently registered for this shipment.'
  }

  return incidents
    .map(
      incident =>
        [
          `Incident ${incident.incidentNumber}`,
          `Title: ${incident.title ?? ''}`,
          `Description: ${incident.description ?? ''}`,
          `Severity: ${incident.severity ?? ''}`,
          `Status: ${incident.status ?? ''}`
        ].join(' | ')
    )
    .join('\n')
}

function validateAssistantResponse(response) {

  if (
    !response ||
    typeof response !== 'object' ||
    typeof response.answer !== 'string' ||
    !Array.isArray(response.suggestedActions)
  ) {
    throw new Error(
      'Invalid response returned by SmartLogistics AI Assistant'
    )
  }

  return response
}

function parseAssistantResponse(content) {

  if (
    content &&
    typeof content === 'object'
  ) {
    return validateAssistantResponse(content)
  }

  const text = String(content ?? '')
    .trim()
    .replace(/^```(?:json)?\s*/i, '')
    .replace(/\s*```$/, '')

  return validateAssistantResponse(
    JSON.parse(text)
  )
}

export async function askLogisticsAssistant(input) {

  const mode =
    (
      process.env.SMARTLOGISTICS_AI_MODE ||
      'mock'
    ).toLowerCase()

  if (mode === 'mock') {
    return createMockResponse(input)
  }

  if (mode !== 'sap') {
    throw new Error(
      `Unsupported SMARTLOGISTICS_AI_MODE: ${mode}`
    )
  }

  const hasAiCoreBinding =
    Boolean(process.env.AICORE_SERVICE_KEY) ||
    (
      process.env.VCAP_SERVICES &&
      process.env.VCAP_SERVICES.includes('"aicore"')
    )

  if (!hasAiCoreBinding) {
    throw new Error(
      'SAP AI Core credentials are not configured'
    )
  }

  const {
    message,
    history,
    shipment,
    incidents
  } = input

  const messagesHistory =
    parseHistory(history)
      .filter(
        entry =>
          ['user', 'assistant', 'system'].includes(entry.role) &&
          typeof entry.content === 'string'
      )
      .map(
        entry => ({
          role: entry.role,
          content: entry.content
        })
      )

  const response =
    await orchestrationClient.chatCompletion({
      placeholderValues: {
        shipmentNumber:
          String(shipment.shipmentNumber ?? ''),
        shipmentStatus:
          String(shipment.status ?? ''),
        originCity:
          String(shipment.originCity ?? ''),
        originCountry:
          String(shipment.originCountry ?? ''),
        destinationCity:
          String(shipment.destinationCity ?? ''),
        destinationCountry:
          String(shipment.destinationCountry ?? ''),
        carrier:
          String(shipment.carrier ?? ''),
        trackingNumber:
          String(shipment.trackingNumber ?? ''),
        plannedDeparture:
          String(shipment.plannedDeparture ?? ''),
        plannedArrival:
          String(shipment.plannedArrival ?? ''),
        weatherRisk:
          String(shipment.weatherRisk ?? 'UNKNOWN'),
        weatherCondition:
          String(shipment.weatherSummary ?? 'Unknown'),
        incidents:
          formatIncidentsForPrompt(incidents),
        message:
          String(message ?? '')
      },
      messagesHistory
    })

  return parseAssistantResponse(
    response.getContent()
  )
}
