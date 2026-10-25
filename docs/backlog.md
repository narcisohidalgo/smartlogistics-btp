# SmartLogistics Backlog

Priority uses `P0` for the end-to-end path, `P1` for portfolio quality and `P2` for later enhancements.

| ID | Priority | Deliverable | Status | Evidence summary |
|---|---|---|:---:|---|
| SL-001 | P0 | Project foundation | ✅ | Scope, architecture, ADR, roadmap and conventions |
| SL-010 | P0 | SAP BTP landscape | ✅ | BTP services plus BAS, ADT and CF access verified |
| SL-020 | P0 | Suppliers and products | ✅ | ABAP RAP master data |
| SL-021 | P0 | Purchase order with items | ✅ | Draft composition and persistence |
| SL-022 | P0 | Monetary calculations | ✅ | Item and header totals |
| SL-023 | P0 | Order lifecycle | ✅ | Approve/cancel actions and state rules |
| SL-024 | P1 | Procurement authorization | ✅ | DCL/authorization behavior |
| SL-030 | P0 | Fiori purchase-order app | ✅ | List Report/Object Page over RAP |
| SL-040 | P0 | CAP logistics service | ✅ | Shipment, package and incident APIs/actions |
| SL-050 | P0 | HANA Cloud persistence | ✅ | HDI-backed deployment |
| SL-060 | P0 | Approved-order synchronization | ✅ | Published ABAP-to-CAP Integration Suite flow |
| SL-061 | P1 | Integration observability/retry | ◐ | Message-processing evidence captured; automated retry/dead-letter handling remains a future enhancement |
| SL-070 | P0 | Weather risk | ✅ | Direct CAP/Open-Meteo integration and deterministic classification |
| SL-080 | P0 | Fiori Logistics | ✅ | Logistics UI deployed and exposed through Work Zone |
| SL-090 | P0 | AI Incident Analyzer | ✅ | Structured analyzer with SAP and local modes |
| SL-100 | P1 | AI Assistant | ✅ | Shipment-aware SAPUI5 dialog extension |
| SL-110 | P1 | Grounded answers | ✅ | SAP Document Grounding trial plus clearly separated local lexical retrieval |
| SL-120 | P0 | End-to-end authorization | ✅ | XSUAA, roles, technical identity, restrictions and JWT forwarding |
| SL-130 | P1 | Critical tests | ✅ | 8 automated tests plus manual HTTP scenarios |
| SL-140 | P1 | Portfolio evidence | ✅ | Architecture, 18 curated screenshots, demo guide and final documentation audit completed |
| SL-150 | P1 | CV and LinkedIn presentation | ⏳ | Starts after the audited portfolio repository is finalized |

Legend: ✅ complete · ◐ partially implemented/evidenced · ▶ in progress · ⏳ not started.
