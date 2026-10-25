# SmartLogistics ABAP Core

The ABAP Cloud core is the system of record for procurement. It was implemented and validated in the SAP BTP ABAP Environment.

The public portfolio intentionally documents the ABAP implementation rather than publishing environment-specific ABAP source artifacts. Curated screenshots provide verifiable evidence of the RAP application and service binding.

## Implemented business scope

- Suppliers
- Products
- Purchase orders
- Composed purchase-order items
- Draft-enabled create/edit flow
- Initial purchase-order and logistics-integration status, plus monetary calculations
- Supplier, product, quantity and date validations
- `Send to Logistics` integration action, with logistics status changing from `NEW` to `SENT` after a successful handoff
- OData V4 exposure and Fiori elements preview

Supplier and product data are supporting persistence/CDS master data in v1.0. The managed RAP business object is the purchase order with its composed items.

Custom procurement DCL/instance-authorization rules are not part of the delivered v1.0 implementation; the RAP authorization hooks are present but contain no custom enforcement.

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
