# SAP Integration Suite

## Implemented flow

The order synchronization flow connects the ABAP Cloud RAP application with the CAP logistics API. It was configured and published in SAP Integration Suite and validated end to end.

The delivered iFlow is **`ABAP PO to CAP Shipment`**. Its responsibility is to:

1. receive the purchase-order payload sent from ABAP Cloud;
2. transform it to the CAP shipment creation contract;
3. call the protected CAP endpoint;
4. expose message-processing failures for diagnosis rather than silently losing the message.

The repository documents the integration but does not contain exported tenant artifacts or security material. Credentials remain in BTP service bindings/security material.

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
