# SmartLogistics ABAP Core

The ABAP Cloud core is the system of record for procurement. It was implemented and validated in the SAP BTP ABAP Environment; the repository currently documents the objects because an abapGit export was not added to this portfolio.

## Implemented business scope

- Suppliers
- Products
- Purchase orders
- Composed purchase-order items
- Draft-enabled create/edit flow
- Initial status and monetary calculations
- Supplier, product, quantity and date validations
- Approve and cancel actions
- Authorization/DCL
- OData V4 exposure and Fiori elements preview

## Main object families

- Persistence tables with the `ZSL_` prefix
- Interface views including `ZI_SL_PURCHASEORDER` and `ZI_SL_PURCHASEORDERITEM`
- Consumption/projection views including `ZC_SL_PURCHASEORDER` and `ZC_SL_PURCHASEORDERITEM`
- Managed behavior and behavior pool `ZBP_I_SL_PURCHASEORDER`
- Service definition `ZUI_SL_PURCHASEORDER`
- Published OData V4 service binding

The exact source remains in the ABAP trial system. Portfolio screenshots and an optional source export are Phase 14 follow-ups; this directory must not imply that ABAP source files are already versioned here.
