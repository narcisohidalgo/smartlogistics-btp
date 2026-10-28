# SmartLogistics BTP — End-to-End Demo

This document provides a guided walkthrough of the SmartLogistics BTP solution and the main capabilities implemented across the project.

## 1. Project overview

SmartLogistics BTP is an end-to-end SAP BTP portfolio project that connects purchase-order management, logistics operations, enterprise integration, external weather data, security, and AI capabilities.

The solution combines SAP ABAP Cloud, SAP Cloud Application Programming Model (CAP), SAP Integration Suite, SAP HANA Cloud, SAP Fiori, SAP Build Work Zone, XSUAA, Open-Meteo, and Generative AI scenarios.

## 2. Purchase Order — ABAP Cloud

Start in the SAP Fiori Purchase Orders application backed by an ABAP Cloud RAP business object.

Open a purchase order and show its supplier, items, delivery information, total amount, and Logistics Status.

Explain that the RAP business object is exposed through an OData V4 service.

## 3. ABAP to CAP integration

From the Purchase Order Object Page, execute **Send to Logistics**.

The ABAP application sends the purchase-order information through SAP Integration Suite.

Show the **`ABAP PO to CAP Shipment`** iFlow and explain that it receives the purchase-order payload, maps it to the logistics data structure, and calls the CAP Logistics API.

Show the successful message-processing entry in SAP Integration Suite.

Return to the purchase order and show that its Logistics Status is now **Sent**.

## 4. Logistics application

Open SmartLogistics from SAP Build Work Zone.

Show the newly created shipment in the Fiori Logistics application.

Open the Shipment Object Page and explain that shipment data is provided by the CAP `LogisticsService` and persisted in SAP HANA Cloud through the application's HDI container.

## 5. Weather integration

Show the shipment before weather data has been retrieved.

Click **Refresh Weather**.

Explain that the CAP service calls the external Open-Meteo API directly.

Show the resulting forecast information, including weather risk, condition, temperature, precipitation, wind speed, and the last weather check.

This demonstrates how an external public API can be incorporated into the logistics workflow without routing the weather request through SAP Integration Suite.

## 6. AI capabilities

Show the **AI Incident Analyzer** using the reproducible local mode.

Select an incident and execute **Analyze Incident** to display the summary, probable cause, operational impact, priority, and recommended actions.

Then open the **AI Assistant** and ask an operational question.

Show that the response is grounded in SmartLogistics-owned knowledge documents and includes source traceability.

Clarify that the application provides a reproducible local AI mode, while integration with SAP AI services is prepared separately.

The application's local grounded assistant uses its own SmartLogistics knowledge documents and should not be confused with the separate SAP Document Grounding validation described in the next section.

## 7. SAP Document Grounding validation

Show the separate SAP Generative AI Hub Basic Trial / SAP AI Launchpad evidence.

Explain that SAP Document Grounding was validated through a real orchestration using a vector repository.

Show both the grounded response and the execution trace confirming that the grounding module completed successfully.

This validation is intentionally documented separately from the SmartLogistics application runtime and demonstrates SAP Document Grounding independently of the application's local retrieval implementation.

## 8. Security

Show the SAP BTP Role Collections:

- `SmartLogistics_Viewer`
- `SmartLogistics_Operator`
- `SmartLogistics_Supervisor`

Explain that the CAP service and Fiori application are protected with XSUAA and role-based authorization.

Show the unauthenticated request returning HTTP `401 Unauthorized` and the Viewer request to an Operator-only AI action returning HTTP `403 Forbidden`.

Explain that SAP Integration Suite authenticates to CAP using a technical client. CAP recognizes this technical identity as `system-user` and restricts it to creating `Shipments`, without granting the interactive Viewer or Operator permissions used by application users.

## 9. Testing

Show the automated CAP test suite.

Highlight that the tests cover:

- Viewer access
- Operator authorization
- AI Assistant access
- grounded responses and sources
- shipment delivery
- incident resolution
- invalid dates
- duplicate purchase orders
- invalid partial date updates
- duplicate purchase-order IDs introduced by updates

All ten automated tests pass successfully.

## 10. Architecture and closing

Finish with the SmartLogistics BTP architecture diagram.

Summarize the main end-to-end business flow:

**Purchase Order → SAP Integration Suite → CAP LogisticsService → Shipment**

Then explain the supporting runtime interactions:

- CAP persists logistics data in **SAP HANA Cloud**.
- CAP calls **Open-Meteo** for weather forecasts and risk information.
- CAP exposes the logistics service through **OData V4** to the Fiori application.
- **SAP Build Work Zone** provides the user entry point to the Fiori experience.
- **XSUAA** and SAP BTP Role Collections provide authentication and role-based authorization.
- AI capabilities complement the logistics scenario through incident analysis, grounded assistance, and the separate SAP Document Grounding validation.

SmartLogistics BTP demonstrates how SAP BTP development, integration, data, security, UX, external APIs, and AI capabilities can be combined into a single realistic end-to-end business scenario.