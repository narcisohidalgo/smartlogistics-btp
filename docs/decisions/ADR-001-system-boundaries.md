# ADR-001: Separate the Transactional Core from the Logistics Extension

- **Status:** Accepted
- **Date:** 2026-09-19
- **Implementation review:** 2026-10-25

## Context

The portfolio must demonstrate ABAP Cloud and SAP CAP without duplicating the same application in two technology stacks. Clear ownership is also required to explain clean-core and side-by-side extensibility in an interview.

## Decision

ABAP Cloud is the system of record for suppliers, products, purchase orders and purchase-order items.

SAP CAP is the system of record for the delivered logistics domain: shipments, packages and incidents. CAP may store the immutable external purchase-order identifier and the minimum integration context required for logistics traceability, but it does not become a second writable purchase-order master.

SAP Integration Suite connects the procurement and logistics domains. Open-Meteo is consumed directly by CAP for weather enrichment.

Fiori applications consume the service that owns each capability. SAP Build Work Zone provides the common launch experience; a single backend facade is not required merely to hide intentional service boundaries.

The original design considered persisted `TrackingEvents` and `AIRecommendations`. They are not part of the delivered v1.0 data model. AI analysis is returned through service actions instead of being persisted as a separate recommendation entity.

## Consequences

### Positive

- Each certification maps to a meaningful responsibility.
- The design avoids conflicting sources of truth.
- The architecture supports clean-core explanations.
- Components can be developed and tested independently.
- The public portfolio reflects the implementation actually delivered.

### Trade-offs

- Cross-system views need composition, navigation or explicit API calls.
- Integration failures and eventual consistency must be visible.
- Authentication and destination configuration are more involved than in a monolith.
- Tracking history and persisted AI recommendations would require additional domain entities in a future version.
