@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SmartLogistics PO Item Interface'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_SL_PURCHASEORDERITEM
  as select from zsl_po_item

  association        to parent ZI_SL_PURCHASEORDER as _PurchaseOrder on $projection.PurchaseOrderUuid = _PurchaseOrder.PurchaseOrderUuid

  association [1..1] to ZI_SL_PRODUCT              as _Product       on $projection.ProductUuid = _Product.ProductUuid

{
  key item_uuid             as ItemUuid,
      purchase_order_uuid   as PurchaseOrderUuid,
      item_number           as ItemNumber,
      product_uuid          as ProductUuid,

      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      quantity              as Quantity,

      unit_of_measure       as UnitOfMeasure,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price            as UnitPrice,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      net_amount            as NetAmount,

      currency_code         as CurrencyCode,

      created_by            as CreatedBy,
      created_at            as CreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt,

      _Product,
      _PurchaseOrder
}
