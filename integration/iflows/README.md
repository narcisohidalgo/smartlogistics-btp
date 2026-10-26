# SAP Integration Suite

## Implemented flow

The order synchronization flow connects the ABAP Cloud RAP application with the CAP logistics API. It was configured and published in SAP Integration Suite and validated end to end.

The delivered iFlow is **`ABAP PO to CAP Shipment`**. Its responsibility is to:

1. receive the purchase-order payload sent from ABAP Cloud;
2. transform it to the CAP shipment creation contract;
3. call the protected CAP endpoint;
4. expose message-processing failures for diagnosis rather than silently losing the message.

The repository includes a **sanitized export of the iFlow**. Its original tenant-specific CAP receiver endpoint and OAuth2 credential alias have been replaced by non-operational example settings. The unmodified tenant export and actual security material are **not published**.

## Source and importable artifact

- [Sanitized iFlow ZIP](ABAP_PO_to_CAP_Shipment_sanitized.zip) — SAP Cloud Integration artifact with the original seven export members (receiver endpoint and credential alias redacted).
- [Groovy message mapping](abap-po-to-cap-shipment/MapPurchaseOrder.groovy) — readable version of the script embedded in the archive.

The sender adapter is HTTPS with role-based authorization (`ESBMessaging.send`). The receiver is HTTP POST to the CAP `LogisticsService` `Shipments` endpoint using an OAuth2 Client Credentials alias. `MapPurchaseOrder.groovy` maps `purchaseOrderId`, `orderDate` and `deliveryDate` to a shipment payload (the incoming `supplier` field is not used by this v1 mapping); the shipped v1 script uses demonstration defaults for carrier, route and tracking data.

**To import:** in SAP Cloud Integration, import the sanitized ZIP as an integration flow, configure its receiver adapter URL to point to *your own* CAP `Shipments` endpoint, create/assign your own OAuth2 Client Credentials security material (and required roles/destinations), and only then deploy and test it. The placeholders `https://example.invalid/logistics/Shipments` and `PORTFOLIO_REPLACE_WITH_OAUTH2_ALIAS` are intentionally nonfunctional. Never commit real tenant hostnames or credential material. The sanitized export has been checked for archive integrity and BPMN XML validity, but importing and deploying this modified archive in a new tenant **have not been verified**.

## Technical identity

SAP Integration Suite authenticates to CAP using a technical client. CAP recognizes the resulting technical identity as `system-user` and restricts it to creating `Shipments`; interactive Viewer/Operator permissions are not granted to the integration identity.

## Weather boundary

The original architecture considered a second weather-risk iFlow. The delivered v1.0 instead calls Open-Meteo directly from the CAP `refreshWeather` action. Therefore this repository does not claim that weather integration is implemented in SAP Integration Suite.

## Portfolio evidence

The public evidence set includes the deployed iFlow, successful message processing, the purchase-order handoff and the resulting CAP shipment:

- [ABAP-to-CAP iFlow](../../docs/screenshots/integration-suite/integration-suite-abap-to-cap-iflow.png)
- [Successful message processing](../../docs/screenshots/integration-suite/integration-suite-message-processing-completed.png)
- [Purchase order sent to logistics](../../docs/screenshots/integration-suite/abap-purchase-order-sent-to-logistics.png)
- [Resulting CAP shipment](../../docs/screenshots/integration-suite/end-to-end-abap-to-cap-shipment.png)
