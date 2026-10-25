@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SmartLogistics Product Interface'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_SL_PRODUCT
  as select from zsl_product
{
  key product_uuid          as ProductUuid,
      @ObjectModel.text.element: [ 'Name' ]
      product_id            as ProductId,
      name                  as Name,
      description           as Description,
      category              as Category,

      unit_of_measure       as UnitOfMeasure,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price            as UnitPrice,

      currency_code         as CurrencyCode,

      active                as Active,

      created_by            as CreatedBy,
      created_at            as CreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt
}
