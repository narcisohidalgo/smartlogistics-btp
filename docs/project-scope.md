# Project Scope — Version 1.0

## Product vision

SmartLogistics BTP gives procurement and logistics teams a shared, traceable flow from purchase-order approval to shipment-risk resolution. It uses a fictional agri-food business so the demo remains credible and connected to real supply-chain concerns.

## Actors

| Actor | Responsibilities | Planned role collection |
|---|---|---|
| Procurement Manager | Maintain suppliers and products; create and approve purchase orders | `SmartLogistics_Procurement` |
| Logistics Manager | Monitor shipments, tracking, incidents, risks and AI recommendations | `SmartLogistics_Logistics` |
| Administrator | Configure SAP BTP services, security, roles and integrations | `SmartLogistics_Admin` |

## Functional requirements

### Procurement core

- Maintain supplier master data.
- Maintain product master data.
- Create purchase orders and composed items.
- Set the initial order status to `NEW`.
- Calculate item amount as quantity multiplied by unit price.
- Calculate total order amount as the sum of item amounts.
- Validate supplier, product, quantity and delivery date.
- Approve orders only from `NEW`.
- Cancel orders according to the permitted lifecycle.

### Logistics extension

- Create a shipment from an approved purchase order.
- Store only the external order reference, not a duplicate order master.
- Record tracking events for a shipment.
- Maintain shipment status and risk level.
- Create and resolve logistics incidents.
- Persist AI recommendations linked to incidents.

### Integration

- Transfer approved purchase orders from ABAP Cloud to CAP.
- Transform the core order payload into the logistics payload.
- Obtain weather data for the relevant route or destination.
- Route risky weather conditions to incident creation.
- Record and expose integration errors in a traceable way.

### User experience

- Provide a Fiori elements List Report and Object Page for purchase orders.
- Provide a Fiori elements List Report and Object Page for shipments.
- Display tracking, incidents and recommendations on the shipment Object Page.
- Provide a SAPUI5 freestyle AI assistant.
- Apply role-based access to procurement, logistics and administration functions.

### Artificial intelligence

- Analyze shipment and incident context.
- Return a structured risk summary, likely impact and recommended action.
- Persist generated recommendations for auditability.
- Ground answers using project-owned policies and procedures in the RAG increment.

## Core business states

### Purchase order

`NEW` → `APPROVED` → `IN_PROCESS` → `SHIPPED` → `COMPLETED`

`CANCELLED` is a terminal alternative allowed only by defined transition rules.

### Shipment

- `PLANNED`
- `IN_TRANSIT`
- `DELAYED`
- `DELIVERED`
- `CANCELLED`

### Risk

- `LOW`
- `MEDIUM`
- `HIGH`
- `CRITICAL`

## Definition of done for v1.0

The project is considered complete when the happy path works end to end, automated tests cover its critical rules, security roles are demonstrated, deployment instructions are reproducible, and the repository contains architecture documentation, screenshots, API examples, and a concise demo script.

## Out of scope

- Warehouse and inventory management
- Invoicing and payments
- Transportation optimization
- Real-time GPS devices
- Native mobile application
- IoT and blockchain
- Predictive machine-learning models
- Production service-level commitments
