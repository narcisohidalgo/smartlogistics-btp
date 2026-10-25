@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SmartLogistics Supplier Interface'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SL_SUPPLIER as select from zsl_supplier
{
    key supplier_uuid as SupplierUuid,
    @ObjectModel.text.element: [ 'Name' ]
    supplier_id as SupplierId,
    name as Name,
    country as Country,
    city as City,
    email as Email,
    phone as Phone,
    status as Status,
    created_by as CreatedBy,
    created_at as CreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt
}
