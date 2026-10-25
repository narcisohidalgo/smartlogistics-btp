# API Testing

The reproducible manual API suite is [`cap/smartlogistics-extension/test.http`](../cap/smartlogistics-extension/test.http), which can be executed from SAP Business Application Studio or a compatible REST client.

Validated scenarios include:

- unauthenticated request → `401`;
- Viewer read → `200`;
- Viewer AI action → `403`;
- Operator AI action → `200`;
- local grounded answer with sources → `200`;
- mark shipment delivered → `200`, repeated action → `400`;
- resolve incident → `200`, repeated action → `400`;
- invalid planned dates → `400`;
- duplicate purchase-order shipment → `409`.

The Basic authorization values in `test.http` encode the local CAP mock users from `package.json`; they are not SAP BTP credentials. No production tokens or service keys belong in this directory.

The checked-in HTTP suite is the canonical manual API test asset for v1.0; a Postman collection is not required to reproduce the documented scenarios.
