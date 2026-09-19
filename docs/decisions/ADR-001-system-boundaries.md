# ADR-001: Separate the Transactional Core from the Logistics Extension

- **Status:** Accepted
- **Date:** 2026-09-19

## Context

The portfolio must demonstrate ABAP Cloud and SAP CAP without duplicating the same application in two technology stacks. Clear ownership is also required to explain clean-core and side-by-side extensibility in an interview.

## Decision

ABAP Cloud is the system of record for suppliers, products, purchase orders and order items. SAP CAP is the system of record for shipments, tracking events, incidents and AI recommendations.

Integration Suite connects both domains and external services. CAP may store immutable external identifiers and the minimum integration snapshot needed for traceability, but it does not become a second writable purchase-order master.

Fiori applications consume the service that owns each capability. A unified launchpad provides navigation; a single backend facade is not required merely to hide intentional service boundaries.

## Consequences

### Positive

- Each certification maps to a meaningful responsibility.
- The design avoids conflicting sources of truth.
- The architecture supports clean-core explanations.
- Components can be developed and tested independently.

### Trade-offs

- Cross-system views need composition, navigation or explicit API calls.
- Integration failures and eventual consistency must be visible.
- Authentication and destination configuration are more involved than in a monolith.
