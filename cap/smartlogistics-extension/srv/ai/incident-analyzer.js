import { readFileSync } from 'node:fs'
import { OrchestrationClient } from '@sap-ai-sdk/orchestration'

const CONFIG_FILE = new URL(
  '../../ai/smartlogistics-incident-analyzer-orchestration.json',
  import.meta.url
)

const rawConfiguration = JSON.parse(
  readFileSync(CONFIG_FILE, 'utf8')
)

const promptTemplating =
  rawConfiguration?.config?.modules?.prompt_templating

if (!promptTemplating) {
  throw new Error(
    'Invalid SmartLogistics AI orchestration configuration'
  )
}

const orchestrationClient = new OrchestrationClient(
  {
    promptTemplating
  },
  {
    resourceGroup:
      process.env.SAP_AI_RESOURCE_GROUP || 'default'
  }
)

function normalizeInput(input) {
  return {
    incidentTitle:
      input.incidentTitle ?? '',
    incidentDescription:
      input.incidentDescription ?? '',
    incidentSeverity:
      input.incidentSeverity ?? '',
    incidentStatus:
      input.incidentStatus ?? '',
    shipmentNumber:
      input.shipmentNumber ?? '',
    shipmentStatus:
      input.shipmentStatus ?? '',
    originCity:
      input.originCity ?? '',
    originCountry:
      input.originCountry ?? '',
    destinationCity:
      input.destinationCity ?? '',
    destinationCountry:
      input.destinationCountry ?? '',
    weatherRisk:
      input.weatherRisk ?? 'UNKNOWN',
    weatherCondition:
      input.weatherCondition ?? 'Unknown'
  }
}

function validateAnalysis(analysis) {
  const priorities = [
    'LOW',
    'MEDIUM',
    'HIGH',
    'CRITICAL'
  ]

  if (
    !analysis ||
    typeof analysis !== 'object' ||
    typeof analysis.summary !== 'string' ||
    typeof analysis.probableCause !== 'string' ||
    typeof analysis.operationalImpact !== 'string' ||
    !priorities.includes(analysis.priority) ||
    !Array.isArray(analysis.recommendedActions)
  ) {
    throw new Error(
      'Invalid response returned by AI Incident Analyzer'
    )
  }

  return analysis
}

function parseAnalysis(content) {

  if (
    content &&
    typeof content === 'object'
  ) {
    return validateAnalysis(content)
  }

  const text = String(content ?? '')
    .trim()
    .replace(/^```(?:json)?\s*/i, '')
    .replace(/\s*```$/, '')

  return validateAnalysis(
    JSON.parse(text)
  )
}

function createMockAnalysis(input) {

  const priority =
    ['HIGH', 'CRITICAL'].includes(input.incidentSeverity)
      ? input.incidentSeverity
      : input.weatherRisk === 'HIGH'
        ? 'HIGH'
        : input.incidentSeverity || 'MEDIUM'

  return {
    summary:
      `Incident "${input.incidentTitle}" affects shipment ` +
      `${input.shipmentNumber} from ${input.originCity} to ` +
      `${input.destinationCity}.`,

    probableCause:
      input.incidentDescription ||
      'The cause cannot be determined from the available data.',

    operationalImpact:
      `Shipment ${input.shipmentNumber} may be affected while ` +
      `its current status is ${input.shipmentStatus}. ` +
      `Weather risk is ${input.weatherRisk}.`,

    priority,

    recommendedActions: [
      'Review the incident details with the logistics operator.',
      'Confirm the current shipment status with the carrier.',
      'Monitor the shipment and update the incident when new information is available.'
    ]
  }
}

export async function analyzeIncidentWithAI(input) {

  const normalizedInput =
    normalizeInput(input)

  const mode =
    (
      process.env.SMARTLOGISTICS_AI_MODE ||
      'mock'
    ).toLowerCase()

  if (mode !== 'sap') {
    return createMockAnalysis(
      normalizedInput
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

  const response =
    await orchestrationClient.chatCompletion({
      placeholderValues:
        normalizedInput
    })

  return parseAnalysis(
    response.getContent()
  )
}
