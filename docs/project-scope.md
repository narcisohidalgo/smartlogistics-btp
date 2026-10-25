# Project Scope — Implemented Version 1.0

## Product vision

SmartLogistics BTP gives procurement and logistics teams a traceable flow from purchase-order approval to shipment monitoring and incident response. It uses the fictional agri-food company GreenFields Foods to connect the solution with realistic supply-chain concerns.

## Actors and authorization

| Actor | Responsibilities | Implemented access |
|---|---|---|
| Procurement Manager | Maintain procurement data and manage purchase orders | ABAP RAP purchase-order UI, draft handling and behavior validations |
| Logistics Viewer | Monitor shipments, packages, incidents and weather risk | `SmartLogistics_Viewer` |
| Logistics Operator | Update logistics data and execute operational/AI actions | `SmartLogistics_Operator` |
| Logistics Supervisor | Cumulative access and future privileged operations | `SmartLogistics_Supervisor` |
| Administrator | Configure BTP services, destinations, trust and role collections | BTP platform administration |

The current CAP service has Viewer and Operator enforcement. Supervisor is defined as a cumulative XSUAA role template and role collection; no Supervisor-only CAP action is implemented in v1.0.

## Delivered capabilities

### ABAP Cloud procurement core

- Supplier and product master data.
- Managed RAP purchase-order business object with composed items and draft handling.
- Initial business/logistics status, monetary calculations and business validations.
- `Send to Logistics` action plus CDS projection/service exposure through OData V4.
- Fiori elements List Report/Object Page.

ABAP Cloud is the system of record for the purchase order.

### CAP logistics extension

- `Shipments`, `Packages` and `Incidents` entities.
- External `purchaseOrderId` reference without duplicating the ABAP order master.
- Virtual package count and total weight calculated after reads.
- Prevention of duplicate shipments for one purchase order (`409`).
- Planned-arrival validation (`400`).
- `markAsDelivered`, `resolveIncident`, `refreshWeather`, `analyzeIncident` and `askAssistant` actions.
- SAP HANA Cloud persistence in production and SQLite-backed local/test execution.

`TrackingEvents` and persisted `AIRecommendations` were part of the original concept but are not present in the delivered CAP data model. AI analysis is returned as a structured action result rather than stored as a database entity.

### Integration

- Purchase orders are transferred from ABAP Cloud through SAP Integration Suite to CAP when **Send to Logistics** is executed.
- The integration maps the order payload to the shipment creation contract.
- Duplicate protection in CAP makes repeated creation for the same purchase-order ID fail with `409`.
- Open-Meteo is consumed directly by the CAP `refreshWeather` action; it is not implemented as a separate weather iFlow.

### Weather risk

- Destination city geocoding through Open-Meteo.
- Daily forecast retrieval for the planned arrival date.
- Storage of WMO weather code, summary, temperatures, precipitation, wind and check timestamp.
- Deterministic LOW/MEDIUM/HIGH risk classification.

Weather refresh updates the shipment. Automatic creation of an incident from a weather threshold is not implemented in v1.0.

### User experience

- Fiori elements purchase-order application over RAP OData V4.
- Fiori elements logistics List Report/Object Page over the CAP OData service.
- Shipment and incident operational actions.
- AI Incident Analyzer action surfaced from the Fiori UI.
- SAPUI5 dialog extension for shipment-aware assistant conversations.
- Deployment through HTML5 Application Repository and access from SAP Build Work Zone.

The AI Assistant is embedded in the logistics application; there is no separate freestyle application in v1.0.

### Artificial intelligence and grounding

- SAP AI SDK orchestration configuration for the Incident Analyzer and AI Assistant.
- Structured JSON-schema output validation.
- `sap` mode for bound SAP AI Core credentials.
- Deterministic `mock` mode for local development and automated tests.
- A real SAP Document Grounding experiment performed with Generative AI Hub Basic Trial.
- A separate local lexical retriever over three project-owned policies/procedures.

The local retriever scores tokens and headings. It is not vector search, is not SAP Document Grounding and must not be presented as either.

## Core business states

### Purchase order

- Business status: `NW` (`New`) in the delivered v1.0 behavior.
- Logistics integration status: `NEW` → `SENT` after a successful **Send to Logistics** action.

Separate Approve/Cancel business-state actions are not implemented in v1.0.

### Shipment

- `PLANNED`
- `IN_TRANSIT`
- `DELAYED`
- `DELIVERED`
- `CANCELLED`

### Incident

- `OPEN`
- `IN_PROGRESS`
- `RESOLVED`
- `CLOSED`

### Weather risk

- `UNKNOWN`
- `LOW`
- `MEDIUM`
- `HIGH`

## Verification completed

- End-to-end ABAP-to-CAP order integration.
- CAP/HANA Cloud deployment.
- Fiori Logistics access through Work Zone.
- JWT forwarding from Work Zone through Destination service to CAP.
- Role-based `200`, `401` and `403` responses.
- Business-rule `400` and duplicate `409` responses.
- Eight passing automated CAP tests.

## Portfolio status

Implementation phases **0–14 are complete**. The public portfolio now includes curated screenshots, the final architecture visual, security/testing evidence and an end-to-end demo guide.

Phase 15 covers CV, LinkedIn, recruiter outreach and interview/demo presentation material.

## Out of scope

- Warehouse and inventory management
- Invoicing and payments
- Transportation optimization
- Real-time GPS devices
- Native mobile application
- IoT and blockchain
- Predictive machine-learning models
- Production service-level commitments
