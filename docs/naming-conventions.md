# Naming Conventions

## General

- Repository and folders: lowercase kebab-case.
- Business entities: singular PascalCase (`PurchaseOrder`).
- Service operations: lower camelCase (`sendToLogistics`, `analyzeIncident`).
- Environment-specific values must be externalized.
- Secrets, service keys and credentials must never be committed.

## ABAP Cloud

The project prefix is `ZSL`.

| Object | Pattern | Example |
|---|---|---|
| Package | `ZSL_*` | `ZSL_CORE` |
| Database table | `ZSL_*` | `ZSL_PO` |
| CDS interface view | `ZI_SL_*` | `ZI_SL_PURCHASEORDER` |
| CDS projection view | `ZC_SL_*` | `ZC_SL_PURCHASEORDER` |
| Behavior pool | `ZBP_I_SL_*` | `ZBP_I_SL_PURCHASEORDER` |
| Service definition | `ZUI_SL_*` | `ZUI_SL_PURCHASEORDER` |
| DCL role | `ZR_SL_*` | `ZR_SL_PURCHASEORDER` |

## CAP and APIs

- CDS namespace: `smartlogistics`.
- Service name: `LogisticsService`.
- Service path: `/logistics`.
- Environment variables use uppercase snake case.
- API payload properties follow the CDS-generated convention unless an integration contract explicitly maps them.

## Integration Suite

| Artifact | Delivered name / convention |
|---|---|
| Package | `SmartLogistics` |
| Order synchronization iFlow | `ABAP PO to CAP Shipment` |
| Weather integration | Direct CAP → Open-Meteo call; no weather iFlow in v1.0 |
| Shared integration artifacts | `SL_*` prefix where applicable |

## Git

- Default branch: `main`.
- Feature branches: `feature/SL-###-short-description`.
- Fix branches: `fix/SL-###-short-description`.
- Conventional commit prefixes: `feat`, `fix`, `docs`, `test`, `refactor`, `build`, `ci`, `chore`.
- Example: `feat(cap): add shipment entity (SL-040)`.
