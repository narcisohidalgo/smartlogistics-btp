CLASS zcl_sl_seed_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_sl_seed_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    TRY.

        DELETE FROM zsl_supplier.
        DELETE FROM zsl_product.

        DATA suppliers TYPE TABLE OF zsl_supplier.
        DATA products  TYPE TABLE OF zsl_product.

        suppliers = VALUE #(
          (
            client        = sy-mandt
            supplier_uuid = cl_system_uuid=>create_uuid_x16_static( )
            supplier_id   = 'SUP0000001'
            name          = 'Green Fields Logistics'
            country       = 'ESP'
            city          = 'Cordoba'
            email         = 'contact@greenfields.example'
            phone         = '+34957000001'
            status        = 'A'
          )
          (
            client        = sy-mandt
            supplier_uuid = cl_system_uuid=>create_uuid_x16_static( )
            supplier_id   = 'SUP0000002'
            name          = 'Iberia Industrial Supply'
            country       = 'ESP'
            city          = 'Madrid'
            email         = 'sales@iberiaindustrial.example'
            phone         = '+34910000002'
            status        = 'A'
          )
          (
            client        = sy-mandt
            supplier_uuid = cl_system_uuid=>create_uuid_x16_static( )
            supplier_id   = 'SUP0000003'
            name          = 'NorthWind Components'
            country       = 'DEU'
            city          = 'Hamburg'
            email         = 'info@northwind.example'
            phone         = '+49400000003'
            status        = 'A'
          )
        ).

        products = VALUE #(
          (
            client          = sy-mandt
            product_uuid    = cl_system_uuid=>create_uuid_x16_static( )
            product_id      = 'PRD0000001'
            name            = 'Temperature Sensor'
            description     = 'IoT temperature sensor'
            category        = 'SENSORS'
            unit_of_measure = 'EA'
            unit_price      = '49.90'
            currency_code   = 'EUR'
            active          = abap_true
          )
          (
            client          = sy-mandt
            product_uuid    = cl_system_uuid=>create_uuid_x16_static( )
            product_id      = 'PRD0000002'
            name            = 'GPS Tracker'
            description     = 'GPS tracking device'
            category        = 'TRACKING'
            unit_of_measure = 'EA'
            unit_price      = '79.50'
            currency_code   = 'EUR'
            active          = abap_true
          )
          (
            client          = sy-mandt
            product_uuid    = cl_system_uuid=>create_uuid_x16_static( )
            product_id      = 'PRD0000003'
            name            = 'Packaging Box'
            description     = 'Industrial packaging box'
            category        = 'PACKAGING'
            unit_of_measure = 'EA'
            unit_price      = '5.25'
            currency_code   = 'EUR'
            active          = abap_true
          )
          (
            client          = sy-mandt
            product_uuid    = cl_system_uuid=>create_uuid_x16_static( )
            product_id      = 'PRD0000004'
            name            = 'Refrigerated Container'
            description     = 'Cold-chain logistics container'
            category        = 'CONTAINERS'
            unit_of_measure = 'EA'
            unit_price      = '1250.00'
            currency_code   = 'EUR'
            active          = abap_true
          )
        ).

        INSERT zsl_supplier FROM TABLE @suppliers.
        INSERT zsl_product  FROM TABLE @products.

        out->write( |Suppliers inserted: { lines( suppliers ) }| ).
        out->write( |Products inserted: { lines( products ) }| ).

      CATCH cx_uuid_error INTO DATA(lx_uuid).

        out->write(
          |UUID generation error: { lx_uuid->get_text( ) }|
        ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
