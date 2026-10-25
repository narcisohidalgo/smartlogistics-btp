@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SmartLogistics PO Item Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_SL_PURCHASEORDERITEM
  as projection on ZI_SL_PURCHASEORDERITEM
{
      @UI.hidden: true
  key ItemUuid,

      @UI.hidden: true
      PurchaseOrderUuid,

      @UI.lineItem:       [{ position: 10, label: 'Item' }]
      @UI.identification: [{ position: 10, label: 'Item' }]
      ItemNumber,

      @UI.lineItem:       [{ position: 20, label: 'Product' }]
      @UI.identification: [{ position: 20, label: 'Product' }]
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_SL_PRODUCT',
            element: 'ProductUuid'
          },
          additionalBinding: [
            {
              localElement: 'UnitOfMeasure',
              element: 'UnitOfMeasure',
              usage: #RESULT
            },
            {
              localElement: 'UnitPrice',
              element: 'UnitPrice',
              usage: #RESULT
            },
            {
              localElement: 'CurrencyCode',
              element: 'CurrencyCode',
              usage: #RESULT
            }
          ],
          useForValidation: true
        }
      ]
      @ObjectModel.text.element: [ 'ProductName' ]
      @UI.textArrangement: #TEXT_ONLY
      ProductUuid,

      @UI.hidden: true
      _Product.Name as ProductName,

      @UI.lineItem:       [{ position: 30, label: 'Quantity' }]
      @UI.identification: [{ position: 30, label: 'Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Quantity,

      @UI.hidden: true
      UnitOfMeasure,

      @UI.lineItem:       [{ position: 50, label: 'Unit Price' }]
      @UI.identification: [{ position: 50, label: 'Unit Price' }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      UnitPrice,

      @UI.lineItem:       [{ position: 60, label: 'Net Amount' }]
      @UI.identification: [{ position: 60, label: 'Net Amount' }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      NetAmount,

      @UI.hidden: true
      CurrencyCode,

      @UI.hidden: true
      CreatedBy,

      @UI.hidden: true
      CreatedAt,

      @UI.hidden: true
      LocalLastChangedBy,

      @UI.hidden: true
      LocalLastChangedAt,

      @UI.hidden: true
      LastChangedAt,

      _Product,
      _PurchaseOrder : redirected to parent ZC_SL_PURCHASEORDER
}
