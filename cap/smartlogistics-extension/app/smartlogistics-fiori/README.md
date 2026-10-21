# SmartLogistics Fiori Application

Fiori elements List Report/Object Page for the CAP `Shipments` entity, generated with SAP Fiori tools and extended with SAPUI5 actions.

## Implemented features

- Shipment list and Object Page over `/logistics/` OData V4.
- Package and incident information through CDS annotations.
- `Mark as Delivered` and weather refresh actions.
- AI Incident Analyzer action for a selected incident.
- Shipment-aware AI Assistant dialog with conversation history, suggested actions and source labels.
- XSUAA-protected routing to CAP through the `smartlogistics-cap-api` destination.
- HTML5 Application Repository deployment and SAP Build Work Zone access.

## Local start

From `cap/smartlogistics-extension`:

```bash
npm ci
npm run watch-smartlogistics-fiori
```

The app was generated as a List Report Page V4 with the `sap_horizon` theme. `AssistantActions.js` and `CustomActions.js` contain the custom SAPUI5 extensions.

## Security

The application route requires XSUAA in the deployed environment. The Destination service forwards the authenticated JWT to CAP; CAP remains responsible for enforcing Viewer/Operator authorization.
