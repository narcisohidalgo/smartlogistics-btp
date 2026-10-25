@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SmartLogistics Purchase Order Interface'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_SL_PURCHASEORDER
  as select from zsl_po

  composition [0..*] of ZI_SL_PURCHASEORDERITEM as _Items
  association [1..1] to ZI_SL_SUPPLIER          as _Supplier on $projection.SupplierUuid = _Supplier.SupplierUuid

{
  key purchase_order_uuid   as PurchaseOrderUuid,
      purchase_order_id     as PurchaseOrderId,
      supplier_uuid         as SupplierUuid,
      order_date            as OrderDate,
      delivery_date         as DeliveryDate,
      status                as Status,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount          as TotalAmount,

      currency_code         as CurrencyCode,

      created_by            as CreatedBy,
      created_at            as CreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt,
      logistics_status      as LogisticsStatus,

      _Supplier,
      _Items
}
