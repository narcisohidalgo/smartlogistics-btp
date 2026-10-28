import cds from '@sap/cds'

const {
  GET,
  POST,
  PATCH,
  expect,
  defaults
} = cds.test()

defaults.path = '/logistics'

defaults.auth = {
  username: 'viewer',
  password: 'viewer'
}

describe('LogisticsService - Shipments', () => {

  it('allows Viewer to read shipments', async () => {

    const {
      data,
      status
    } = await GET `/Shipments?$top=1`

    expect(status).to.equal(200)

    expect(data.value)
      .to.be.an('array')
      .with.length(1)

    expect(data.value[0])
      .to.have.property('shipmentNumber')
  })

  it('forbids Viewer from using AI Assistant', async () => {

    const {
      data: shipments
    } = await GET `/Shipments?$top=1`

    const shipmentId =
      shipments.value[0].ID

    const response = await POST(
      `/Shipments(${shipmentId})/LogisticsService.askAssistant`,
      {
        message: 'What is the shipment status?',
        history: '[]'
      },
      {
        auth: {
          username: 'viewer',
          password: 'viewer'
        },
        validateStatus:
          status => status === 403
      }
    )

    expect(response.status)
      .to.equal(403)
  })

  it('allows Operator to use AI Assistant', async () => {

    const {
      data: shipments
    } = await GET `/Shipments?$top=1`

    const shipmentId =
      shipments.value[0].ID

    const response = await POST(
      `/Shipments(${shipmentId})/LogisticsService.askAssistant`,
      {
        message: 'What is the shipment status?',
        history: '[]'
      },
      {
        auth: {
          username: 'operator',
          password: 'operator'
        }
      }
    )

    expect(response.status)
      .to.equal(200)

    expect(response.data)
      .to.have.property('answer')

    expect(response.data.answer)
      .to.be.a('string')
      .and.not.empty
  })

  it('returns grounded knowledge sources for temperature guidance', async () => {

    const {
      data: shipments
    } = await GET(
      `/Shipments?$filter=shipmentNumber eq 'SHP000001'`
    )

    const shipmentId =
      shipments.value[0].ID

    const response = await POST(
      `/Shipments(${shipmentId})/LogisticsService.askAssistant`,
      {
        message:
          'What should I do with a medium temperature alert?',
        history: '[]'
      },
      {
        auth: {
          username: 'operator',
          password: 'operator'
        }
      }
    )

    expect(response.status)
      .to.equal(200)

    expect(response.data.answer)
      .to.include(
        'SmartLogistics Temperature Alert Procedure'
      )

    expect(response.data.sources)
      .to.be.an('array')
      .that.is.not.empty

    expect(response.data.sources[0])
      .to.include(
        'SmartLogistics Temperature Alert Procedure'
      )
  })

  it('allows Operator to mark a shipment as delivered', async () => {

    const {
      data: shipments
    } = await GET(
      `/Shipments?$filter=shipmentNumber eq 'SHP000001'`
    )

    const shipmentId =
      shipments.value[0].ID

    const response = await POST(
      `/Shipments(${shipmentId})/LogisticsService.markAsDelivered`,
      {},
      {
        auth: {
          username: 'operator',
          password: 'operator'
        }
      }
    )

    expect(response.status)
      .to.equal(200)

    expect(response.data.status)
      .to.equal('DELIVERED')

    expect(response.data.actualArrival)
      .to.be.a('string')
      .and.not.empty
  })

  it('allows Operator to resolve an incident', async () => {

    const {
      data: incidents
    } = await GET(
      `/Incidents?$filter=status ne 'RESOLVED'&$top=1`
    )

    expect(incidents.value)
      .to.be.an('array')
      .that.is.not.empty

    const incidentId =
      incidents.value[0].ID

    const response = await POST(
      `/Incidents(${incidentId})/LogisticsService.resolveIncident`,
      {},
      {
        auth: {
          username: 'operator',
          password: 'operator'
        }
      }
    )

    expect(response.status)
      .to.equal(200)

    expect(response.data.status)
      .to.equal('RESOLVED')

    expect(response.data.resolvedAt)
      .to.be.a('string')
      .and.not.empty
  })


  it('rejects a shipment when planned arrival is before departure', async () => {

    const response = await POST(
      '/Shipments',
      {
        shipmentNumber: 'SHP-INVALID-DATES',
        purchaseOrderId: 'PO-INVALID-DATES',
        carrier: 'Test Carrier',
        trackingNumber: 'TEST-INVALID-DATES',
        originCountry: 'ESP',
        originCity: 'Cordoba',
        destinationCountry: 'ESP',
        destinationCity: 'Madrid',
        plannedDeparture: '2026-10-20T12:00:00Z',
        plannedArrival: '2026-10-20T10:00:00Z'
      },
      {
        auth: {
          username: 'operator',
          password: 'operator'
        },
        validateStatus:
          status => status === 400
      }
    )

    expect(response.status)
      .to.equal(400)

    expect(response.data.error.message)
      .to.equal(
        'Planned arrival cannot be earlier than planned departure'
      )
  })


  it('rejects invalid dates in a partial shipment update', async () => {
    const shipmentId = '22222222-2222-2222-2222-222222222222'

    const response = await PATCH(
      `/Shipments(${shipmentId})`,
      { plannedArrival: '2026-09-29T00:00:00Z' },
      {
        auth: { username: 'operator', password: 'operator' },
        validateStatus: status => status === 400
      }
    )

    expect(response.status).to.equal(400)
    expect(response.data.error.message)
      .to.equal('Planned arrival cannot be earlier than planned departure')
  })

  it('rejects a duplicate purchase order on shipment update', async () => {
    const shipmentId = '22222222-2222-2222-2222-222222222222'

    const response = await PATCH(
      `/Shipments(${shipmentId})`,
      { purchaseOrderId: 'PO00000001' },
      {
        auth: { username: 'operator', password: 'operator' },
        validateStatus: status => status === 409
      }
    )

    expect(response.status).to.equal(409)
    expect(response.data.error.message)
      .to.equal('Shipment already exists for PO00000001')
  })

  it('rejects duplicate shipment for the same purchase order', async () => {

    const response = await POST(
      '/Shipments',
      {
        shipmentNumber: 'SHP-DUPLICATE-PO',
        purchaseOrderId: 'PO00000001',
        carrier: 'Test Carrier',
        trackingNumber: 'TEST-DUPLICATE-PO',
        originCountry: 'ESP',
        originCity: 'Cordoba',
        destinationCountry: 'ESP',
        destinationCity: 'Madrid',
        plannedDeparture: '2026-10-20T10:00:00Z',
        plannedArrival: '2026-10-20T18:00:00Z'
      },
      {
        auth: {
          username: 'operator',
          password: 'operator'
        },
        validateStatus:
          status => status === 409
      }
    )

    expect(response.status)
      .to.equal(409)

    expect(response.data.error.message)
      .to.equal(
        'Shipment already exists for PO00000001'
      )
  })

})
