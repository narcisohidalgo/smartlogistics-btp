@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@UI.headerInfo: {
  typeName: 'Purchase Order',
  typeNamePlural: 'Purchase Orders',
  title: {
    type: #STANDARD,
    value: 'PurchaseOrderId'
  },
  description: {
    value: 'Status'
  }
}

define root view entity ZC_SL_PURCHASEORDER
  provider contract transactional_query
  as projection on ZI_SL_PURCHASEORDER
{
          @UI.hidden: true
  key     PurchaseOrderUuid,

          @UI.lineItem:       [{ position: 10, label: 'Purchase Order' }]
          @UI.identification: [{ position: 10, label: 'Purchase Order' }]
          @UI.selectionField: [{ position: 10 }]
          PurchaseOrderId,

          @UI.lineItem:       [{ position: 20, label: 'Supplier' }]
          @UI.identification: [{ position: 20, label: 'Supplier' }]
          @Consumption.valueHelpDefinition: [
            {
              entity: {
                name: 'ZI_SL_SUPPLIER',
                element: 'SupplierUuid'
              },
              useForValidation: true
            }
          ]
          @ObjectModel.text.element: [ 'SupplierName' ]
          @UI.textArrangement: #TEXT_ONLY
          SupplierUuid,

          @UI.hidden: true
          _Supplier.Name as SupplierName,

          @UI.lineItem:       [{ position: 30, label: 'Order Date' }]
          @UI.identification: [{ position: 30, label: 'Order Date' }]
          @UI.selectionField: [{ position: 20 }]
          OrderDate,

          @UI.lineItem:       [{ position: 40, label: 'Delivery Date' }]
          @UI.identification: [{ position: 40, label: 'Delivery Date' }]
          DeliveryDate,

          @UI.lineItem:       [{ position: 50, label: 'Status' }]
          @UI.identification: [{ position: 50, label: 'Status' }]
          @UI.selectionField: [{ position: 30 }]
          @ObjectModel.text.element: [ 'StatusText' ]
          @UI.textArrangement: #TEXT_ONLY
          Status,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_SL_PO_STATUS_TEXT'
          @UI.hidden: true
  virtual StatusText          : abap.char(20),

          @UI.lineItem:       [{ position: 60, label: 'Total Amount' }]
          @UI.identification: [{ position: 60, label: 'Total Amount' }]
          @Semantics.amount.currencyCode: 'CurrencyCode'
          TotalAmount,

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

          @ObjectModel.text.element: [ 'LogisticsStatusText' ]
          @UI.textArrangement: #TEXT_ONLY
          LogisticsStatus,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_SL_PO_STATUS_TEXT'
          @UI.hidden: true
  virtual LogisticsStatusText : abap.char(20),

          _Supplier,
          _Items : redirected to composition child ZC_SL_PURCHASEORDERITEM
}
