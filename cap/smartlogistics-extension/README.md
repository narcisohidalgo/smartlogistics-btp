# SmartLogistics CAP Extension

Deployable SAP CAP Node.js application for shipment operations, weather risk, incidents, AI assistance and the Fiori logistics UI.

## Implemented stack

- SAP CAP 10 / Node.js
- CDS service and persistence model
- SAP HANA Cloud through an HDI container
- SQLite for local development/tests
- SAP Fiori elements with SAPUI5 controller extensions
- Open-Meteo geocoding and forecast APIs
- SAP AI SDK orchestration
- XSUAA authorization
- HTML5 Application Repository and Destination service
- `@cap-js/cds-test`

## Domain model

| Entity | Purpose |
|---|---|
| `Shipments` | Order reference, route, schedule, status and weather snapshot |
| `Packages` | Composed package details and weights |
| `Incidents` | Shipment incident, severity, status and resolution timestamps |

The service also exposes virtual `packageCount` and `totalWeight` fields. `TrackingEvents` and persisted AI recommendations are not part of the delivered schema.

## Service actions

| Action | Role | Behavior |
|---|---|---|
| `markAsDelivered` | Operator | Sets `DELIVERED` and actual arrival time |
| `refreshWeather` | Operator | Retrieves Open-Meteo data and recalculates risk |
| `askAssistant` | Operator | Returns contextual answer, actions and local sources when applicable |
| `resolveIncident` | Operator | Sets `RESOLVED` and resolution time |
| `analyzeIncident` | Operator | Returns structured incident analysis |

All entities require Viewer access. Writes and bound actions require Operator access. Supervisor inherits Viewer and Operator scopes but has no exclusive v1.0 action.

## Local execution

```bash
npm ci
npm start
```

Open the CAP index at `http://localhost:4004`. To start the generated Fiori app in watch mode:

```bash
npm run watch-smartlogistics-fiori
```

Local authentication uses the mock `viewer`, `operator` and `supervisor` users defined in `package.json`. These are development-only credentials.

## Tests

```bash
npm test
```

Validated result: **8 passing tests**. The suite covers read access, authorization, AI Assistant access, local grounded sources, delivery, incident resolution, invalid dates and duplicate purchase-order protection. GitHub Actions runs the suite automatically for CAP changes on pushes to `main` and pull requests. [`test.http`](test.http) contains manual API scenarios.

## AI modes

- Default `mock`: deterministic local behavior; no cloud secret required.
- `SMARTLOGISTICS_AI_MODE=sap`: SAP AI SDK orchestration; requires a valid SAP AI Core service binding or development credential supplied outside Git.

The local knowledge retriever is lexical and file-based. It is not a vector database and is not SAP Document Grounding. SAP Document Grounding was evaluated separately in Generative AI Hub Basic Trial.

## Build and deployment

The MTA deploys the CAP service, HANA deployer, HTML5 content, XSUAA and Destination resources. Build outputs (`gen`, `dist`, `mta_archives`, `*.mtar`) and credentials are ignored and must not be committed.
