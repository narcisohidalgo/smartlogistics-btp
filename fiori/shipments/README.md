# Fiori Logistics App

Implemented Fiori elements List Report/Object Page for the CAP logistics service.

The deployable source lives in [`cap/smartlogistics-extension/app/smartlogistics-fiori`](../../cap/smartlogistics-extension/app/smartlogistics-fiori/).

## Delivered experience

- Shipment list and Object Page.
- Route, dates, carrier, status and weather risk.
- Package totals calculated by CAP.
- Related incidents and incident operations.
- Weather refresh through Open-Meteo.
- Mark-as-delivered action.
- AI Incident Analyzer action.
- Embedded SAPUI5 AI Assistant dialog.
- Deployment to HTML5 Application Repository and launch from SAP Build Work Zone.

Authentication is performed with XSUAA. The Work Zone destination forwards the JWT to CAP, where `@requires` and `@restrict` enforce Viewer and Operator permissions.
