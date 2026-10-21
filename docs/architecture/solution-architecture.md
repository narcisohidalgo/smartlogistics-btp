# Solution Architecture

## Implemented topology

```mermaid
flowchart TD
    PO["Fiori Orders"] --> ABAP["ABAP Cloud\nCDS and RAP"]
    ABAP --> CPI["Integration Suite\nOrder synchronization"]
    CPI --> CAP["SAP CAP\nNode.js logistics service"]
    LOG["Fiori Logistics\nSAPUI5 extensions"] --> CAP
    CAP --> HANA[("SAP HANA Cloud")]
    CAP --> WEATHER["Open-Meteo"]
    CAP --> AI["SAP AI Core\nOrchestration"]
    WORKZONE["SAP Build Work Zone"] --> LOG
```

## Data ownership

| System | Owned entities | External reference/context |
|---|---|---|
| ABAP Cloud | Supplier, Product, PurchaseOrder, PurchaseOrderItem | None in v1.0 |
| SAP CAP / HANA Cloud | Shipment, Package, Incident | Purchase-order ID from ABAP |
| Open-Meteo | Geocoding and forecast data | Normalized values stored on Shipment |

The same master entity is not independently writable in ABAP Cloud and CAP. CAP stores the purchase-order identifier required for logistics traceability; ABAP remains the source of truth.

## Implemented integration paths

### Approved order: ABAP Cloud → Integration Suite → CAP

1. An approved purchase order is exposed by the RAP OData V4 service.
2. The published Integration Suite flow obtains/transforms the order payload.
3. The CAP logistics API receives the shipment creation request.
4. CAP rejects a second shipment for the same purchase-order identifier with `409 Conflict`.
5. HANA Cloud persists the logistics record.

### Weather: CAP → Open-Meteo

1. An Operator runs `refreshWeather` for a shipment.
2. CAP geocodes the destination city.
3. CAP requests the forecast for the planned-arrival date.
4. Deterministic rules classify LOW, MEDIUM or HIGH risk.
5. CAP stores the forecast and risk fields on the shipment.

Open-Meteo is called directly by CAP. There is no separate weather iFlow in the delivered implementation.

### AI actions

- `analyzeIncident` combines incident and shipment context and returns a validated structured analysis.
- `askAssistant` combines shipment, incidents, weather data and conversation history.
- `SMARTLOGISTICS_AI_MODE=sap` activates SAP AI SDK orchestration with a bound AI Core service.
- The default `mock` mode provides deterministic local responses and supports automated tests.
- The local lexical retriever supplies relevant excerpts and source labels from project-owned documents; it is not vector RAG.

## Security model

- ABAP DCL and RAP controls protect procurement data and actions.
- XSUAA defines `Viewer`, `Operator` and `Supervisor` scopes and role templates.
- BTP role collections map business users to those application roles.
- CAP `@requires` and `@restrict` rules protect entities and bound actions.
- Work Zone and the Destination service forward the authenticated JWT to CAP.
- Integration credentials remain in BTP security material/service bindings and are not committed.

## Deployment topology

The CAP multi-target application contains:

- Node.js service module;
- HANA HDI deployer and container;
- Fiori HTML5 module and HTML5 Application Repository content;
- XSUAA service;
- Destination service with JWT forwarding.

Generated `gen`, `dist`, `mta_archives` and `*.mtar` outputs are intentionally excluded from Git.

## Grounding boundary

SAP Document Grounding was validated as a separate Basic Trial experiment. The repository retains an orchestration configuration as technical evidence, while the runnable local assistant uses a deterministic lexical retriever. These are two distinct capabilities and are documented separately.
