# Purchase Orders App

Implemented Fiori elements List Report/Object Page consuming the ABAP RAP OData V4 service.

The application supports the purchase-order header/item composition, draft editing, annotations, validations, calculations and the **Send to Logistics** integration action exposed by the ABAP behavior. It was validated through the RAP service-binding preview in the SAP BTP ABAP Environment.

The UI is generated from the RAP service and annotations. Its ABAP CDS, metadata extensions, behaviors and OData service sources are now published under [ABAP Cloud source](../../abap/smartlogistics-core/src/). The Fiori Orders UI itself is not exported as a standalone UI5 application module.

## Portfolio evidence

- [Purchase Orders List Report](../../docs/screenshots/abap-rap/abap-rap-purchase-orders-list.png)
- [Purchase Order Object Page](../../docs/screenshots/abap-rap/abap-rap-purchase-order-object-page.png)
- [Published OData V4 service binding](../../docs/screenshots/abap-rap/abap-rap-odata-v4-service-binding.png)
