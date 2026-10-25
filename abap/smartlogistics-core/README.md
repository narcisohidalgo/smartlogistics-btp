# SmartLogistics ABAP Core

The ABAP Cloud core is the system of record for procurement. It was implemented and validated in the SAP BTP ABAP Environment.

The public portfolio intentionally documents the ABAP implementation rather than publishing environment-specific ABAP source artifacts. Curated screenshots provide verifiable evidence of the RAP application and service binding.

## Implemented business scope

- Suppliers
- Products
- Purchase orders
- Composed purchase-order items
- Draft-enabled create/edit flow
- Initial status and monetary calculations
- Supplier, product, quantity and date validations
- Approve/cancel lifecycle actions
- Send-to-logistics integration action
- Authorization/DCL
- OData V4 exposure and Fiori elements preview

## Main object families

- Persistence tables with the `ZSL_` prefix
- Interface views including `ZI_SL_PURCHASEORDER` and `ZI_SL_PURCHASEORDERITEM`
- Consumption/projection views including `ZC_SL_PURCHASEORDER` and `ZC_SL_PURCHASEORDERITEM`
- Managed behavior and behavior pool `ZBP_I_SL_PURCHASEORDER`
- Service definition `ZUI_SL_PURCHASEORDER`
- Published OData V4 service binding

## Portfolio evidence

- [Purchase Orders List Report](../../docs/screenshots/abap-rap/abap-rap-purchase-orders-list.png)
- [Purchase Order Object Page](../../docs/screenshots/abap-rap/abap-rap-purchase-order-object-page.png)
- [OData V4 service binding](../../docs/screenshots/abap-rap/abap-rap-odata-v4-service-binding.png)
