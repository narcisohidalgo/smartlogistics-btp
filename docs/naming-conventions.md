# Naming Conventions

## General

- Repository and folders: lowercase kebab-case.
- Business entities: singular PascalCase (`PurchaseOrder`).
- Service operations: lower camelCase (`approve`, `analyzeIncident`).
- Environment-specific values must be externalized.
- Secrets, service keys and credentials must never be committed.

## ABAP Cloud

Final ABAP object names depend on the namespace and package available in the target system. The project prefix is `ZSL` unless the system requires another registered namespace.

| Object | Pattern | Example |
|---|---|---|
| Package | `ZSL_*` | `ZSL_CORE` |
| Database table | `ZSL_*` | `ZSL_ORDER` |
| CDS interface view | `ZI_SL_*` | `ZI_SL_PurchaseOrder` |
| CDS projection view | `ZC_SL_*` | `ZC_SL_PurchaseOrder` |
| Behavior pool | `ZBP_I_SL_*` | `ZBP_I_SL_PURCHASEORDER` |
| Service definition | `ZUI_SL_*` | `ZUI_SL_PROCUREMENT` |
| DCL role | `ZR_SL_*` | `ZR_SL_PURCHASEORDER` |

## CAP and APIs

- CDS namespace: `smartlogistics.logistics`.
- Service name: `LogisticsService`.
- Public API path: `/odata/v4/logistics`.
- Environment variables use uppercase snake case.
- API payload properties follow the CDS-generated convention unless an integration contract explicitly maps them.

## Integration Suite

| Artifact | Name |
|---|---|
| Package | `SmartLogistics` |
| Order synchronization iFlow | `SL_ORDER_SYNC` |
| Weather-risk iFlow | `SL_WEATHER_RISK` |
| Shared value mappings | `SL_*` prefix |

## Git

- Default branch: `main`.
- Feature branches: `feature/SL-###-short-description`.
- Fix branches: `fix/SL-###-short-description`.
- Conventional commit prefixes: `feat`, `fix`, `docs`, `test`, `refactor`, `build`, `ci`, `chore`.
- Example: `feat(cap): add shipment entity (SL-040)`.
