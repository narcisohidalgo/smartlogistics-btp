# Portfolio Screenshots

This directory contains the curated visual evidence used to demonstrate the delivered SmartLogistics BTP capabilities.

## ABAP Cloud / RAP

- [Purchase Orders List Report](abap-rap/abap-rap-purchase-orders-list.png)
- [Purchase Order Object Page](abap-rap/abap-rap-purchase-order-object-page.png)
- [Published OData V4 service binding](abap-rap/abap-rap-odata-v4-service-binding.png)

## SAP Integration Suite

- [ABAP purchase order sent to logistics](integration-suite/abap-purchase-order-sent-to-logistics.png)
- [ABAP-to-CAP iFlow](integration-suite/integration-suite-abap-to-cap-iflow.png)
- [Successful message processing](integration-suite/integration-suite-message-processing-completed.png)
- [End-to-end shipment created in CAP](integration-suite/end-to-end-abap-to-cap-shipment.png)

## Fiori Logistics

- [Shipment Object Page](fiori-logistics/fiori-logistics-shipment-object-page.png)

## Weather / Open-Meteo

- [Shipment before weather refresh](weather/open-meteo-weather-before-refresh.png)
- [Shipment after weather refresh](weather/open-meteo-weather-after-refresh.png)

## AI

- [AI Incident Analyzer — local reproducible result](ai/ai-incident-analyzer-local-result.png)
- [AI Assistant — grounded answer and sources](ai/ai-assistant-grounded-sources.png)
- [SAP Document Grounding — grounded response](ai/sap-document-grounding-response.png)
- [SAP Document Grounding — successful trace](ai/sap-document-grounding-trace.png)

The SAP Document Grounding screenshots document a separate SAP Generative AI Hub Basic Trial / SAP AI Launchpad validation. They are not evidence that the application's local lexical retriever is SAP Document Grounding.

## Security

- [SAP BTP Role Collections](security/btp-role-collections.png)
- [Unauthenticated CAP request — 401](security/cap-xsuaa-unauthorized-401.png)

## Testing

- [Historical automated CAP test run — 8 passing](testing/cap-automated-tests-8-passed.png). The current GitHub Actions regression suite runs **10 tests**, including two additional update-validation cases; see the [latest workflow runs](https://github.com/narcisohidalgo/smartlogistics-btp/actions/workflows/cap-tests.yml).
- [Viewer blocked from Operator action — 403](testing/manual-api-rbac-403.png)

## Sanitization

The committed evidence is intended for a public portfolio. Future screenshots must also be reviewed before commit to avoid exposing service keys, access tokens, client secrets, private certificates or other credentials. Environment-specific identifiers should be omitted when they do not add technical value.
