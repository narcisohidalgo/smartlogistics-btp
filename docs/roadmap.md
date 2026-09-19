# Implementation Roadmap

| Phase | Scope | Exit criterion |
|---:|---|---|
| 0 | Repository, scope, architecture, conventions and backlog | Foundation documents reviewed and initial commit ready |
| 1 | SAP BTP environment | Required accounts, entitlements, services and development tools verified |
| 2 | ABAP Cloud core | RAP purchase-order business object exposed through OData V4 |
| 3 | Fiori Orders | Purchase-order List Report/Object Page works against RAP |
| 4 | CAP extension | Shipment, tracking, incident and recommendation services work locally |
| 5 | SAP HANA Cloud | CAP schema deployed and data persists in HANA Cloud |
| 6 | Order integration | `SL_ORDER_SYNC` creates a shipment from an approved order |
| 7 | Weather integration | `SL_WEATHER_RISK` creates an incident for risky weather |
| 8 | Fiori Logistics | Shipment and incident pages show the integrated data |
| 9 | AI analyzer | Structured AI recommendation generated and persisted |
| 10 | AI assistant | SAPUI5 freestyle assistant answers logistics questions |
| 11 | RAG | Answers are grounded in project policies with citations/traceability |
| 12 | Security | Roles, XSUAA, DCL, destinations and trust verified |
| 13 | Testing | Critical backend, integration and UI paths are automated |
| 14 | Portfolio | README, diagrams, screenshots and demo video are polished |
| 15 | Presentation | CV and LinkedIn descriptions prepared from verified results |

## Delivery principle

Each phase must leave a demonstrable increment. If a paid or time-limited service is unavailable, the repository must retain a mock or adapter that keeps local development reproducible without misrepresenting the deployed capabilities.
