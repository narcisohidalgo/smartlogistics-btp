import cds from '@sap/cds'
import { analyzeIncidentWithAI } from './ai/incident-analyzer.js'
import { askLogisticsAssistant } from './ai/logistics-assistant.js'

const { SELECT, UPDATE } = cds.ql

export default class LogisticsService extends cds.ApplicationService {

  async init() {

    const { Shipments, Packages, Incidents } = this.entities

    this.after('READ', Shipments, async shipments => {

      const rows = Array.isArray(shipments)
        ? shipments
        : [shipments]

      for (const shipment of rows) {

        if (!shipment?.ID) continue

        const packages = await SELECT
          .from(Packages)
          .where({ shipment_ID: shipment.ID })

        shipment.packageCount = packages.length

        shipment.totalWeight = packages.reduce(
          (total, pkg) => total + Number(pkg.weight ?? 0),
          0
        )
      }
    })

    this.before(['CREATE', 'UPDATE'], Shipments, async req => {

      const { purchaseOrderId } = req.data
      if (!purchaseOrderId) return

      const existingShipment = await SELECT.one
        .from(Shipments)
        .columns('ID')
        .where({ purchaseOrderId })

      const currentId = req.params?.at(-1)?.ID ?? req.data.ID

      if (existingShipment && existingShipment.ID !== currentId) {
        return req.reject(
          409,
          `Shipment already exists for ${purchaseOrderId}`
        )
      }
    })

    this.before(['CREATE', 'UPDATE'], Shipments, async req => {

      let { plannedDeparture, plannedArrival } = req.data

      if (
        req.event === 'UPDATE' &&
        (plannedDeparture === undefined || plannedArrival === undefined)
      ) {
        const currentId = req.params?.at(-1)?.ID ?? req.data.ID

        if (currentId) {
          const existingShipment = await SELECT.one
            .from(Shipments)
            .columns('plannedDeparture', 'plannedArrival')
            .where({ ID: currentId })

          if (plannedDeparture === undefined) {
            plannedDeparture = existingShipment?.plannedDeparture
          }

          if (plannedArrival === undefined) {
            plannedArrival = existingShipment?.plannedArrival
          }
        }
      }

      if (
        plannedDeparture &&
        plannedArrival &&
        new Date(plannedArrival) < new Date(plannedDeparture)
      ) {
        return req.reject(
          400,
          'Planned arrival cannot be earlier than planned departure'
        )
      }
    })

    this.on('markAsDelivered', Shipments, async req => {

      const { ID } = req.params[0]

      const shipment = await SELECT.one
        .from(Shipments)
        .where({ ID })

      if (!shipment) {
        return req.reject(
          404,
          'Shipment not found'
        )
      }

      if (shipment.status === 'DELIVERED') {
        return req.reject(
          400,
          'Shipment is already delivered'
        )
      }

      await UPDATE(Shipments)
        .set({
          status: 'DELIVERED',
          actualArrival: new Date().toISOString()
        })
        .where({ ID })

      return SELECT.one
        .from(Shipments)
        .where({ ID })
    })

        this.on('refreshWeather', Shipments, async req => {

      const { ID } = req.params[0]

      const shipment = await SELECT.one
        .from(Shipments)
        .where({ ID })

      if (!shipment) {
        return req.reject(
          404,
          'Shipment not found'
        )
      }

      if (!shipment.destinationCity) {
        return req.reject(
          400,
          'Destination city is missing'
        )
      }

      if (!shipment.plannedArrival) {
        return req.reject(
          400,
          'Planned arrival is missing'
        )
      }

      // ------------------------------------------------------------
      // 1. Convert destination country to ISO-3166 alpha-2
      // ------------------------------------------------------------

      const countryCodeMap = {
        ESP: 'ES',
        PRT: 'PT',
        FRA: 'FR',
        DEU: 'DE',
        ITA: 'IT',
        GBR: 'GB',
        USA: 'US'
      }

      const countryCode =
        countryCodeMap[shipment.destinationCountry]

      // ------------------------------------------------------------
      // 2. Geocode destination city
      // ------------------------------------------------------------

      const geocodingUrl =
        new URL('https://geocoding-api.open-meteo.com/v1/search')

      geocodingUrl.searchParams.set(
        'name',
        shipment.destinationCity
      )

      geocodingUrl.searchParams.set('count', '1')
      geocodingUrl.searchParams.set('language', 'en')
      geocodingUrl.searchParams.set('format', 'json')

      if (countryCode) {
        geocodingUrl.searchParams.set(
          'countryCode',
          countryCode
        )
      }

      const geocodingResponse =
        await fetch(geocodingUrl)

      if (!geocodingResponse.ok) {
        return req.reject(
          502,
          'Weather geocoding service failed'
        )
      }

      const geocodingData =
        await geocodingResponse.json()

      const location =
        geocodingData.results?.[0]

      if (!location) {
        return req.reject(
          404,
          `Destination city ${shipment.destinationCity} not found`
        )
      }

      // ------------------------------------------------------------
      // 3. Get shipment arrival date
      // ------------------------------------------------------------

      const forecastDate =
        new Date(shipment.plannedArrival)
          .toISOString()
          .slice(0, 10)

      // ------------------------------------------------------------
      // 4. Request weather forecast
      // ------------------------------------------------------------

      const forecastUrl =
        new URL('https://api.open-meteo.com/v1/forecast')

      forecastUrl.searchParams.set(
        'latitude',
        location.latitude
      )

      forecastUrl.searchParams.set(
        'longitude',
        location.longitude
      )

      forecastUrl.searchParams.set(
        'daily',
        [
          'weather_code',
          'temperature_2m_max',
          'temperature_2m_min',
          'precipitation_probability_max',
          'precipitation_sum',
          'wind_speed_10m_max'
        ].join(',')
      )

      forecastUrl.searchParams.set(
        'timezone',
        location.timezone || 'auto'
      )

      forecastUrl.searchParams.set(
        'start_date',
        forecastDate
      )

      forecastUrl.searchParams.set(
        'end_date',
        forecastDate
      )

      const forecastResponse =
        await fetch(forecastUrl)

      if (!forecastResponse.ok) {
        return req.reject(
          502,
          'Weather forecast service failed'
        )
      }

      const forecastData =
        await forecastResponse.json()

      if (!forecastData.daily?.time?.length) {
        return req.reject(
          404,
          `Weather forecast not available for ${forecastDate}`
        )
      }

      // ------------------------------------------------------------
      // 5. Extract forecast values
      // ------------------------------------------------------------

      const weatherCode =
        forecastData.daily.weather_code[0]

      const temperatureMax =
        forecastData.daily.temperature_2m_max[0]

      const temperatureMin =
        forecastData.daily.temperature_2m_min[0]

      const precipitationProbability =
        forecastData.daily.precipitation_probability_max[0]

      const precipitationSum =
        forecastData.daily.precipitation_sum[0]

      const windSpeedMax =
        forecastData.daily.wind_speed_10m_max[0]

      // ------------------------------------------------------------
      // 6. Convert WMO weather code to text
      // ------------------------------------------------------------

      const weatherDescriptions = {
        0: 'Clear sky',
        1: 'Mainly clear',
        2: 'Partly cloudy',
        3: 'Overcast',
        45: 'Fog',
        48: 'Depositing rime fog',
        51: 'Light drizzle',
        53: 'Moderate drizzle',
        55: 'Dense drizzle',
        56: 'Light freezing drizzle',
        57: 'Dense freezing drizzle',
        61: 'Slight rain',
        63: 'Moderate rain',
        65: 'Heavy rain',
        66: 'Light freezing rain',
        67: 'Heavy freezing rain',
        71: 'Slight snow',
        73: 'Moderate snow',
        75: 'Heavy snow',
        77: 'Snow grains',
        80: 'Slight rain showers',
        81: 'Moderate rain showers',
        82: 'Violent rain showers',
        85: 'Slight snow showers',
        86: 'Heavy snow showers',
        95: 'Thunderstorm',
        96: 'Thunderstorm with hail',
        99: 'Severe thunderstorm with hail'
      }

      const weatherSummary =
        weatherDescriptions[weatherCode] ??
        'Unknown weather condition'

      // ------------------------------------------------------------
      // 7. Calculate logistics weather risk
      // ------------------------------------------------------------

      const highRiskCodes =
        [65, 67, 75, 82, 86, 95, 96, 99]

      const mediumRiskCodes =
        [
          45, 48,
          51, 53, 55,
          56, 57,
          61, 63, 66,
          71, 73, 77,
          80, 81, 85
        ]

      let weatherRisk = 'LOW'

      if (
        highRiskCodes.includes(weatherCode) ||
        precipitationSum >= 15 ||
        windSpeedMax >= 60
      ) {
        weatherRisk = 'HIGH'
      }
      else if (
        mediumRiskCodes.includes(weatherCode) ||
        precipitationProbability >= 60 ||
        precipitationSum >= 5 ||
        windSpeedMax >= 35
      ) {
        weatherRisk = 'MEDIUM'
      }

      // ------------------------------------------------------------
      // 8. Persist weather information in Shipment
      // ------------------------------------------------------------

      await UPDATE(Shipments)
        .set({
          weatherRisk,
          weatherCode,
          weatherSummary,
          weatherForecastDate: forecastDate,
          weatherTemperatureMax: temperatureMax,
          weatherTemperatureMin: temperatureMin,
          weatherPrecipitationProbability:
            precipitationProbability,
          weatherPrecipitationSum:
            precipitationSum,
          weatherWindSpeedMax:
            windSpeedMax,
          weatherCheckedAt:
            new Date().toISOString()
        })
        .where({ ID })

      // ------------------------------------------------------------
      // 9. Return updated Shipment
      // ------------------------------------------------------------

      return SELECT.one
        .from(Shipments)
        .where({ ID })
    })





    this.on('askAssistant', Shipments, async req => {

      const { ID } = req.params.at(-1)
      const {
        message,
        history
      } = req.data

      if (!message?.trim()) {
        return req.reject(
          400,
          'Assistant message is required'
        )
      }

      const shipment = await SELECT.one
        .from(Shipments)
        .where({ ID })

      if (!shipment) {
        return req.reject(
          404,
          'Shipment not found'
        )
      }

      const incidents = await SELECT
        .from(Incidents)
        .where({ shipment_ID: ID })

      try {

        return await askLogisticsAssistant({
          message,
          history,
          shipment,
          incidents
        })

      }
      catch (error) {

        console.error(
          'Logistics AI Assistant failed:',
          error
        )

        return req.reject(
          502,
          'Logistics AI Assistant failed'
        )
      }
    })

    this.on('analyzeIncident', Incidents, async req => {

      const { ID } = req.params.at(-1)

      const incident = await SELECT.one
        .from(Incidents)
        .where({ ID })

      if (!incident) {
        return req.reject(
          404,
          'Incident not found'
        )
      }

      if (!incident.shipment_ID) {
        return req.reject(
          400,
          'Incident is not associated with a shipment'
        )
      }

      const shipment = await SELECT.one
        .from(Shipments)
        .where({ ID: incident.shipment_ID })

      if (!shipment) {
        return req.reject(
          404,
          'Shipment associated with incident not found'
        )
      }

      try {

        return await analyzeIncidentWithAI({
          incidentTitle: incident.title,
          incidentDescription: incident.description,
          incidentSeverity: incident.severity,
          incidentStatus: incident.status,

          shipmentNumber: shipment.shipmentNumber,
          shipmentStatus: shipment.status,

          originCity: shipment.originCity,
          originCountry: shipment.originCountry,

          destinationCity: shipment.destinationCity,
          destinationCountry: shipment.destinationCountry,

          weatherRisk: shipment.weatherRisk,
          weatherCondition: shipment.weatherSummary
        })

      }
      catch (error) {

        console.error(
          'AI Incident Analyzer failed:',
          error
        )

        return req.reject(
          502,
          'AI Incident Analyzer failed'
        )
      }
    })

    this.on('resolveIncident', Incidents, async req => {

  const { ID } = req.params.at(-1)

  const incident = await SELECT.one
    .from(Incidents)
    .where({ ID })

  if (!incident) {
    return req.reject(
      404,
      'Incident not found'
    )
  }

  if (incident.status === 'RESOLVED') {
    return req.reject(
      400,
      'Incident is already resolved'
    )
  }

  await UPDATE(Incidents)
    .set({
      status: 'RESOLVED',
      resolvedAt: new Date().toISOString()
    })
    .where({ ID })

  return SELECT.one
    .from(Incidents)
    .where({ ID })
})

    return super.init()
  }
}