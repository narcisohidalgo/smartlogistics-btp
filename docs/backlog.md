# Initial Backlog

Priority uses `P0` for the end-to-end path, `P1` for portfolio quality, and `P2` for later enhancements.

| ID | Priority | User story / technical enabler | Acceptance summary | Phase |
|---|---|---|---|---:|
| SL-001 | P0 | Define and publish the project foundation | Scope, architecture, ADR, roadmap and conventions are versioned | 0 |
| SL-010 | P0 | Prepare SAP BTP development landscape | Services and limitations are recorded; BAS/ADT/CF access verified | 1 |
| SL-020 | P0 | Maintain suppliers and products | Valid master data can be created and read in RAP | 2 |
| SL-021 | P0 | Create a purchase order with items | Draft-capable composition persists valid header and items | 2 |
| SL-022 | P0 | Calculate monetary amounts | Item and total amounts update deterministically | 2 |
| SL-023 | P0 | Approve or cancel an order | State rules and action availability are enforced | 2 |
| SL-024 | P1 | Protect procurement operations | DCL and business-role behavior are demonstrated | 2 |
| SL-030 | P0 | Use a Fiori purchase-order app | List Report/Object Page supports the procurement flow | 3 |
| SL-040 | P0 | Manage logistics entities in CAP | Shipment, event, incident and recommendation APIs work | 4 |
| SL-050 | P0 | Persist extension data in HANA Cloud | Cloud deployment retains data across restarts | 5 |
| SL-060 | P0 | Synchronize approved orders | An approved order creates exactly one shipment | 6 |
| SL-061 | P1 | Recover from integration failure | Failed messages are observable and safely retryable | 6 |
| SL-070 | P0 | Evaluate weather risk | Normalized risky weather creates an incident | 7 |
| SL-080 | P0 | Monitor logistics in Fiori | Shipment Object Page shows events, incidents and risk | 8 |
| SL-090 | P0 | Generate an incident recommendation | Structured result is validated and persisted | 9 |
| SL-100 | P1 | Ask logistics questions | SAPUI5 assistant handles defined portfolio questions | 10 |
| SL-110 | P1 | Ground answers in company policies | Retrieved sources support and accompany the answer | 11 |
| SL-120 | P0 | Enforce end-to-end authorization | Procurement, logistics and admin access are separated | 12 |
| SL-130 | P1 | Automate critical tests | Core rules and happy path run repeatably | 13 |
| SL-140 | P1 | Prepare portfolio evidence | Screenshots, demo script and diagrams match the implementation | 14 |
| SL-150 | P2 | Add advanced logistics capabilities | Only considered after v1.0 is complete | 15+ |
