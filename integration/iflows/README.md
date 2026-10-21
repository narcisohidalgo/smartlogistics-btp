# SAP Integration Suite

## Implemented flow

The order synchronization flow connects the ABAP Cloud RAP service with the CAP logistics API. It was configured and published in SAP Integration Suite and validated end to end.

Its responsibility is to:

1. obtain the approved purchase-order payload from ABAP Cloud;
2. transform it to the CAP shipment creation contract;
3. call the protected CAP endpoint;
4. expose failures for diagnosis rather than silently losing the message.

The repository documents the integration but does not contain exported tenant artifacts or security material. Credentials remain in BTP service bindings/security material.

## Weather boundary

The original architecture considered a second `SL_WEATHER_RISK` iFlow. The delivered v1.0 instead calls Open-Meteo directly from the CAP `refreshWeather` action. Therefore this repository must not claim that weather integration is implemented in Integration Suite.

Phase 14 still needs sanitized screenshots or an exported, secret-free integration package if one is suitable for public distribution.
